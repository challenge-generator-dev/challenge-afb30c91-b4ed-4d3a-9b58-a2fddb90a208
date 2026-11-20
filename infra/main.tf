terraform {
  # Configuración de backend para almacenar estado remotamente
  # En producción, esto apuntaría a S3 con locking en DynamoDB
  backend "local" {
    path = "terraform.tfstate"
  }
}

# =============================================================================
# MÓDULO DYNAMODB - Tabla de órdenes
# =============================================================================
# Este módulo crea la tabla DynamoDB para almacenar las órdenes del sistema.
# La ruta es relativa a este archivo (infra/), por eso apunta a ./modules.
# La tabla utiliza PAY_PER_REQUEST para optimización de costos en desarrollo
# y claves de cifrado gestionadas por AWS KMS para seguridad en producción.

module "dynamodb" {
  source = "./modules/dynamodb"

  # Nombre de la tabla - configurable por entorno
  table_name = var.dynamodb_table_name

  # Modo de facturación - PAY_PER_REQUEST para desarrollo,
  # PROVISIONED para producción con tráfico predecible
  billing_mode = var.dynamodb_billing_mode

  # Clave de partición - orderId es el identificador único de cada orden
  hash_key = var.dynamodb_hash_key

  # Capacidades - solo aplicables en modo PROVISIONED
  # En PAY_PER_REQUEST estos valores son ignorados por AWS
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity

  # Habilitar streams para captura de cambios (CDC)
  # Útil para arquitecturas basadas en eventos y sincronización
  enable_stream    = var.dynamodb_enable_stream
  stream_view_type = var.dynamodb_stream_view_type

  # Etiquetas para identificación y costeo
  tags = merge(
    var.common_tags,
    var.dynamodb_tags,
    {
      Environment = var.app_environment
      ManagedBy   = "terraform"
      Component   = "orders-dynamodb"
    }
  )
}

# =============================================================================
# RECURSOS ADICIONALES DE INFRAESTRUCTURA
# =============================================================================

# Recurso KMS para cifrado de la tabla DynamoDB
# AWS cifra automáticamente con la clave por defecto, pero podemos
# usar una clave personalizada para control total de la rotación de claves
resource "aws_kms_key" "dynamodb_encryption" {
  count = var.enable_kms_encryption ? 1 : 0

  description             = var.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window
  enable_key_rotation     = true

  tags = merge(
    var.common_tags,
    {
      Name        = var.kms_key_alias
      Environment = var.app_environment
      ManagedBy   = "terraform"
    }
  )
}

resource "aws_kms_alias" "dynamodb_encryption" {
  count = var.enable_kms_encryption ? 1 : 0

  name          = var.kms_key_alias
  target_key_id = aws_kms_key.dynamodb_encryption[0].key_id
}

# =============================================================================
# ALERTAS Y MONITOREO CON CLOUDWATCH
# =============================================================================
# Alarmas para detectar problemas de rendimiento y capacidad

resource "aws_cloudwatch_metric_alarm" "read_throttle" {
  count = var.enable_alerts && !var.use_local_dynamodb ? 1 : 0

  alarm_name          = "${var.dynamodb_table_name}-read-throttle"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ReadThrottleEvents"
  namespace           = "AWS/DynamoDB"
  period              = var.metrics_interval_seconds
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "This alarm triggers when read throttle events occur"

  dimensions = {
    TableName = var.dynamodb_table_name
  }

  tags = merge(var.common_tags, { Name = "${var.dynamodb_table_name}-read-throttle" })
}

resource "aws_cloudwatch_metric_alarm" "write_throttle" {
  count = var.enable_alerts && !var.use_local_dynamodb ? 1 : 0

  alarm_name          = "${var.dynamodb_table_name}-write-throttle"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "WriteThrottleEvents"
  namespace           = "AWS/DynamoDB"
  period              = var.metrics_interval_seconds
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "This alarm triggers when write throttle events occur"

  dimensions = {
    TableName = var.dynamodb_table_name
  }

  tags = merge(var.common_tags, { Name = "${var.dynamodb_table_name}-write-throttle" })
}

