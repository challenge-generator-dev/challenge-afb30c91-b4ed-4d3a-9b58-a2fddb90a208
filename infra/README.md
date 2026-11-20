# Módulo de Infraestructura - DynamoDB Orders

Este módulo de Terraform provisiona y gestiona la tabla DynamoDB para el sistema de gestión de órdenes.

## Descripción General

El módulo crea una tabla DynamoDB optimizada para operaciones CRUD de órdenes, con configuración completa de seguridad, respaldo y monitoreo.

### Recursos Provisionados

- **Tabla DynamoDB**: Almacén de datos principal para las órdenes del sistema
- **Streams de DynamoDB**: Captura de cambios para procesamiento de eventos
- **Clave KMS**: Cifrado en reposo gestionado por AWS
- **Alarmas de CloudWatch**: Monitoreo de throttle y capacidad
- **Configuración de backup**: Point-in-time recovery y backups automáticos

## Uso del Módulo

### Configuración Básica

```hcl
module "dynamodb_orders" {
  source = "./modules/dynamodb"

  table_name      = "orders-prod"
  billing_mode    = "PAY_PER_REQUEST"
  hash_key        = "orderId"
  enable_stream   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  tags = {
    Environment = "production"
    Project     = "orders-api"
  }
}
```

### Configuración con Capacidad Provisionada

```hcl
module "dynamodb_orders_provisioned" {
  source = "./modules/dynamodb"

  table_name      = "orders-prod"
  billing_mode    = "PROVISIONED"
  hash_key        = "orderId"
  read_capacity   = 10
  write_capacity  = 10
  enable_stream   = true

  tags = {
    Environment = "production"
  }
}
```

## Variables de Entrada

| Variable | Tipo | Default | Descripción |
|----------|------|---------|-------------|
| `table_name` | string | `"orders"` | Nombre de la tabla DynamoDB |
| `billing_mode` | string | `"PAY_PER_REQUEST"` | Modo de facturación |
| `hash_key` | string | `"orderId"` | Clave de partición primaria |
| `read_capacity` | number | `5` | Capacidad de lectura (PROVISIONED) |
| `write_capacity` | number | `5` | Capacidad de escritura (PROVISIONED) |
| `enable_stream` | bool | `false` | Habilitar streams de DynamoDB |
| `stream_view_type` | string | `"NEW_AND_OLD_IMAGES"` | Tipo de vista del stream |
| `tags` | map(string) | `{}` | Etiquetas para los recursos |

## Variables de Salida

| Output | Tipo | Descripción |
|--------|------|-------------|
| `table_arn` | string | ARN de la tabla DynamoDB |
| `table_name` | string | Nombre de la tabla |
| `stream_arn` | string | ARN del stream (si está habilitado) |
| `table_id` | string | ID único de la tabla |

## Validación Local

### Prerrequisitos

- Terraform >= 1.9.0
- AWS CLI configurado con credenciales
- Acceso a la región de AWS objetivo

### Comandos de Validación

```bash
# Inicializar Terraform
terraform init

# Validar sintaxis y configuración
terraform validate

# Planificar cambios (ver qué se creará)
terraform plan -var-file="environments/dev/terraform.tfvars"

# Aplicar cambios (crear recursos)
terraform apply -var-file="environments/dev/terraform.tfvars"

# Destruir recursos (limpieza)
terraform destroy -var-file="environments/dev/terraform.tfvars"
```

### Verificar Tabla Creadas

```bash
# Listar tablas DynamoDB en la región
aws dynamodb list-tables --region us-east-1

# Describir tabla específica
aws dynamodb describe-table \
  --table-name orders-dev \
  --region us-east-1
```

## Estructura del Proyecto

```
infra/
├── environments/
│   └── dev/
│       └── terraform.tfvars    # Variables específicas del entorno
├── modules/
│   └── dynamodb/
│       ├── main.tf             # Definición de recursos
│       ├── variables.tf        # Variables del módulo
│       └── outputs.tf          # Salidas del módulo
├── main.tf                     # OrchestraciÃ³n de módulos
├── outputs.tf                  # Outputs principales
├── providers.tf                # Configuración de providers
├── variables.tf                # Variables globales
└── versions.tf                 # Versiones de Terraform y providers
```

## Consideraciones de Seguridad

- El cifrado en reposo está habilitado por defecto usando KMS
- Los streams capturan imágenes nuevas y antiguas para auditoría
- Point-in-time recovery permite recuperación hasta 35 días atrás
- Las alarmas notifican sobre problemas de capacidad y throttle

## Límites y Cuotas

- Tamaño máximo de item: 400 KB
- Número máximo de atributos: 100
- Capacidad máxima de lectura: 40,000 unidades (PAY_PER_REQUEST)
- Capacidad máxima de escritura: 40,000 unidades (PAY_PER_REQUEST)

## Monitoreo y Alertas

El módulo configura las siguientes métricas en CloudWatch:

- **Throttle de lectura**: Alerta cuando las lecturas throttleadas > 80%
- **Throttle de escritura**: Alerta cuando las escrituras throttleadas > 80%
- **Consumo de capacidad**: Alerta cuando el consumo > 80%
- **Latencia**: Métricas de latencia de lectura y escritura

## Limpieza

Para eliminar todos los recursos creados:

```bash
terraform destroy -var-file="environments/dev/terraform.tfvars"
```

**Advertencia**: Esta operación elimina permanentemente todos los datos de la tabla.
<<<
END FILE>>>