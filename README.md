# Implementación de CRUD de ordenes en DynamoDB

El sistema debe permitir la creación, lectura, actualización y eliminación de ordenes en una tabla DynamoDB. Las ordenes tienen un campo status con los valores pending, paid y shipped. El sistema debe exponer una API REST para realizar estas operaciones.

## Informacion General

| Campo | Valor |
|-------|-------|
| **Tema** | CRUD de ordenes sobre DynamoDB |
| **Nivel** | advanced-l2 |
| **Tipo** | practical |
| **Tiempo estimado** | 10 horas |

## Fases del Reto

### Fase 0: Configuración del Proyecto

**Objetivo:** Tener el proyecto base del reto funcionando en tu máquina: clonar el repositorio, instalar las herramientas y verificar que compila y arranca antes de empezar a practicar.

**Tiempo estimado:** 15-30 minutos

**Instrucciones:**

- Instala las herramientas para ejecutar el proyecto: Node.js 18+ y npm · Terraform 1.5+.
- Clona el repositorio del reto (el enlace viene en la entrega del reto y en la sección "Repositorio del Proyecto" del PDF) y ábrelo en tu IDE.
- Instala las dependencias y compila ejecutando `(cd app && npm install --no-audit --no-fund && npm run build) && (cd infra && terraform init -backend=false && terraform -chdir=modules/dynamodb init -backend=false && terraform validate && terraform -chdir=modules/dynamodb validate) && docker compose config -q` en la raíz del repositorio.
- Confirma que el comando termina sin errores: el proyecto arranca y sus pruebas corren.
- Ubica los archivos de práctica: son los que contienen `TODO(reto)` (búscalos en el repositorio). Lee el README.md y el AGENTS.md antes de empezar.

**Entregable:** El proyecto compila/arranca sin errores con `(cd app && npm install --no-audit --no-fund && npm run build) && (cd infra && terraform init -backend=false && terraform -chdir=modules/dynamodb init -backend=false && terraform validate && terraform -chdir=modules/dynamodb validate) && docker compose config -q`.

<details>
<summary>Pistas de conocimiento</summary>

- Los archivos con `TODO(reto)` son el ejercicio: el resto del repositorio ya está resuelto y no hace falta tocarlo.
- Si el comando de verificación falla, revisa la versión de las herramientas instaladas antes de modificar código.
- AGENTS.md describe el reto, el comando de verificación y las reglas del repositorio.

</details>

### Fase 1: Configuración inicial y creación de la tabla DynamoDB

**Objetivo:** Configurar el entorno de desarrollo y crear la tabla DynamoDB para almacenar las ordenes.

**Tiempo estimado:** 2 horas

**Instrucciones:**

- Configurar el proyecto con Express y AWS SDK v3.
- Crear la tabla DynamoDB con los atributos necesarios para las ordenes.

**Entregable:** Proyecto configurado con Express y tabla DynamoDB creada.

<details>
<summary>Pistas de conocimiento</summary>

- Uso de Terraform para la configuración de la infraestructura.

</details>

### Fase 2: Implementación de la API REST para operaciones CRUD

**Objetivo:** Implementar la API REST para realizar operaciones CRUD sobre la tabla DynamoDB.

**Tiempo estimado:** 4 horas

**Instrucciones:**

- Crear endpoints para crear, leer, actualizar y eliminar ordenes.
- Validar el campo status de las ordenes para asegurar que solo contenga los valores permitidos.

**Entregable:** API REST implementada con endpoints para operaciones CRUD sobre la tabla DynamoDB.

<details>
<summary>Pistas de conocimiento</summary>

- Uso de Express para crear endpoints.
- Validación de datos en las solicitudes.

</details>

### Fase 3: Pruebas de aceptación para las operaciones CRUD

**Objetivo:** Implementar pruebas de aceptación para verificar el funcionamiento correcto de las operaciones CRUD.

**Tiempo estimado:** 2 horas

**Instrucciones:**

- Implementar pruebas de aceptación para cada operación CRUD.
- Verificar que las pruebas cubren casos de éxito y de error.

**Entregable:** Pruebas de aceptación implementadas para verificar el funcionamiento correcto de las operaciones CRUD.

<details>
<summary>Pistas de conocimiento</summary>

- Uso de herramientas de testing para Node.js.

</details>

### Fase 4: Optimización y refactorización del código

**Objetivo:** Optimizar y refactorizar el código para mejorar la eficiencia y mantenibilidad.

**Tiempo estimado:** 2 horas

**Instrucciones:**

- Refactorizar el código para mejorar la legibilidad y mantenibilidad.
- Optimizar el código para mejorar la eficiencia.

**Entregable:** Código optimizado y refactorizado para mejorar la eficiencia y mantenibilidad.

<details>
<summary>Pistas de conocimiento</summary>

- Prácticas de optimización y refactorización de código.

</details>

## Dimensiones Evaluadas

- **queEs**: ¿Qué es una operación CRUD y cómo se implementa en una API REST?
- **paraQueSirve**: ¿Para qué sirve el campo status en las ordenes y cómo se valida?
- **comoSeUsa**: ¿Cómo se usan las pruebas de aceptación para verificar el funcionamiento de las operaciones CRUD?
- **erroresComunes**: ¿Cuáles son los errores comunes al implementar operaciones CRUD en una API REST y cómo se evitan?
- **queDecisionesImplica**: ¿Qué decisiones implica la optimización y refactorización del código para mejorar la eficiencia y mantenibilidad?

## Criterios de Evaluacion

- Configuración inicial y creación de la tabla DynamoDB.
- Implementación de la API REST para operaciones CRUD.
- Pruebas de aceptación para las operaciones CRUD.
- Optimización y refactorización del código.

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

## Pruebas de aceptacion

Las pruebas de aceptacion (columna "Prueba" de la tabla) son de **solo lectura**: definen que significa "listo". No las edites, no las borres y no les agregues `skip`; lo que se resuelve es el codigo de cada pieza.

## Restricciones del pedido

| Restriccion | Donde se cumple | Estado |
|-------------|-----------------|--------|
| Usar AWS SDK v3 (@aws-sdk/client-dynamodb) para hablar con DynamoDB | `app/src/application/services/OrderService.ts:OrderService` | Verificada |
| No usar Dynamoose ni otro ORM para DynamoDB | chequeo estatico (code): prohibe `@dynamoose/dynamoose` | Verificada |
| Las ordenes tienen un campo status con los valores pending, paid y shipped; las pruebas de aceptacion los verifican | `app/src/acceptance/f2.test.ts` > Verificar status de la orden | Restriccion no verificada en `app/src/acceptance/f2.test.ts` > Verificar status de la orden |

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

## Verificacion

El proyecto esta listo para trabajar cuando este comando corre sin errores:

```bash
(cd app && npm install --no-audit --no-fund && npm run build) && (cd infra && terraform init -backend=false && terraform -chdir=modules/dynamodb init -backend=false && terraform validate && terraform -chdir=modules/dynamodb validate) && docker compose config -q
```

---

*Reto generado automaticamente por Challenge Generator - Pragma*
