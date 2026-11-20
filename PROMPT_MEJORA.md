# Prompt para Mejorar el Codigo Base

Copia y pega el contenido del bloque de abajo en un asistente de IA (Claude, ChatGPT)
para obtener el proyecto completo y arrancable. Guarda los archivos que te devuelva en la
carpeta del repo, respetando exactamente las rutas.

Si preferis trabajar en tu editor con un agente local (Claude Code, Cursor, Copilot), usa `AGENTS.md` en vez de este archivo: dice lo mismo pero para que escriba los archivos en disco.

## Las dos reglas que no se negocian

1. **Completa el boilerplate.** Todo lo que el proyecto necesita para compilar y arrancar: manifiesto de dependencias, punto de entrada, configuracion, capa de interfaz, y las capas del patron arquitectonico declarado. Eso es andamiaje y es tu trabajo.
2. **NO resuelvas el reto.** Los entregables de las fases son el trabajo de la persona. El hueco pedagogico se deja como esta: el proyecto arranca, pero lo que el reto pide implementar NO esta implementado.

Dicho de otra forma: si algo impide compilar, arreglalo. Si algo es logica de negocio incompleta, validaciones ausentes, un secreto hardcodeado o un patron mejorable, dejalo exactamente como esta — es lo que la persona tiene que encontrar.

## Superficie de practica — NO resuelvas

Estos archivos SON el ejercicio de la persona. No los implementes; deja stubs.

- `app/src/application/services/OrderService.ts` — La pieza p1 (Configuración inicial del servicio, fase f1) vive aqui: este archivo es su unico dueno (blueprint v2).
- `app/src/application/controllers/OrderController.ts` — La pieza p3 (Implementación de los controladores REST, fase f2) vive aqui: este archivo es su unico dueno (blueprint v2).
- `app/src/application/services/OrderService.refactored.ts` — La pieza p6 (Refactorización y optimización del código, fase f4) vive aqui: este archivo es su unico dueno (blueprint v2).
- `app/src/infrastructure/dynamodb/DynamoDBOrderRepository.ts` — absorbida: fuga de la pieza p2

## Mapa de componentes

El repo tiene una carpeta por componente. Cada uno se instala y verifica dentro de la suya.

| Componente | Carpeta | Rol | Capa | Track | Tecnologias |
|---|---|---|---|---|---|
| `app` | `app/` | practice, chapter | server | Node | Express, DynamoDB |
| `infra` | `infra/` | support | infra | Terraform (AWS) | Terraform |
| `infra-local` | (raiz) | support | infra | Compose local | DynamoDB |

## Orden de arranque

1. `docker compose up -d` (en la raiz) — levanta la infraestructura local.
2. `cd infra && terraform init -backend=false && terraform -chdir=modules/dynamodb init -backend=false && terraform validate && terraform -chdir=modules/dynamodb validate` — componente `infra` (support).
3. `cd app && npm install --no-audit --no-fund && npm run build` — componente `app` (practice, chapter).

### Contratos entre componentes

