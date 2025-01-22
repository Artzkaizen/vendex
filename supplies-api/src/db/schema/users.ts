import type { z } from "zod";

import {
	pgEnum,
	pgTable,
	serial,
	timestamp,
	varchar,
} from "drizzle-orm/pg-core";
import { createInsertSchema, createSelectSchema } from "drizzle-zod";

export const rolesEnum = pgEnum("roles", ["user", "admin"]);

export const usersTable = pgTable("users", {
	id: serial("id").primaryKey(),
	email: varchar("email", { length: 255 }).notNull().unique(),
	role: rolesEnum().notNull().default("user"),
	password: varchar("password", { length: 255 }).notNull(),
	createdAt: timestamp("created_at").notNull().defaultNow(),
	updatedAt: timestamp("updated_at")
		.defaultNow()
		.notNull()
		.$onUpdate(() => new Date()),
});

export const UserInsertSchema = createInsertSchema(usersTable, {
	email: schema =>
		schema.email
			.email()
			.refine(
				email =>
					email.endsWith("@srh.de")
					|| email.endsWith("@stud.srh-campus-berlin.de"),
				{
					message: "Email must end with @srh.de or @stud.srh-campus-berlin.de",
				},
			),
	password: schema =>
		schema.password
			.min(8)
			.max(255)
			.regex(/^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*])[a-z\d!@#$%^&*]+$/i, {
				message:
					"Password must include at least one letter, one number, and one special character",
			}),
}).omit({
	id: true,
	createdAt: true,
	updatedAt: true,
});

export const UserSelectSchema = createSelectSchema(usersTable);
export type UserSelectType = z.infer<typeof UserSelectSchema>;
export type UserInsertType = z.infer<typeof UserInsertSchema>;
