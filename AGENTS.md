# AGENTS.md

Instrucciones para el agente de IA que abra este repositorio (Claude Code, Cursor, Codex, Copilot, Gemini). Se cargan solas: no hay que pegar nada en ningun chat.

## Que es este repositorio

Es el codigo base de un reto de aprendizaje de Pragma: **Implementación de CRUD de ordenes en DynamoDB**.

| | |
|---|---|
| Tema | CRUD de ordenes sobre DynamoDB |
| Nivel | advanced-l2 |
| Chapter | Backend |
| Especialidad | Node |
| Stack | TypeScript / Express 4 |
| Patron arquitectonico | capas estándar |
| Tiempo estimado | 10 horas |

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

## Receta del stack

Esqueleto obligatorio:

- `package.json y tsconfig.json en la raiz`
- `src/main.ts como bootstrap`
- `src/domain con entidades y puertos`
- `src/application con casos de uso`
- `src/infrastructure con repositorios y controller`
- `Express como framework (vinculante: no mezcles otro framework del mismo ecosistema)`

Trampas conocidas:

- No inventes versiones de npm. Usa rango con caret (`^5.7.2`) sobre una version que exista, o deja que el paquete la resuelva. Una version inexistente (ej. `@types/react-router-dom@6.19.0`) hace fallar `npm install` con ETARGET y el proyecto no instala.
- Los paquetes `@types/*` solo hacen falta para librerias que no traen sus propios tipos. React Router, NestJS y Prisma ya los traen: agregar `@types/` de esos rompe o sobra.
- El `tsconfig.json` es obligatorio: sin el, `tsc` no sabe que compilar.

Dependencias:

- @aws-sdk/client-dynamodb 3.1173.0
- @aws-sdk/util-dynamodb 3.996.9
- @types/supertest 7.2.1
- class-transformer 0.5.1
- class-validator 0.15.1
- express 4.22.3
- ts-node 10.9.2
- uuid 14.0.3
- @types/express 4.17.25
- @types/node 22.20.5
- typescript 5.7.3
- jest 29.7.0
- ts-jest 29.2.5
- @types/jest 29.5.14

## Tu tarea

Dejar este proyecto en estado **verificable**: que el comando de verificacion corra sin errores. Escribi los archivos en disco, en este repositorio. No generes ZIPs ni archivos adjuntos.

En orden:

1. Segui el orden de arranque del mapa de componentes (infraestructura local primero) y corre `(cd app && npm install --no-audit --no-fund && npm run build) && (cd infra && terraform init -backend=false && terraform -chdir=modules/dynamodb init -backend=false && terraform validate && terraform -chdir=modules/dynamodb validate) && docker compose config -q` desde la raiz: mira que falla.
2. Completa lo que falte de la lista de abajo: manifiesto de dependencias, punto de entrada, capa de interfaz y las capas del patron declarado.
3. Arregla SOLO los errores que impiden compilar o arrancar.
4. Volve a correr `(cd app && npm install --no-audit --no-fund && npm run build) && (cd infra && terraform init -backend=false && terraform -chdir=modules/dynamodb init -backend=false && terraform validate && terraform -chdir=modules/dynamodb validate) && docker compose config -q` hasta que pase.
5. Pará ahí.

## Regla dura: las fases son trabajo del humano

**PROHIBIDO implementar los entregables de las fases.** El valor del reto esta en que la persona los resuelva. Tu trabajo es que tenga un proyecto que arranca; el hueco pedagogico se queda como esta.

No resuelvas nada de esto:

- **Fase 1 — Configuración inicial y creación de la tabla DynamoDB**: Proyecto configurado con Express y tabla DynamoDB creada.
- **Fase 2 — Implementación de la API REST para operaciones CRUD**: API REST implementada con endpoints para operaciones CRUD sobre la tabla DynamoDB.
- **Fase 3 — Pruebas de aceptación para las operaciones CRUD**: Pruebas de aceptación implementadas para verificar el funcionamiento correcto de las operaciones CRUD.
- **Fase 4 — Optimización y refactorización del código**: Código optimizado y refactorizado para mejorar la eficiencia y mantenibilidad.

Distincion operativa:

- **Arreglar** (si): import faltante, tipo que no existe, dependencia sin declarar, error de sintaxis, archivo referenciado que no existe.
- **No tocar** (no): logica de negocio incompleta, validaciones ausentes, secretos hardcodeados, APIs deprecadas que funcionan, concurrencia insegura, patrones mejorables. Eso es lo que la persona tiene que encontrar.