- `app` expone http (api: http://localhost:3000):
  - `POST /orders`
  - `GET /orders/:id`
  - `PUT /orders/:id`
  - `DELETE /orders/:id`

## Lo que le falta a este proyecto

Esto NO lo tenes que adivinar: salio de comparar el proyecto contra la arquitectura declarada del reto y de un analisis estatico del codigo. Completalo TODO.

### Archivos que la arquitectura del reto declara y no estan

Creálos con implementacion real, en la capa que les corresponde:

- `app/src/acceptance/f1.test.ts`
- `app/src/acceptance/f2.test.ts`
- `app/src/acceptance/f4.test.ts`

## Como saber que terminaste

```bash
(cd app && npm install --no-audit --no-fund && npm run build) && (cd infra && terraform init -backend=false && terraform -chdir=modules/dynamodb init -backend=false && terraform validate && terraform -chdir=modules/dynamodb validate) && docker compose config -q
```

Ese comando corriendo sin errores es la definicion de "listo".

---

```
## Briefing del reto (autoridad)
Este bloque manda sobre los archivos adjuntos. El stack y el rol salen de AQUÍ, no de un topic genérico ni de markdown placeholder.

### Perfil
Chapter Backend, Especialidad Desarrollador, Tecnología Node, Advanced L2

### Brecha de conocimiento
CRUD de ordenes en DynamoDB expuesto por una API REST

### Misión / candidato
Persistir y consultar ordenes

### Reto
- Tema: CRUD de ordenes sobre DynamoDB
- Seniority: advanced-l2
- Tipo: practical
- Título: Implementación de CRUD de ordenes en DynamoDB
- Tiempo estimado: 10 horas

### Fases (trabajo del HUMANO — PROHIBIDO completarlas)
No implementes estos entregables. Dejalos como hueco pedagógico. El asistente solo materializa el proyecto arrancable para que el participante pueda trabajar.
- Fase 1: Configuración inicial y creación de la tabla DynamoDB — objetivo: Configurar el entorno de desarrollo y crear la tabla DynamoDB para almacenar las ordenes. — entregable (NO resolver): Proyecto configurado con Express y tabla DynamoDB creada.
- Fase 2: Implementación de la API REST para operaciones CRUD — objetivo: Implementar la API REST para realizar operaciones CRUD sobre la tabla DynamoDB. — entregable (NO resolver): API REST implementada con endpoints para operaciones CRUD sobre la tabla DynamoDB.
- Fase 3: Pruebas de aceptación para las operaciones CRUD — objetivo: Implementar pruebas de aceptación para verificar el funcionamiento correcto de las operaciones CRUD. — entregable (NO resolver): Pruebas de aceptación implementadas para verificar el funcionamiento correcto de las operaciones CRUD.
- Fase 4: Optimización y refactorización del código — objetivo: Optimizar y refactorizar el código para mejorar la eficiencia y mantenibilidad. — entregable (NO resolver): Código optimizado y refactorizado para mejorar la eficiencia y mantenibilidad.

Eres un asistente experto en análisis, corrección y generación de archivos de cualquier tipo:
código fuente, documentación, hojas de cálculo, documentos Word, configuraciones, entre otros.
Voy a enviarte una cadena de texto que contiene uno o más archivos. Cada archivo está delimitado por un marcador con el siguiente formato:
// === ARCHIVO: ruta/del/archivo.extension ===
o también puede aparecer como:
## === ARCHIVO: ruta/del/archivo.extension ===
Lo que sigue al marcador puede ser:

El contenido real del archivo (código, texto, YAML, etc.)
Una descripción en lenguaje natural de lo que debe contener el archivo


TU TAREA
PASO 0 — ¿Esto es un proyecto o una carcasa?
Antes de extraer archivos, leé el Briefing (si está) y diagnosticá el adjunto.

Es CARCASA si ocurre CUALQUIERA de estas:
- No hay manifiesto de dependencias del stack del briefing (manifest.json de VTEX IO / package.json / pom.xml / build.gradle / requirements.txt / go.mod / *.tf / *.csproj, según corresponda)
- Hay un "binario" que en realidad es un comentario ("no puede ser mostrado como texto plano", placeholder .fig/.docx vacío)
- Los markdowns ya completan entregables de fases posteriores ("se implementó fade-in", lista de áreas ya resuelta)

Si es CARCASA:
- MATERIALIZÁ un proyecto que arranca en el stack del briefing (VTEX IO Store Framework, Angular, Terraform, pytest, Nest, etc.). Incluí manifiesto, punto de entrada y capa de interfaz reales.
- NO copies los markdowns de "solución" como si fueran el producto. Son ruido de generación.
- NO resuelvas las fases del briefing (están marcadas PROHIBIDO). Dejá el hueco pedagógico: el flujo existe, las microinteracciones/calidad/infra que el reto pide NO están hechas.
- Después seguí al PASO 5 (entrega de archivos).

Si es un proyecto REAL (manifiesto + código que compila o arranca):
- Seguí PASO 1 en adelante. 🔴 compilación sí. 🟡 pedagógico no.

PASO 1 — Detección y extracción
Identifica todos los archivos presentes en la cadena. Para cada archivo extrae:

Su ruta completa (ej: src/main/java/com/pragma/Service.java)
Su contenido o descripción

PASO 2 — Clasificación por tipo
Clasifica cada archivo en una de estas categorías:
A) Código fuente (Java, Python, TypeScript, JavaScript, Kotlin, etc.)
B) Configuración / documentación (YAML, properties, Markdown, JSON, txt, etc.)
C) Excel (.xlsx, .xls, .csv)
D) Word (.docx, .doc)
E) Otro tipo de archivo binario o especial
PASO 3 — Clasificación de errores en código fuente

Objetivo prioritario: que el proyecto compile. No corrijas flujo de negocio ni lógica funcional.

Antes de modificar cualquier archivo de código fuente, clasifica cada problema encontrado en una de estas dos categorías:
🔴 ERROR DE COMPILACIÓN — corregir siempre
Son errores que impiden que el proyecto arranque, sin valor pedagógico:

Import faltante o incorrecto
Clase, método o variable referenciada que no existe en ningún archivo del proyecto
Error de sintaxis
Anotación con atributos inválidos
Dependencia ausente en pom.xml, package.json, etc.
Archivo referenciado que no existe y debe ser creado con implementación mínima

→ CORREGIR estos errores.
🟡 PROBLEMA FUNCIONAL O DE CALIDAD — preservar siempre
Son problemas que no impiden compilar. Pueden ser intencionales para el aprendizaje:

Clave secreta hardcodeada ("secret", "password123")
API deprecada que funciona pero tiene reemplazo moderno
Lógica de negocio incorrecta o incompleta
Código redundante o de baja legibilidad
Falta de validaciones en flujo de negocio
Patrones de diseño incorrectos pero funcionales
Concurrencia no segura
Configuración funcional pero no óptima

→ PRESERVAR tal cual. No corregir, no mejorar, no comentar.
PASO 4 — Procesamiento según tipo de archivo
Tipo A — Código fuente
Aplica únicamente las correcciones clasificadas como 🔴 ERROR DE COMPILACIÓN.
No alteres ningún elemento clasificado como 🟡 PROBLEMA FUNCIONAL O DE CALIDAD.
Si falta un archivo referenciado, créalo con la implementación mínima necesaria para compilar.
Tipo B — Configuración / documentación
Extrae el contenido tal cual, sin modificaciones salvo errores evidentes de sintaxis
(ej: YAML mal indentado).
Tipo C — Excel (.xlsx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un archivo Excel funcional con:

Fila de encabezados en negrita con color de fondo distintivo
Columnas con ancho ajustado al contenido
Tipos de dato correctos por columna
Validaciones si la descripción lo indica
Hojas nombradas descriptivamente si hay más de una
Filas de ejemplo si no hay datos reales

Tipo D — Word (.docx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un documento Word funcional con:

Estilos de título (Título 1, Título 2) para jerarquía de secciones
Fuente legible (Calibri o equivalente), tamaño 11-12pt para cuerpo
Márgenes estándar
Tabla de contenido si tiene múltiples secciones
Tablas con encabezados en negrita si aplica

Tipo E — Otro
Genera el archivo con el contenido o estructura más apropiada según la descripción.
PASO 5 — Entrega de archivos
Entregá cada archivo con su ruta completa, respetando exactamente la estructura de rutas
indicada por los marcadores: un bloque por archivo, precedido por su ruta. No generes ZIPs
ni archivos adjuntos.
La entrega debe incluir:

Archivos de código con únicamente los errores de compilación corregidos
Archivos de configuración y documentación sin cambios
Archivos nuevos creados para resolver dependencias de compilación faltantes
Archivos Excel y Word generados desde descripción

IMPORTANTE: Entregá los archivos completos al finalizar. No preguntes si el usuario
quiere recibirlos. Simplemente entregalos; No debes desplegar en el chat el resumen de lo que arreglaste, solo entregá los archivos.

REGLAS IMPORTANTES

No omitas ningún archivo aunque no tenga errores ni modificaciones
Respeta los nombres y rutas exactas indicadas por los marcadores
Si un archivo no tiene marcador claro, infiere el nombre desde su contenido
Si la cadena contiene solo documentación, placeholders o binarios fake, NO la reproduzcas:
aplicá PASO 0 (materializar el proyecto del briefing). Reproducir la carcasa es un fallo.
No agregues texto después del último archivo entregado
No preguntes si el usuario quiere los archivos: simplemente entregalos siempre
Si detectas que falta un archivo de configuración necesario para compilar
(pom.xml, package.json, requirements.txt, build.gradle, etc.), créalo e inclúyelo
inferiendo su contenido desde los imports y frameworks detectados en el código
Nunca corrijas problemas 🟡 aunque parezcan obvios o fáciles de mejorar.
El participante que recibirá este proyecto los debe encontrar y resolver él mismo.


INPUT
Aquí está la cadena con los archivos:

// === ARCHIVO: app/package.json ===
{
  "name": "reto-express",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "build": "tsc -p tsconfig.json",
    "test": "jest"
  },
  "dependencies": {
    "@aws-sdk/client-dynamodb": "3.1173.0",
    "@aws-sdk/util-dynamodb": "3.996.9",
    "@types/supertest": "7.2.1",
    "class-transformer": "0.5.1",
    "class-validator": "0.15.1",
    "express": "4.22.3",
    "ts-node": "10.9.2",
    "uuid": "14.0.3"
  },
  "devDependencies": {
    "@types/express": "4.17.25",
    "@types/node": "22.20.5",
    "typescript": "5.7.3",
    "jest": "29.7.0",
    "ts-jest": "29.2.5",
    "@types/jest": "29.5.14"
  },
  "jest": {
    "preset": "ts-jest",
    "testEnvironment": "node"
  }
}

// === ARCHIVO: app/tsconfig.json ===
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "moduleResolution": "node",
    "outDir": "dist",
    "strict": true,
    "strictPropertyInitialization": false,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "forceConsistentCasingInFileNames": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "types": [
      "node",
      "jest"
    ]
  },
  "include": [
    "src"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "_pendiente",
    "tests",
    "test",
    "src/**/*.test.ts",
    "src/**/*.spec.ts"
  ]
}

// === ARCHIVO: app/src/application/models/Order.ts ===
import { IsArray, IsIn, IsNumber, IsString, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export const ORDER_STATUS_VALUES = ['pending', 'paid', 'shipped'] as const;

export type OrderStatusValue = typeof ORDER_STATUS_VALUES[number];

export class OrderStatus {
    @IsIn(ORDER_STATUS_VALUES as unknown as string[])
    value: OrderStatusValue;

    constructor(value: OrderStatusValue) {
        this.value = value;
    }
}

export class OrderItem {
    @IsString()
    productId: string;

    @IsNumber()
    quantity: number;

    @IsNumber()
    price: number;

    constructor(productId: string, quantity: number, price: number) {
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
    }
}

export class Order {
    @IsString()
    id: string;

    @ValidateNested()
    @Type(() => OrderStatus)
    status: OrderStatus;

    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => OrderItem)
    items: OrderItem[];

    @IsString()
    createdAt: string;

    @IsString()
    updatedAt: string;

    constructor(
        id: string,
        status: OrderStatus,
        items: OrderItem[],
        createdAt: string,
        updatedAt: string
    ) {
        this.id = id;
        this.status = status;
        this.items = items;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
}

export class CreateOrderRequest {
    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => OrderItem)
    items: OrderItem[];

    constructor(items: OrderItem[]) {
        this.items = items;
    }
}

export class UpdateOrderRequest {
    @ValidateNested()
    @Type(() => OrderStatus)
    status?: OrderStatus;

    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => OrderItem)
    items?: OrderItem[];

    constructor(status?: OrderStatus, items?: OrderItem[]) {
        this.status = status;
        this.items = items;
    }
}

// === ARCHIVO: app/src/application/repositories/OrderRepository.ts ===
import { Order, CreateOrderRequest, UpdateOrderRequest } from '../models/Order';

export interface OrderRepository {
    createOrder(request: CreateOrderRequest): Promise<Order>;
    getOrder(id: string): Promise<Order | null>;
    updateOrder(id: string, request: UpdateOrderRequest): Promise<Order>;
    deleteOrder(id: string): Promise<void>;
}

// === ARCHIVO: app/src/infrastructure/dynamodb/DynamoDBOrderRepository.ts ===
// TODO(reto): archivo stubbeado; implementa los cuerpos.
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { OrderRepository } from '../../application/repositories/OrderRepository';
import { Order, CreateOrderRequest, UpdateOrderRequest } from '../../application/models/Order';
import { OrderService } from '../../application/services/OrderService';

// Adaptador de salida: implementa el puerto OrderRepository delegando toda la
// logica de negocio y de acceso a DynamoDB en OrderService (pieza del reto).
// Aqui solo se traducen las llamadas del puerto al servicio.
export class DynamoDBOrderRepository implements OrderRepository {
    private readonly orderService: OrderService;

    constructor(client?: DynamoDBClient, tableName?: string) {
        const dynamoClient = client ?? new DynamoDBClient({ region: process.env.AWS_REGION || 'us-east-1' });
        const table = tableName ?? (process.env.DYNAMODB_TABLE_NAME || 'Orders');
        this.orderService = new OrderService(dynamoClient, table);
    }

    async createOrder(request: CreateOrderRequest): Promise<Order> {
      throw new Error('TODO(reto): createOrder');
    }

    async getOrder(id: string): Promise<Order | null> {
      throw new Error('TODO(reto): getOrder');
    }

    async updateOrder(id: string, request: UpdateOrderRequest): Promise<Order> {
      throw new Error('TODO(reto): updateOrder');
    }

    async deleteOrder(id: string): Promise<void> {
      throw new Error('TODO(reto): deleteOrder');
    }
}

// === ARCHIVO: app/src/application/services/OrderService.ts ===
// TODO(reto): archivo stubbeado; implementa los cuerpos.
import { DynamoDBClient, PutItemCommand, GetItemCommand, UpdateItemCommand, DeleteItemCommand } from '@aws-sdk/client-dynamodb';
import { marshall, unmarshall } from '@aws-sdk/util-dynamodb';
import { randomUUID } from 'crypto';
import { Order, OrderStatus, OrderItem, CreateOrderRequest, UpdateOrderRequest, OrderStatusValue } from '../models/Order';

export class OrderService {
    private readonly client: DynamoDBClient;
    private readonly tableName: string;

    constructor(dynamoDBClient: DynamoDBClient, tableName: string = process.env.ORDER_TABLE_NAME || 'orders') {
        this.client = dynamoDBClient;
        this.tableName = tableName;
    }

    private validateStatus(status: OrderStatusValue | undefined): boolean {
      throw new Error('TODO(reto): validateStatus');
    }

    async createOrder(request: CreateOrderRequest): Promise<Order> {
      throw new Error('TODO(reto): createOrder');
    }

    async getOrder(id: string): Promise<Order | null> {
      throw new Error('TODO(reto): getOrder');
    }

    async updateOrder(id: string, request: UpdateOrderRequest): Promise<Order> {
      throw new Error('TODO(reto): updateOrder');
    }

    async deleteOrder(id: string): Promise<void> {
      throw new Error('TODO(reto): deleteOrder');
    }
}

// === ARCHIVO: app/src/application/controllers/OrderController.ts ===
// TODO(reto): archivo stubbeado; implementa los cuerpos.
import { Request, Response } from 'express';
import { OrderService } from '../services/OrderService';
import { CreateOrderRequest, UpdateOrderRequest, OrderItem, OrderStatus } from '../models/Order';

export class OrderController {
    private readonly orderService: OrderService;

    constructor(orderService: OrderService) {
        this.orderService = orderService;
    }

    async createOrder(req: Request, res: Response): Promise<void> {
      throw new Error('TODO(reto): createOrder');
    }

    async getOrder(req: Request, res: Response): Promise<void> {
      throw new Error('TODO(reto): getOrder');
    }

    async updateOrder(req: Request, res: Response): Promise<void> {
      throw new Error('TODO(reto): updateOrder');
    }

    async deleteOrder(req: Request, res: Response): Promise<void> {
      throw new Error('TODO(reto): deleteOrder');
    }
}

// === ARCHIVO: app/src/application/services/OrderService.refactored.ts ===
// TODO(reto): archivo stubbeado; implementa los cuerpos.
import { DynamoDBClient, GetItemCommand, PutItemCommand, UpdateItemCommand, DeleteItemCommand } from '@aws-sdk/client-dynamodb';
import { Order, OrderStatus, OrderItem, CreateOrderRequest, UpdateOrderRequest, OrderStatusValue } from '../models/Order';
import { randomUUID } from 'crypto';

export class OrderServiceRefactored {
    private readonly client: DynamoDBClient;
    private readonly tableName: string;

    constructor(dynamoDBClient: DynamoDBClient, tableName: string = process.env.ORDER_TABLE_NAME || 'orders') {
        this.client = dynamoDBClient;
        this.tableName = tableName;
    }

    private validateStatus(status: OrderStatusValue | undefined): boolean {
        if (status === undefined) {
            return true;
        }
        const validStatuses: OrderStatusValue[] = ['pending', 'paid', 'shipped'];
        return validStatuses.includes(status);
    }

    private mapToOrder(item: Record<string, any>): Order {
        return new Order(
            item.id.S || '',
            new OrderStatus(item.status.S as OrderStatusValue),
            (item.items.L || []).map((i: any) => new OrderItem(
                i.M?.productId.S || '',
                Number(i.M?.quantity.N || 0),
                Number(i.M?.price.N || 0)
            )),
            item.createdAt.S || '',
            item.updatedAt.S || ''
        );
    }

    private mapToDynamoDBItem(order: Order): Record<string, any> {
        return {
            id: { S: order.id },
            status: { S: order.status.value },
            items: {
                L: order.items.map(item => ({
                    M: {
                        productId: { S: item.productId },
                        quantity: { N: item.quantity.toString() },
                        price: { N: item.price.toString() }
                    }
                }))
            },
            createdAt: { S: order.createdAt },
            updatedAt: { S: order.updatedAt }
        };
    }

    async createOrder(request: CreateOrderRequest): Promise<Order> {
        const now = new Date().toISOString();
        const order = new Order(
            randomUUID(),
            new OrderStatus('pending'),
            request.items,
            now,
            now
        );

        const command = new PutItemCommand({
            TableName: this.tableName,
            Item: this.mapToDynamoDBItem(order),
            ConditionExpression: 'attribute_not_exists(id)'
        });

        await this.client.send(command);
        return order;
    }

    async getOrder(id: string): Promise<Order | null> {
        const command = new GetItemCommand({
            TableName: this.tableName,
            Key: { id: { S: id } }
        });

        const result = await this.client.send(command);
        if (!result.Item) {
            return null;
        }
        return this.mapToOrder(result.Item);
    }

    async updateOrder(id: string, request: UpdateOrderRequest): Promise<Order> {
        const existingOrder = await this.getOrder(id);
        if (!existingOrder) {
            throw new Error('Order not found');
        }

        if (request.status && !this.validateStatus(request.status.value)) {
            throw new Error('Invalid status');
        }

        const now = new Date().toISOString();
        const updatedOrder = new Order(
            existingOrder.id,
            request.status || existingOrder.status,
            request.items || existingOrder.items,
            existingOrder.createdAt,
            now
        );

        const updateExpression = request.status && request.items
            ? 'SET #status = :status, items = :items, updatedAt = :updatedAt'
            : request.status
                ? 'SET #status = :status, updatedAt = :updatedAt'
                : 'SET items = :items, updatedAt = :updatedAt';

        const expressionAttributeNames: Record<string, string> = {};
        const expressionAttributeValues: Record<string, any> = {
            ':updatedAt': { S: now }
        };

        if (request.status) {
            expressionAttributeNames['#status'] = 'status';
            expressionAttributeValues[':status'] = { S: request.status.value };
        }
        if (request.items) {
            expressionAttributeValues[':items'] = {
                L: request.items.map(item => ({
                    M: {
                        productId: { S: item.productId },
                        quantity: { N: item.quantity.toString() },
                        price: { N: item.price.toString() }
                    }
                }))
            };
        }

        const command = new UpdateItemCommand({
            TableName: this.tableName,
            Key: { id: { S: id } },
            UpdateExpression: updateExpression,
            ExpressionAttributeNames: expressionAttributeNames,
            ExpressionAttributeValues: expressionAttributeValues,
            ReturnValues: 'ALL_NEW'
        });

        const result = await this.client.send(command);
        return this.mapToOrder(result.Attributes || {});
    }

    async deleteOrder(id: string): Promise<void> {
        const command = new DeleteItemCommand({
            TableName: this.tableName,
            Key: { id: { S: id } }
        });

        await this.client.send(command);
    }
}

export function refactoredCode(): string {
  throw new Error('TODO(reto): refactoredCode');
}

// === ARCHIVO: app/src/main.ts ===
import { app } from './app';

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Servidor ejecutándose en el puerto ${PORT}`);
});

