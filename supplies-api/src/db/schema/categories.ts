import {
	pgEnum,
	pgTable,
	serial,
	timestamp,
	varchar,
} from "drizzle-orm/pg-core";
import { createInsertSchema, createSelectSchema } from "drizzle-zod";
import { z } from "zod";

export const categoryNames = [
	"Writing",
	"Paper",
	"Tech",
	"Art",
	"Office Supplies",
] as const;

export const categoriesEnum = pgEnum("name", categoryNames);

export const categoriesTable = pgTable("categories", {
	id: serial("id").primaryKey(),
	name: categoriesEnum().notNull(),
	description: varchar("description", { length: 255 }),
	createdAt: timestamp("created_at").defaultNow(),
	updatedAt: timestamp("updated_at")
		.defaultNow()
		.$onUpdate(() => new Date()),
});

export const CategoryInsertSchema = createInsertSchema(categoriesTable)
	.omit({
		id: true,
		createdAt: true,
		updatedAt: true,
	})
	.transform((data) => ({
		...data,
		name: z.enum(categoryNames).parse(data.name),
	}));
export const CategorySelectSchema = createSelectSchema(
	categoriesTable
).transform((data) => ({
	...data,
	name: z.enum(categoryNames).parse(data.name),
}));

export type CategoryInsertType = z.infer<typeof CategoryInsertSchema>;
export type CategorySelectType = z.infer<typeof CategorySelectSchema>;