## Superficie de practica (NO completes)

Estos archivos SON el ejercicio de la persona. No los implementes; deja stubs. No toques la logica que el reto pide completar.

- [ ] `app/src/application/services/OrderService.ts` — La pieza p1 (Configuración inicial del servicio, fase f1) vive aqui: este archivo es su unico dueno (blueprint v2).
- [ ] `app/src/application/controllers/OrderController.ts` — La pieza p3 (Implementación de los controladores REST, fase f2) vive aqui: este archivo es su unico dueno (blueprint v2).
- [ ] `app/src/application/services/OrderService.refactored.ts` — La pieza p6 (Refactorización y optimización del código, fase f4) vive aqui: este archivo es su unico dueno (blueprint v2).
- [ ] `app/src/infrastructure/dynamodb/DynamoDBOrderRepository.ts` — absorbida: fuga de la pieza p2

## Mapa de fases

La **Fase 0** es clonar el repositorio, instalar dependencias y correr las pruebas de aceptacion: todas fallan porque la logica de cada pieza esta pendiente.

| Fase | Pieza (skill) | Archivo:simbolo | Criterios | Prueba | Comando |
|------|---------------|-----------------|-----------|--------|---------|
| f1 — Configuración inicial y creación de la tabla DynamoDB | Configuración inicial del servicio | `app/src/application/services/OrderService.ts:OrderService` | El proyecto está configurado con Express.; La tabla DynamoDB ha sido creada.; La tabla DynamoDB tiene los atributos correctos.; La tabla DynamoDB tiene configuradas las claves primarias correctamente. | — | — |
| f1 — Configuración inicial y creación de la tabla DynamoDB | Creación de la tabla DynamoDB | — | El proyecto está configurado con Express.; La tabla DynamoDB ha sido creada.; La tabla DynamoDB tiene los atributos correctos.; La tabla DynamoDB tiene configuradas las claves primarias correctamente. | — | — |
| f2 — Implementación de la API REST para operaciones CRUD | Implementación de la lógica de negocio | `app/src/application/services/OrderService.ts:OrderService` | La API REST permite crear una nueva orden.; La API REST permite leer una orden existente.; La API REST permite actualizar una orden existente.; La API REST permite eliminar una orden existente.; La API REST devuelve un error cuando se intenta crear una orden con un status inválido.; La API REST devuelve un error cuando se intenta actualizar una orden con un status inválido. | — | — |
| f2 — Implementación de la API REST para operaciones CRUD | Implementación de los controladores REST | `app/src/application/controllers/OrderController.ts:OrderController` | La API REST permite crear una nueva orden.; La API REST permite leer una orden existente.; La API REST permite actualizar una orden existente.; La API REST permite eliminar una orden existente.; La API REST devuelve un error cuando se intenta crear una orden con un status inválido.; La API REST devuelve un error cuando se intenta actualizar una orden con un status inválido. | — | — |
| f3 — Pruebas de aceptación para las operaciones CRUD | Implementación de pruebas de aceptación | — | Las pruebas de aceptación verifican que la API REST permite crear una nueva orden.; Las pruebas de aceptación verifican que la API REST permite leer una orden existente.; Las pruebas de aceptación verifican que la API REST permite actualizar una orden existente.; Las pruebas de aceptación verifican que la API REST permite eliminar una orden existente.; Las pruebas de aceptación verifican que la API REST devuelve un error cuando se intenta crear una orden con un status inválido.; Las pruebas de aceptación verifican que la API REST devuelve un error cuando se intenta actualizar una orden con un status inválido. | — | — |
| f4 — Optimización y refactorización del código | Refactorización y optimización del código | `app/src/application/services/OrderService.refactored.ts:refactoredCode` | El código ha sido refactorizado para mejorar la legibilidad y mantenibilidad.; El código ha sido optimizado para mejorar la eficiencia. | — | — |

## Pruebas de aceptacion y ubicacion de la logica

Las pruebas de aceptacion (columna "Prueba" de la tabla) son de **solo lectura**: definen que significa "listo". No las edites, no las borres y no les agregues `skip`; lo que se resuelve es el codigo de cada pieza.

La logica de cada pieza va en su archivo; no la muevas a otro.

## Restricciones del pedido

