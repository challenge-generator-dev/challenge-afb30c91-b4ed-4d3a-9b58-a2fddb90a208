# =============================================================================
# VARIABLES DEL MÓDULO DynamoDB
# =============================================================================
# Parámetros configurables del módulo. Los valores por defecto permiten
# ejecutar el módulo sin configuración adicional en entornos de desarrollo.

variable "enable_ttl" {
  type        = bool
  description = "Habilita el Time To Live (TTL) sobre la tabla DynamoDB para expirar ítems automáticamente"
  default     = false
}

variable "ttl_attribute_name" {
  type        = string
  description = "Nombre del atributo que contiene la marca de expiración (epoch en segundos) usada por TTL"
  default     = "expiresAt"
}

variable "table_name" {
  type        = string
  description = "Nombre de la tabla DynamoDB que se crea en este módulo"
  default     = "orders"
}

variable "billing_mode" {
  type        = string
  description = "Modo de facturación de la tabla: PAY_PER_REQUEST o PROVISIONED"
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "billing_mode debe ser PAY_PER_REQUEST o PROVISIONED."
  }
}

variable "hash_key" {
  type        = string
  description = "Nombre del atributo de clave de partición de la tabla"
  default     = "orderId"
}

variable "read_capacity" {
  type        = number
  description = "Unidades de capacidad de lectura aprovisionadas (solo modo PROVISIONED)"
  default     = 5
}

variable "write_capacity" {
  type        = number
  description = "Unidades de capacidad de escritura aprovisionadas (solo modo PROVISIONED)"
  default     = 5
}

variable "enable_stream" {
  type        = bool
  description = "Habilita DynamoDB Streams sobre la tabla para procesar cambios en tiempo real"
  default     = false
}

variable "stream_view_type" {
  type        = string
  description = "Tipo de imagen que se publica en el stream cuando enable_stream es true"
  default     = "NEW_AND_OLD_IMAGES"
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas adicionales aplicadas a los recursos del módulo"
  default     = {}
}