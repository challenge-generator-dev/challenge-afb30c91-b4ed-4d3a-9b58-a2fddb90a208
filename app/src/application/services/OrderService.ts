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