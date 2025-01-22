import {
	integer,
	pgTable,
	serial,
	timestamp,
	uuid,
	varchar,
} from "drizzle-orm/pg-core";
import { machinesTable } from "./machines";
import { productsTable } from "./products";
import { createInsertSchema, createSelectSchema } from "drizzle-zod";
import { z } from "zod";

export const inventoryTable = pgTable("inventory", {
	id: serial("id").primaryKey(),
	machineId: integer("machine_id").references(() => machinesTable.id),
	productId: uuid("product_id").references(() => productsTable.id, {
		onDelete: "cascade",
		onUpdate: "cascade",
	}),
	quantity: integer("quantity").notNull().default(0),
	lockerNumber: varchar("locker_number", { length: 10 }).notNull(),
	lastRestocked: timestamp("last_restocked")
		.defaultNow()
		.notNull()
		.$onUpdate(() => new Date()),
	createdAt: timestamp("created_at").defaultNow().notNull(),
	updatedAt: timestamp("updated_at")
		.defaultNow()
		.$onUpdate(() => new Date()),
});

export const InventorySelectSchema = createSelectSchema(inventoryTable);
export const InventoryInsertSchema = createInsertSchema(inventoryTable).omit({
	id: true,
	createdAt: true,
	updatedAt: true,
});

export type InventorySelectType = z.infer<typeof InventorySelectSchema>;
export type InventoryInsertType = z.infer<typeof InventoryInsertSchema>;
