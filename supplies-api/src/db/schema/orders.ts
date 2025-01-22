import {
	decimal,
	integer,
	pgTable,
	serial,
	timestamp,
	uuid,
	varchar,
	boolean,
} from "drizzle-orm/pg-core";
import { machinesTable } from "./machines";
import { productsTable } from "./products";
import { usersTable } from "./users";
import { z } from "zod";
import { createInsertSchema, createSelectSchema } from "drizzle-zod";

export const ordersTable = pgTable("orders", {
	id: serial("id").primaryKey(),
	machineId: integer("machine_id").references(() => machinesTable.id),
	productId: uuid("product_id").references(() => productsTable.id),
	lockerNumber: varchar("locker_number", { length: 10 }).notNull(),
	userId: integer("user_id").references(() => usersTable.id),
	quantity: integer("quantity").notNull(),
	totalAmount: decimal("total_amount", { precision: 10, scale: 2 }).notNull(),
	paymentStatus: varchar("payment_status", { length: 20 }).notNull(),
	accessCode: varchar("access_code", { length: 10 }).notNull(),
	collected: boolean("collected").notNull().default(false),
	createdAt: timestamp("created_at").defaultNow().notNull(),
	updatedAt: timestamp("updated_at")
		.defaultNow()
		.notNull()
		.$onUpdate(() => new Date()),
});

export const OrderSelectSchema = createSelectSchema(ordersTable);
export const OrderInsertSchema = createInsertSchema(ordersTable).omit({
	id: true,
	createdAt: true,
	updatedAt: true,
});

export type OrderSelectType = z.infer<typeof OrderSelectSchema>;
export type OrderInsertType = z.infer<typeof OrderInsertSchema>;
