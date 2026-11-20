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