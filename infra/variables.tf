# =============================================================================
# Variables globales para la infraestructura de órdenes
# =============================================================================
# Define los parámetros configurables que consumen los módulos y recursos.
# Cada variable tiene tipo, descripción y valor por defecto explícitos.

# -----------------------------------------------------------------------------
# Configuración de AWS
# -----------------------------------------------------------------------------

variable "aws_region" {
  description = "Región de AWS donde se crearán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Perfil de AWS CLI a utilizar para la autenticación"
  type        = string
  default     = "default"
}

# -----------------------------------------------------------------------------
# Configuración de la tabla DynamoDB
# -----------------------------------------------------------------------------

variable "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB para almacenar las órdenes"
  type        = string
  default     = "orders"
  validation {
    condition     = length(var.dynamodb_table_name) >= 3 && length(var.dynamodb_table_name) <= 255
    error_message = "El nombre de la tabla debe tener entre 3 y 255 caracteres."
  }
}

variable "dynamodb_billing_mode" {
  description = "Modo de facturación de la tabla: PAY_PER_REQUEST o PROVISIONED"
  type        = string
  default     = "PAY_PER_REQUEST"
  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.dynamodb_billing_mode)
    error_message = "El modo de facturación debe ser PAY_PER_REQUEST o PROVISIONED."
  }
}

variable "dynamodb_hash_key" {
  description = "Nombre del atributo de clave de partición (hash key)"
  type        = string
  default     = "orderId"
  validation {
    condition     = length(var.dynamodb_hash_key) >= 1 && length(var.dynamodb_hash_key) <= 255
    error_message = "El nombre de la clave de partición debe tener entre 1 y 255 caracteres."
  }
}

variable "dynamodb_read_capacity" {
  description = "Capacidad de lectura en unidades por segundo (solo para PROVISIONED)"
  type        = number
  default     = 5
  validation {
    condition     = var.dynamodb_read_capacity >= 1 && var.dynamodb_read_capacity <= 40000
    error_message = "La capacidad de lectura debe estar entre 1 y 40000."
  }
}

variable "dynamodb_write_capacity" {
  description = "Capacidad de escritura en unidades por segundo (solo para PROVISIONED)"
  type        = number
  default     = 5
  validation {
    condition     = var.dynamodb_write_capacity >= 1 && var.dynamodb_write_capacity <= 40000
    error_message = "La capacidad de escritura debe estar entre 1 y 40000."
  }
}

variable "dynamodb_enable_stream" {
  description = "Habilitar streams de DynamoDB para captura de cambios"
  type        = bool
  default     = false
}

variable "dynamodb_stream_view_type" {
  description = "Tipo de información capturada por el stream"
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
  validation {
    condition     = contains(["KEYS_ONLY", "NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES"], var.dynamodb_stream_view_type)
    error_message = "El tipo de vista del stream debe ser KEYS_ONLY, NEW_IMAGE, OLD_IMAGE o NEW_AND_OLD_IMAGES."
  }
}

# -----------------------------------------------------------------------------
# Configuración de seguridad
# -----------------------------------------------------------------------------

variable "enable_kms_encryption" {
  description = "Habilitar cifrado en reposo usando AWS KMS"
  type        = bool
  default     = true
}

variable "kms_key_alias" {
  description = "Alias de la clave KMS para cifrado (debe existir o se creará)"
  type        = string
  default     = "alias/dynamodb-default-key"
}

variable "kms_key_description" {
  description = "Descripción de la clave KMS administrada por el cliente"
  type        = string
  default     = "Clave KMS para cifrado de tabla DynamoDB"
}

variable "kms_key_deletion_window" {
  description = "Días de espera antes de eliminar la clave KMS"
  type        = number
  default     = 7
  validation {
    condition     = var.kms_key_deletion_window >= 7 && var.kms_key_deletion_window <= 30
    error_message = "El período de eliminación debe estar entre 7 y 30 días."
  }
}

# -----------------------------------------------------------------------------
# Configuración de Point-in-Time Recovery
# -----------------------------------------------------------------------------