// === ARCHIVO: app/src/app.ts ===
import express, { Application, Request, Response, NextFunction } from 'express';
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { OrderController } from './application/controllers/OrderController';

// Punto de composicion de la aplicacion (capas estandar):
// - application: modelos, puertos y casos de uso (OrderService, OrderController)
// - infrastructure: adaptadores de salida (DynamoDB)
// Las dependencias se resuelven aqui; cada pieza del reto vive en su archivo dueno.
const app: Application = express();

app.use(express.json());

const dynamoDBClient = new DynamoDBClient({
    region: process.env.AWS_REGION || 'us-east-1',
    endpoint: process.env.DYNAMODB_ENDPOINT,
    credentials: process.env.AWS_ACCESS_KEY_ID ? {
        accessKeyId: process.env.AWS_ACCESS_KEY_ID,
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || '',
    } : undefined,
});

const tableName = process.env.ORDER_TABLE_NAME || 'orders';
const orderController = new OrderController(
    new (require('./application/services/OrderService').OrderService)(dynamoDBClient, tableName)
);

app.post('/orders', (req: Request, res: Response) => orderController.createOrder(req, res));
app.get('/orders/:id', (req: Request, res: Response) => orderController.getOrder(req, res));
app.put('/orders/:id', (req: Request, res: Response) => orderController.updateOrder(req, res));
app.delete('/orders/:id', (req: Request, res: Response) => orderController.deleteOrder(req, res));

