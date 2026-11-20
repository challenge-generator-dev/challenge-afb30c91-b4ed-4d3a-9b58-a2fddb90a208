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