variable "enable_pitr" {
  description = "Habilitar Point-in-Time Recovery para la tabla"
  type        = bool
  default     = true
}

variable "pitr_recovery_period_days" {
  description = "Período máximo de recuperación en días (máximo 35)"
  type        = number
  default     = 7
  validation {
    condition     = var.pitr_recovery_period_days >= 1 && var.pitr_recovery_period_days <= 35
    error_message = "El período de recuperación debe estar entre 1 y 35 días."
  }
}

# -----------------------------------------------------------------------------
# Configuración de TTL
# -----------------------------------------------------------------------------

variable "enable_ttl" {
  description = "Habilitar Time-To-Live para auto-eliminación de elementos"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "Nombre del atributo que contiene la marca de tiempo de expiración"
  type        = string
  default     = "expiresAt"
  validation {
    condition     = length(var.ttl_attribute_name) >= 1 && length(var.ttl_attribute_name) <= 255
    error_message = "El nombre del atributo TTL debe tener entre 1 y 255 caracteres."
  }
}

# -----------------------------------------------------------------------------
# Configuración de etiquetas (tags)
# -----------------------------------------------------------------------------

variable "common_tags" {
  description = "Etiquetas comunes aplicadas a todos los recursos"
  type        = map(string)
  default     = {}
  validation {
    condition     = length(var.common_tags) <= 50
    error_message = "No se pueden definir más de 50 etiquetas."
  }
}

variable "dynamodb_tags" {
  description = "Etiquetas específicas para la tabla DynamoDB"
  type        = map(string)
  default     = {}
}

# -----------------------------------------------------------------------------
# Configuración de acceso y red
# -----------------------------------------------------------------------------

variable "access_mode" {
  description = "Modo de acceso a la tabla: public, private o restricted"
  type        = string
  default     = "public"
  validation {
    condition     = contains(["public", "private", "restricted"], var.access_mode)
    error_message = "El modo de acceso debe ser public, private o restricted."
  }
}

variable "allowed_cidr_blocks" {
  description = "Bloques CIDR permitidos para acceso (solo para modo restricted)"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "ID de VPC para acceso privado (solo para modo private)"
  type        = string
  default     = ""
}

# -----------------------------------------------------------------------------
# Configuración de logging y monitoreo
# -----------------------------------------------------------------------------

variable "enable_cloudwatch_logs" {
  description = "Habilitar CloudWatch Logs para la tabla"
  type        = bool
  default     = false
}

variable "cloudwatch_log_level" {
  description = "Nivel de logging: NONE, ERROR, WARNING, INFO"
  type        = string
  default     = "INFO"
  validation {
    condition     = contains(["NONE", "ERROR", "WARNING", "INFO"], var.cloudwatch_log_level)
    error_message = "El nivel de logging debe ser NONE, ERROR, WARNING o INFO."
  }
}

variable "enable_alerts" {
  description = "Habilitar alarmas de CloudWatch y notificaciones SNS para la tabla"
  type        = bool
  default     = false
}

variable "metrics_interval_seconds" {
  description = "Intervalo en segundos de las métricas de CloudWatch usadas por las alarmas"
  type        = number
  default     = 60
  validation {
    condition     = contains([60, 300], var.metrics_interval_seconds)
    error_message = "El intervalo de métricas debe ser 60 o 300 segundos."
  }
}

variable "read_throttle_threshold_percent" {
  description = "Porcentaje de capacidad de lectura consumida que dispara la alarma de throttling de lectura"
  type        = number
  default     = 80
  validation {
    condition     = var.read_throttle_threshold_percent >= 1 && var.read_throttle_threshold_percent <= 100
    error_message = "El umbral de lectura debe estar entre 1 y 100 por ciento."
  }
}

variable "write_throttle_threshold_percent" {
  description = "Porcentaje de capacidad de escritura consumida que dispara la alarma de throttling de escritura"
  type        = number
  default     = 80
  validation {
    condition     = var.write_throttle_threshold_percent >= 1 && var.write_throttle_threshold_percent <= 100
    error_message = "El umbral de escritura debe estar entre 1 y 100 por ciento."
  }
}

