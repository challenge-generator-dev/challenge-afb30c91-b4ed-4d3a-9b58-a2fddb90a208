# =============================================================================
# OUTPUTS - Información de la tabla DynamoDB para otros componentes
# =============================================================================
# Estos outputs exponen la información necesaria para que otros módulos
# o configuraciones puedan conectarse a la tabla DynamoDB creada.

# ARN completo de la tabla DynamoDB - necesario para permisos IAM
# y para referencia en otros recursos de AWS
output "dynamodb_table_arn" {
  description = "ARN completo de la tabla DynamoDB"
  value       = module.dynamodb.table_arn
}

# Nombre de la tabla - usado para operaciones SDK y CLI
output "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB"
  value       = module.dynamodb.table_name
}

# ARN del stream de DynamoDB Streams - necesario para procesar
# eventos de cambio en tiempo real (arquitecturas basadas en eventos).
# El valor es null si enable_stream es false.
output "dynamodb_stream_arn" {
  description = "ARN del stream de DynamoDB Streams"
  value       = module.dynamodb.stream_arn
}

# ID interno de la tabla - útil para referencias en otros recursos
output "dynamodb_table_id" {
  description = "ID de la tabla DynamoDB"
  value       = module.dynamodb.table_id
}

# =============================================================================
# OUTPUTS DE CONFIGURACIÓN
# =============================================================================

# Endpoint de DynamoDB - útil para desarrollo local con DynamoDB Local
output "dynamodb_endpoint" {
  description = "Endpoint de la tabla DynamoDB"
  value       = var.use_local_dynamodb ? var.local_dynamodb_endpoint : "dynamodb.${var.aws_region}.amazonaws.com"
}

# Región configurada para la tabla
output "dynamodb_region" {
  description = "Región de AWS donde está desplegada la tabla"
  value       = var.aws_region
}

# Modo de facturación - información útil para optimización de costos
output "dynamodb_billing_mode" {
  description = "Modo de facturación de la tabla (PAY_PER_REQUEST o PROVISIONED)"
  value       = var.dynamodb_billing_mode
}

# =============================================================================
# OUTPUTS DE SEGURIDAD
# =============================================================================

# ARN de la clave KMS usada para cifrado (si está habilitada)
output "kms_key_arn" {
  description = "ARN de la clave KMS usada para cifrado"
  value       = var.enable_kms_encryption ? aws_kms_key.dynamodb_encryption[0].arn : null
}

# Alias de la clave KMS
output "kms_key_alias" {
  description = "Alias de la clave KMS"
  value       = var.enable_kms_encryption ? aws_kms_alias.dynamodb_encryption[0].name : null
}

# =============================================================================
# OUTPUTS DE MONITOREO
# =============================================================================

# Estado de Point-in-Time Recovery
output "pitr_enabled" {
  description = "Indica si PITR está habilitado"
  value       = var.enable_pitr
}

# Período de retención de PITR en días
output "pitr_recovery_period_days" {
  description = "Período de retención de Point-in-Time Recovery"
  value       = var.pitr_recovery_period_days
}

# Estado de TTL
output "ttl_enabled" {
  description = "Indica si TTL está habilitado"
  value       = var.enable_ttl
}

# Nombre del atributo TTL
output "ttl_attribute_name" {
  description = "Nombre del atributo usado para TTL"
  value       = var.enable_ttl ? var.ttl_attribute_name : null
}

# =============================================================================
# OUTPUTS DE ALERTAS
# =============================================================================

# Tópicos SNS configurados para alertas
output "alerts_sns_topic_arn" {
  description = "ARN del tópico SNS para alertas de DynamoDB"
  value       = var.enable_alerts && var.alert_notification_email != "" ? aws_sns_topic.dynamodb_alerts[0].arn : null
}

# URLs de las alarmas de CloudWatch
output "cloudwatch_alarm_read_throttle" {
  description = "Nombre de la alarma de lectura"
  value       = var.enable_alerts ? "${var.dynamodb_table_name}-read-throttle" : null
}

output "cloudwatch_alarm_write_throttle" {
  description = "Nombre de la alarma de escritura"
  value       = var.enable_alerts ? "${var.dynamodb_table_name}-write-throttle" : null
}

# =============================================================================
# OUTPUTS DE ETIQUETAS
# =============================================================================

# Tags aplicados a la tabla - útil para identificación en consola
output "dynamodb_tags" {
  description = "Etiquetas aplicadas a la tabla DynamoDB"
  value       = merge(
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
# OUTPUTS DE CAPACIDAD (solo para modo PROVISIONED)
# =============================================================================

output "read_capacity_units" {
  description = "Unidades de capacidad de lectura aprovisionadas"
  value       = var.dynamodb_billing_mode == "PROVISIONED" ? var.dynamodb_read_capacity : null
}

output "write_capacity_units" {
  description = "Unidades de capacidad de escritura aprovisionadas"
  value       = var.dynamodb_billing_mode == "PROVISIONED" ? var.dynamodb_write_capacity : null
}

# =============================================================================
# OUTPUTS DE CONFIGURACIÓN DE DESARROLLO
# =============================================================================

# Indica si se está usando DynamoDB Local
output "using_local_dynamodb" {
  description = "Indica si se está usando DynamoDB Local para desarrollo"
  value       = var.use_local_dynamodb
}

# Endpoint de DynamoDB Local (si aplica)
output "local_dynamodb_endpoint" {
  description = "Endpoint de DynamoDB Local"
  value       = var.use_local_dynamodb ? var.local_dynamodb_endpoint : null
}

# Puerto de DynamoDB Local
output "local_dynamodb_port" {
  description = "Puerto de DynamoDB Local"
  value       = var.use_local_dynamodb ? var.local_dynamodb_port : null
}