import {
	integer,
	pgEnum,
	pgTable,
	serial,
	timestamp,
	varchar,
} from "drizzle-orm/pg-core";
import { createInsertSchema, createSelectSchema } from "drizzle-zod";
import { z } from "zod";

export const statusEnum = pgEnum("status", ["active", "inactive"]);

export const machinesTable = pgTable("machines", {
	id: serial("id").primaryKey(),
	name: varchar("name", { length: 100 }).notNull(),
	address: varchar("address", { length: 255 }).notNull(),
	machineCode: varchar("machine_code", { length: 50 }).notNull().unique(),
	status: statusEnum().notNull().default("active"),
	numberOfLockers: integer("number_of_lockers").notNull(),
	lastMaintenance: timestamp("last_maintenance"),
	createdAt: timestamp("created_at").notNull().defaultNow(),
	updatedAt: timestamp("updated_at")
		.defaultNow()
		.notNull()
		.$onUpdate(() => new Date()),
});

export const MachineInsertSchema = createInsertSchema(machinesTable).omit({
	id: true,
	createdAt: true,
	updatedAt: true,
});
export const MachineSelectSchema = createSelectSchema(machinesTable);
export type MachineInsertType = z.infer<typeof MachineInsertSchema>;
export type MachineSelectType = z.infer<typeof MachineSelectSchema>;
