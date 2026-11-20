import { Order, CreateOrderRequest, UpdateOrderRequest } from '../models/Order';

export interface OrderRepository {
    createOrder(request: CreateOrderRequest): Promise<Order>;
    getOrder(id: string): Promise<Order | null>;
    updateOrder(id: string, request: UpdateOrderRequest): Promise<Order>;
    deleteOrder(id: string): Promise<void>;
}