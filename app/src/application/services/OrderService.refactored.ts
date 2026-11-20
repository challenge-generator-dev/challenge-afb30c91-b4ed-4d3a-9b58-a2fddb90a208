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