app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
    console.error('Error no manejado:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
});

export { app };

// === ARCHIVO: infra/versions.tf ===
terraform {
  required_version = ">= 1.9.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.100.0"
    }
  }
}

// === ARCHIVO: infra/providers.tf ===
provider "aws" {
  region = "us-east-1"
}

// === ARCHIVO: infra/modules/dynamodb/main.tf ===
# Módulo para la tabla DynamoDB de órdenes.
# Define la tabla que almacena las órdenes, sus índices secundarios globales
# y la configuración opcional de Time to Live. Los parámetros configurables
# llegan desde modules/dynamodb/variables.tf.

resource "aws_dynamodb_table" "orders_table" {
  name           = var.table_name
  billing_mode   = var.billing_mode
  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  hash_key       = var.hash_key

  attribute {
    name = "orderId"
    type = "S"
  }

  attribute {
    name = "customerId"
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }

  attribute {
    name = "createdAt"
    type = "S"
  }

  # Índice secundario global para consultar órdenes por cliente
  global_secondary_index {
    name            = "CustomerOrdersIndex"
    hash_key        = "customerId"
    range_key       = "createdAt"
    projection_type = "ALL"
    read_capacity   = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
    write_capacity  = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  }

  # Índice secundario global para consultar órdenes por estado
  global_secondary_index {
    name            = "StatusIndex"
    hash_key        = "status"
    range_key       = "createdAt"
    projection_type = "ALL"
    read_capacity   = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
    write_capacity  = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  }

  # Time to Live opcional: el atributo se toma de la variable del módulo
  dynamic "ttl" {
    for_each = var.enable_ttl ? [1] : []
    content {
      attribute_name = var.ttl_attribute_name
      enabled        = true
    }
  }

  stream_enabled   = var.enable_stream
  stream_view_type = var.enable_stream ? var.stream_view_type : null

  tags = merge(
    {
      Name        = var.table_name
      Environment = terraform.workspace
    },
    var.tags
  )
}

