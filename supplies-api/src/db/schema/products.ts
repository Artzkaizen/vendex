import { sql } from "drizzle-orm";
import {
	decimal,
	integer,
	pgTable,
	timestamp,
	uuid,
	varchar,
} from "drizzle-orm/pg-core";
import { createInsertSchema, createSelectSchema } from "drizzle-zod";
import { z } from "zod";

import { categoriesTable } from "./categories";

export const productsTable = pgTable("products", {
	id: uuid("id")
		.primaryKey()
		.default(sql`gen_random_uuid()`),
	categoryId: integer("category_id")
		.references(() => categoriesTable.id)
		.notNull(),
	name: varchar("name", { length: 100 }).notNull(),
	description: varchar("description", { length: 255 }).notNull(),
	price: decimal("price", { precision: 10, scale: 2 }).notNull(),
	image: varchar("image", { length: 255 }).notNull(),
	createdAt: timestamp("created_at").defaultNow().notNull(),
	updatedAt: timestamp("updated_at")
		.notNull()
		.defaultNow()
		.$onUpdate(() => new Date()),
});

const base64Regex = /^data:image\/[a-zA-Z]+;base64,[A-Za-z0-9+/=]+$/;
export const ProductSelectSchema = createSelectSchema(productsTable);
export const ProductInsertSchema = createInsertSchema(productsTable, {
	name: schema => schema.name.min(1).max(255),
	description: schema => schema.description.min(1).max(255),
	image: z.string()
		.min(1)
		.refine(value => base64Regex.test(value), {
			message: "Image must be a valid Base64 encoded string",
		}),
}).omit({
	id: true,
	createdAt: true,
	updatedAt: true,
});
export const ProductPatchSchema = ProductInsertSchema.partial();

export type ProductSelectType = z.infer<typeof ProductSelectSchema>;
export type ProductInsertType = z.infer<typeof ProductInsertSchema>;
export type ProductPatchType = z.infer<typeof ProductPatchSchema>;