resource "aws_cloudwatch_metric_alarm" "consumed_read_capacity" {
  count = var.enable_alerts && var.dynamodb_billing_mode == "PROVISIONED" ? 1 : 0

  alarm_name          = "${var.dynamodb_table_name}-read-capacity"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ConsumedReadCapacityUnits"
  namespace           = "AWS/DynamoDB"
  period              = var.metrics_interval_seconds
  statistic           = "Average"
  threshold           = var.dynamodb_read_capacity * (var.read_throttle_threshold_percent / 100)
  alarm_description   = "This alarm triggers when read capacity exceeds threshold"

  dimensions = {
    TableName = var.dynamodb_table_name
  }

  tags = merge(var.common_tags, { Name = "${var.dynamodb_table_name}-read-capacity" })
}

resource "aws_cloudwatch_metric_alarm" "consumed_write_capacity" {
  count = var.enable_alerts && var.dynamodb_billing_mode == "PROVISIONED" ? 1 : 0

  alarm_name          = "${var.dynamodb_table_name}-write-capacity"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ConsumedWriteCapacityUnits"
  namespace           = "AWS/DynamoDB"
  period              = var.metrics_interval_seconds
  statistic           = "Average"
  threshold           = var.dynamodb_write_capacity * (var.write_throttle_threshold_percent / 100)
  alarm_description   = "This alarm triggers when write capacity exceeds threshold"

  dimensions = {
    TableName = var.dynamodb_table_name
  }

  tags = merge(var.common_tags, { Name = "${var.dynamodb_table_name}-write-capacity" })
}

# =============================================================================
# NOTIFICACIONES DE ALERTAS
# =============================================================================
# Configuración de SNS para envío de notificaciones de alertas

resource "aws_sns_topic" "dynamodb_alerts" {
  count = var.enable_alerts && var.alert_notification_email != "" ? 1 : 0

  name = "${var.dynamodb_table_name}-alerts"

  tags = merge(var.common_tags, {
    Environment = var.app_environment
  })
}

resource "aws_sns_topic_subscription" "dynamodb_alerts_email" {
  count = var.enable_alerts && var.alert_notification_email != "" ? 1 : 0

  topic_arn = aws_sns_topic.dynamodb_alerts[0].arn
  protocol  = "email"
  endpoint  = var.alert_notification_email
}

# Suscripción de alarmas a SNS
resource "aws_cloudwatch_metric_alarm" "read_throttle_sns" {
  count = var.enable_alerts && var.alert_notification_email != "" ? 1 : 0

  alarm_name          = "${var.dynamodb_table_name}-read-throttle-sns"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ReadThrottleEvents"
  namespace           = "AWS/DynamoDB"
  period              = var.metrics_interval_seconds
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "This alarm triggers when read throttle events occur"
  alarm_actions       = [aws_sns_topic.dynamodb_alerts[0].arn]

  dimensions = {
    TableName = var.dynamodb_table_name
  }

  tags = merge(var.common_tags, { Name = "${var.dynamodb_table_name}-read-throttle-sns" })
}

resource "aws_cloudwatch_metric_alarm" "write_throttle_sns" {
  count = var.enable_alerts && var.alert_notification_email != "" ? 1 : 0

  alarm_name          = "${var.dynamodb_table_name}-write-throttle-sns"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "WriteThrottleEvents"
  namespace           = "AWS/DynamoDB"
  period              = var.metrics_interval_seconds
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "This alarm triggers when write throttle events occur"
  alarm_actions       = [aws_sns_topic.dynamodb_alerts[0].arn]

  dimensions = {
    TableName = var.dynamodb_table_name
  }

  tags = merge(var.common_tags, { Name = "${var.dynamodb_table_name}-write-throttle-sns" })
}