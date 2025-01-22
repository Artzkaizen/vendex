import {
	decimal,
	integer,
	pgTable,
	serial,
	timestamp,
	varchar,
} from "drizzle-orm/pg-core";
import { ordersTable } from "./orders";
import { usersTable } from "./users";
import { createInsertSchema, createSelectSchema } from "drizzle-zod";
import { z } from "zod";

export const paymentsTable = pgTable("payments", {
	id: serial("id").primaryKey(),
	orderId: integer("order_id").references(() => ordersTable.id),
	userId: integer("user_id").references(() => usersTable.id),
	amount: decimal("amount", { precision: 10, scale: 2 }).notNull(),
	paymentMethod: varchar("payment_method", { length: 50 }).notNull(),
	transactionId: varchar("transaction_id", { length: 100 }).notNull().unique(),
	status: varchar("status", { length: 20 }).notNull(),
	createdAt: timestamp("created_at").defaultNow().notNull(),
	updatedAt: timestamp("updated_at").defaultNow().notNull(),
});

export const PaymentSelectSchema = createSelectSchema(paymentsTable);
export const PaymentInsertSchema = createInsertSchema(paymentsTable).omit({
	id: true,
	createdAt: true,
	updatedAt: true,
});

export type PaymentSelectType = z.infer<typeof PaymentSelectSchema>;
export type PaymentInsertType = z.infer<typeof PaymentInsertSchema>;
