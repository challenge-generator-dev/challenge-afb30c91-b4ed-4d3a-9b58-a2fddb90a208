# =============================================================================
# Configuración de desarrollo para el entorno de DynamoDB
# =============================================================================
# Este archivo contiene los valores específicos del entorno de desarrollo
# que se utilizan para provisionar los recursos de infraestructura en AWS.

# -----------------------------------------------------------------------------
# Configuración regional
# -----------------------------------------------------------------------------
aws_region = "us-east-1"

# -----------------------------------------------------------------------------
# Configuración de la tabla DynamoDB para órdenes
# -----------------------------------------------------------------------------
# Nombre de la tabla que almacenará las órdenes del sistema
dynamodb_table_name = "orders-dev"

# Modo de facturación: PAY_PER_REQUEST (bajo demanda) o PROVISIONED (capacidad fija)
dynamodb_billing_mode = "PAY_PER_REQUEST"

# Clave de partición (hash key) para la tabla
dynamodb_hash_key = "orderId"

# Capacidad de lectura (solo aplica si billing_mode es PROVISIONED)
dynamodb_read_capacity = 5

# Capacidad de escritura (solo aplica si billing_mode es PROVISIONED)
dynamodb_write_capacity = 5

# Habilitar streams de DynamoDB para captura de cambios
dynamodb_enable_stream = true

# Tipo de vista del stream: KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES
dynamodb_stream_view_type = "NEW_AND_OLD_IMAGES"

# -----------------------------------------------------------------------------
# Etiquetas (tags) para los recursos
# -----------------------------------------------------------------------------
# Tags comunes para todos los recursos del entorno de desarrollo
common_tags = {
  Environment = "development"
  Project     = "orders-api"
  ManagedBy   = "terraform"
  CostCenter  = "engineering"
  Team        = "platform"
}

# Tags específicos para la tabla DynamoDB
dynamodb_tags = {
  Name        = "orders-table-dev"
  Description = "Tabla de órdenes para entorno de desarrollo"
  Backup      = "enabled"
  Encryption  = "enabled"
}

# -----------------------------------------------------------------------------
# Configuración de seguridad
# -----------------------------------------------------------------------------
# Habilitar cifrado en reposo usando KMS
enable_kms_encryption = true

# Alias de la clave KMS para el cifrado (debe existir en la cuenta)
kms_key_alias = "alias/orders-dynamodb-key"

# -----------------------------------------------------------------------------
# Configuración de Point-in-Time Recovery (PITR)
# -----------------------------------------------------------------------------
# Habilitar recuperación a cualquier punto en el tiempo
enable_pitr = true

# Días de retención para PITR (máximo 35)
pitr_recovery_period_days = 7

# -----------------------------------------------------------------------------
# Configuración de TTL (Time To Live)
# -----------------------------------------------------------------------------
# Habilitar TTL para auto-eliminación de órdenes antiguas
enable_ttl = true

# Nombre del atributo que contiene la fecha de expiración
ttl_attribute_name = "expiresAt"

# -----------------------------------------------------------------------------
# Configuración de acceso
# -----------------------------------------------------------------------------
# Modo de acceso: public (sin VPC) o private (con VPC endpoint)
access_mode = "public"

# Lista de direcciones IP permitidas para acceso (CIDR blocks)
# Solo aplica si access_mode es "restricted"
allowed_cidr_blocks = [
  "10.0.0.0/8",
  "172.16.0.0/12",
  "192.168.0.0/16"
]

# -----------------------------------------------------------------------------
# Configuración de logging y monitoreo
# -----------------------------------------------------------------------------
# Habilitar CloudWatch Logs para operaciones de tabla
enable_cloudwatch_logs = true

# Nivel de logging: NONE, ERROR, WARNING, INFO
cloudwatch_log_level = "INFO"

# Habilitar métricas detalladas de DynamoDB
enable_detailed_metrics = true

# Intervalo de métricas (60 o 300 segundos)
metrics_interval_seconds = 60

# -----------------------------------------------------------------------------
# Configuración de backup
# -----------------------------------------------------------------------------
# Habilitar backups automáticos con AWS Backup
enable_auto_backup = true

# Frecuencia de backup: DAILY, WEEKLY, MONTHLY
backup_frequency = "DAILY"

# Retención de backups en días
backup_retention_days = 30

# -----------------------------------------------------------------------------
# Configuración de alertas
# -----------------------------------------------------------------------------
# Habilitar alertas de CloudWatch
enable_alerts = true

# Umbral de throttle de lecturas (porcentaje)
read_throttle_threshold_percent = 80

# Umbral de throttle de escrituras (porcentaje)
write_throttle_threshold_percent = 80

# Umbral de capacidad consumida (porcentaje)
capacity_threshold_percent = 80

# Email para notificaciones de alertas
alert_notification_email = "platform-team@company.com"

# -----------------------------------------------------------------------------
# Configuración de pruebas locales
# -----------------------------------------------------------------------------
# Usar DynamoDB Local para pruebas (simula DynamoDB sin conexión a AWS)
use_local_dynamodb = false

# Puerto para DynamoDB Local (si use_local_dynamodb es true)
local_dynamodb_port = 8000

# Endpoint de DynamoDB Local
local_dynamodb_endpoint = "http://localhost:8000"

# Region para DynamoDB Local
local_dynamodb_region = "us-east-1"

# -----------------------------------------------------------------------------
# Variables de entorno para la aplicación
# -----------------------------------------------------------------------------
# Estas variables se pasan al contenedor/función lambda
app_environment = "development"
app_log_level = "debug"
app_debug_mode = "true"
app_cors_origins = "*"
app_rate_limit_requests = 100
app_rate_limit_window = 60
app_timeout_seconds = 30
app_max_connections = 100
<<<
END FILE>>>