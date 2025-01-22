import { db } from "../index";
import {
	ordersTable,
	MachineSelectType,
	ProductSelectType,
	UserSelectType,
} from "../schema";

export async function seedOrders(
	machines: MachineSelectType[],
	products: ProductSelectType[],
	users: UserSelectType[]
) {
	const orders = [
		{
			machineId: machines[0].id,
			productId: products[0].id,
			userId: users[1].id,
			lockerNumber: "L01",
			quantity: 1,
			totalAmount: 15.99,
			paymentStatus: "completed",
			accessCode: "ABC123",
			collected: true,
		},
		{
			machineId: machines[1].id,
			productId: products[1].id,
			userId: users[2].id,
			lockerNumber: "L02",
			quantity: 2,
			totalAmount: 25.98,
			paymentStatus: "completed",
			accessCode: "DEF456",
			collected: false,
		},
	];

	return await db.insert(ordersTable).values(orders).returning();
}
