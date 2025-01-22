import { db } from "../index";
import { OrderSelectType, UserSelectType, paymentsTable } from "../schema";

export async function seedPayments(
	orders: OrderSelectType[],
	users: UserSelectType[]
) {
	const payments = [
		{
			orderId: orders[0].id,
			userId: users[1].id,
			amount: "15.99",
			paymentMethod: "credit_card",
			transactionId: "txn_" + Date.now() + "_1",
			status: "successful",
		},
		{
			orderId: orders[1].id,
			userId: users[2].id,
			amount: "25.98",
			paymentMethod: "debit_card",
			transactionId: "txn_" + Date.now() + "_2",
			status: "successful",
		},
	];

	return await db.insert(paymentsTable).values(payments).returning();
}
