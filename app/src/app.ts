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