variable "alert_notification_email" {
  description = "Correo electrónico que recibe las notificaciones SNS de las alarmas (vacío para no suscribir)"
  type        = string
  default     = ""
}

# -----------------------------------------------------------------------------
# Configuración de backup
# -----------------------------------------------------------------------------

variable "enable_auto_backup" {
  description = "Habilitar backups automáticos con AWS Backup"
  type        = bool
  default     = false
}

variable "backup_frequency" {
  description = "Frecuencia de backup: DAILY, WEEKLY, MONTHLY"
  type        = string
  default     = "DAILY"
  validation {
    condition     = contains(["DAILY", "WEEKLY", "MONTHLY"], var.backup_frequency)
    error_message = "La frecuencia de backup debe ser DAILY, WEEKLY o MONTHLY."
  }
}

variable "backup_retention_days" {
  description = "Retención de backups en días"
  type        = number
  default     = 30
  validation {
    condition     = var.backup_retention_days >= 1 && var.backup_retention_days <= 365
    error_message = "La retención debe estar entre 1 y 365 días."
  }
}

# -----------------------------------------------------------------------------
# Configuración de aplicación
# -----------------------------------------------------------------------------

variable "app_environment" {
  description = "Entorno de la aplicación (development, staging, production)"
  type        = string
  default     = "development"
  validation {
    condition     = contains(["development", "staging", "production"], var.app_environment)
    error_message = "El entorno debe ser development, staging o production."
  }
}

variable "app_log_level" {
  description = "Nivel de logging de la aplicación"
  type        = string
  default     = "info"
  validation {
    condition     = contains(["debug", "info", "warn", "error"], var.app_log_level)
    error_message = "El nivel de logging debe ser debug, info, warn o error."
  }
}

variable "app_debug_mode" {
  description = "Habilitar modo debug en la aplicación"
  type        = string
  default     = "false"
  validation {
    condition     = contains(["true", "false"], var.app_debug_mode)
    error_message = "El modo debug debe ser true o false."
  }
}

variable "app_cors_origins" {
  description = "Orígenes permitidos para CORS (separados por coma)"
  type        = string
  default     = "*"
}

variable "app_rate_limit_requests" {
  description = "Número máximo de requests por ventana de tasa"
  type        = number
  default     = 100
  validation {
    condition     = var.app_rate_limit_requests >= 1
    error_message = "El límite de requests debe ser mayor a 0."
  }
}

variable "app_rate_limit_window" {
  description = "Ventana de tiempo para rate limiting en segundos"
  type        = number
  default     = 60
  validation {
    condition     = var.app_rate_limit_window >= 1
    error_message = "La ventana debe ser mayor a 0 segundos."
  }
}

variable "app_timeout_seconds" {
  description = "Timeout de la aplicación en segundos"
  type        = number
  default     = 30
  validation {
    condition     = var.app_timeout_seconds >= 1 && var.app_timeout_seconds <= 300
    error_message = "El timeout debe estar entre 1 y 300 segundos."
  }
}

variable "app_max_connections" {
  description = "Número máximo de conexiones simultáneas"
  type        = number
  default     = 100
  validation {
    condition     = var.app_max_connections >= 1
    error_message = "El máximo de conexiones debe ser mayor a 0."
  }
}

# -----------------------------------------------------------------------------
# Configuración de DynamoDB Local (para pruebas)
# -----------------------------------------------------------------------------

variable "use_local_dynamodb" {
  description = "Usar DynamoDB Local en lugar del servicio real"
  type        = bool
  default     = false
}

variable "local_dynamodb_port" {
  description = "Puerto para DynamoDB Local"
  type        = number
  default     = 8000
  validation {
    condition     = var.local_dynamodb_port >= 1 && var.local_dynamodb_port <= 65535
    error_message = "El puerto debe estar entre 1 y 65535."
  }
}

variable "local_dynamodb_endpoint" {
  description = "Endpoint de DynamoDB Local"
  type        = string
  default     = "http://localhost:8000"
}

variable "local_dynamodb_region" {
  description = "Región para DynamoDB Local"
  type        = string
  default     = "us-east-1"
}