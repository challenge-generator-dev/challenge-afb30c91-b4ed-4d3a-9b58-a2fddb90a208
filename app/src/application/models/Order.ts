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