| Restriccion | Donde se cumple | Estado |
|-------------|-----------------|--------|
| Usar AWS SDK v3 (@aws-sdk/client-dynamodb) para hablar con DynamoDB | `app/src/application/services/OrderService.ts:OrderService` | Verificada |
| No usar Dynamoose ni otro ORM para DynamoDB | chequeo estatico (code): prohibe `@dynamoose/dynamoose` | Verificada |
| Las ordenes tienen un campo status con los valores pending, paid y shipped; las pruebas de aceptacion los verifican | `app/src/acceptance/f2.test.ts` > Verificar status de la orden | Restriccion no verificada en `app/src/acceptance/f2.test.ts` > Verificar status de la orden |

## Lo que falta y tenes que completar

### 1. Archivos que la arquitectura declara (3 de 20)

La propuesta arquitectonica del reto los lista y no llegaron al repo. Crealos con implementacion real, respetando la capa en la que viven:

- [ ] `app/src/acceptance/f1.test.ts`
- [ ] `app/src/acceptance/f2.test.ts`
- [ ] `app/src/acceptance/f4.test.ts`

### Presentes (22)

- `app/package.json`
- `app/tsconfig.json`
- `app/src/application/models/Order.ts`
- `app/src/application/repositories/OrderRepository.ts`
- `app/src/infrastructure/dynamodb/DynamoDBOrderRepository.ts`
- `app/src/application/services/OrderService.ts`
- `app/src/application/controllers/OrderController.ts`
- `app/src/application/services/OrderService.refactored.ts`
- `app/src/main.ts`
- `app/src/app.ts`
- `infra/versions.tf`
- `infra/providers.tf`
- `infra/modules/dynamodb/main.tf`
- `infra/environments/dev/terraform.tfvars`
- `infra/README.md`
- `infra/variables.tf`
- `infra/main.tf`
- `infra/outputs.tf`
- `infra/modules/dynamodb/variables.tf`
- `docker-compose.yml`
- `infra-local/README.md`
- `infra-local/dynamodb/create-tables.sh`

### Capas del patron declarado

Son las capas que la propuesta arquitectonica plantea, marcadas segun existan hoy en el repo. Orientan donde poner el codigo nuevo; no son una condicion para compilar.

- `app` (presente)
- `app/src/application/controllers` (presente)
- `app/src/application/services` (presente)
- `app/src/application/models` (presente)
- `app/src/application/repositories` (presente)
- `app/src/application/utils` (ausente)
- `app/src/infrastructure/dynamodb` (presente)
- `app/tests/acceptance` (ausente)
- `app/tests/unit` (ausente)
- `infra` (presente)
- `infra/modules/dynamodb` (presente)

## Verificacion

```bash
(cd app && npm install --no-audit --no-fund && npm run build) && (cd infra && terraform init -backend=false && terraform -chdir=modules/dynamodb init -backend=false && terraform validate && terraform -chdir=modules/dynamodb validate) && docker compose config -q
```

El comando tiene que pasar SIN implementar los archivos de la superficie de practica: solo andamiaje.

Ese comando pasando es la definicion de "terminado" para vos.

## Convenciones que tenes que respetar

- Un solo ecosistema: no declares librerias de otro lenguaje ni mezcles gestores de paquetes.
- Toda libreria que uses tiene que estar declarada en el manifiesto de dependencias.
- Todo import declarado tiene que usarse; todo tipo usado tiene que existir o venir de una dependencia declarada.
- Cada componente vive en su carpeta: instala y compila dentro de ella, y no muevas archivos entre componentes.
- Respeta los contratos entre componentes (endpoints, topics) tal como estan declarados en el mapa de componentes.
- El patron es **capas estándar**: los contratos (interfaces, puertos) los define la capa interna y los implementa la externa, nunca al revés.
- Los archivos que crees llevan implementacion real, no stubs: sin `TODO`, sin cuerpos vacios, sin `// getters y setters`.

## Contexto del candidato

Sirve para calibrar el nivel del codigo, no para resolver las fases.

- Perfil: Chapter Backend, Especialidad Desarrollador, Tecnología Node, Advanced L2
- Brecha que el reto ataca: CRUD de ordenes en DynamoDB expuesto por una API REST
- Mision: Persistir y consultar ordenes

---

*Generado por Challenge Generator — Pragma. `README.md` tiene el enunciado completo del reto para la persona. `PROMPT_MEJORA.md` es la variante para pegar en un chat, si se prefiere ese flujo.*