output "table_arn" {
  description = "ARN de la tabla DynamoDB"
  value       = aws_dynamodb_table.orders_table.arn
}

output "table_name" {
  description = "Nombre de la tabla DynamoDB"
  value       = aws_dynamodb_table.orders_table.name
}

output "stream_arn" {
  description = "ARN del stream de la tabla (si está habilitado)"
  value       = aws_dynamodb_table.orders_table.stream_arn
}

output "table_id" {
  description = "ID de la tabla DynamoDB"
  value       = aws_dynamodb_table.orders_table.id
}

// === ARCHIVO: infra/environments/dev/terraform.tfvars ===
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

// === ARCHIVO: infra/README.md ===
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

// === ARCHIVO: infra/variables.tf ===
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

// === ARCHIVO: infra/main.tf ===
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

// === ARCHIVO: infra/outputs.tf ===
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

// === ARCHIVO: infra/modules/dynamodb/variables.tf ===
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

// === ARCHIVO: docker-compose.yml ===
# Infraestructura local del reto. SOLO desarrollo: credenciales de ejemplo (local-dev-only), puertos en loopback.
# Levantar: docker compose up -d --wait
name: infra-local
services:
  dynamodb-local:
    image: "amazon/dynamodb-local:2.5.2"
    command: ["-jar","DynamoDBLocal.jar","-sharedDb","-inMemory"]
    ports:
      - "127.0.0.1:8000:8000"
    healthcheck:
      test: ["CMD-SHELL","bash -c ':> /dev/tcp/127.0.0.1/8000' || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 10
      start_period: 5s


// === ARCHIVO: infra-local/README.md ===
# Infraestructura local

Servicios de soporte para el reto, definidos en `docker-compose.yml` (raiz del repo).

```bash
docker compose up -d --wait
```

| Servicio | Imagen | Puertos (host) |
|---|---|---|
| DynamoDB Local | `amazon/dynamodb-local:2.5.2` | 8000 |

Credenciales: solo de desarrollo local (`local-dev-only`, `local`). No son secretos ni deben reutilizarse.
Los scripts de `infra-local/` (tablas, topics) se ejecutan con el compose en estado healthy.


// === ARCHIVO: infra-local/dynamodb/create-tables.sh ===
#!/usr/bin/env bash
# Crea las tablas en DynamoDB Local (idempotente). Credenciales dummy: DynamoDB Local no valida firmas.
set -euo pipefail

export AWS_ACCESS_KEY_ID=local
export AWS_SECRET_ACCESS_KEY=local
export AWS_REGION=us-east-1
ENDPOINT="${DYNAMODB_ENDPOINT:-http://localhost:8000}"

create_table() {
  local name="$1" pk="$2" sk="${3:-}"
  if aws dynamodb describe-table --table-name "$name" --endpoint-url "$ENDPOINT" >/dev/null 2>&1; then
    echo "Tabla $name ya existe"
    return
  fi
  local attrs="AttributeName=$pk,AttributeType=S"
  local keys="AttributeName=$pk,KeyType=HASH"
  if [ -n "$sk" ]; then
    attrs="$attrs AttributeName=$sk,AttributeType=S"
    keys="$keys AttributeName=$sk,KeyType=RANGE"
  fi
  # shellcheck disable=SC2086
  aws dynamodb create-table --table-name "$name" --attribute-definitions $attrs --key-schema $keys \
    --billing-mode PAY_PER_REQUEST --endpoint-url "$ENDPOINT" >/dev/null
  echo "Tabla $name creada"
}

create_table "app-items" "id"

```
