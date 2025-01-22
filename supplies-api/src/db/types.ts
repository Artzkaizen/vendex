import { createInsertSchema, createSelectSchema } from "drizzle-zod";

import { productsTable, usersTable } from "./schema";

export const insertUserSchema = createSelectSchema(usersTable, {
	email: (schema) =>
		schema.email
			.email()
			.refine(
				(email) =>
					email.endsWith("@srh.de") ||
					email.endsWith("@stud.srh-campus-berlin.de"),
				{
					message: "Email must end with @srh.de or @stud.srh-campus-berlin.de",
				}
			),
	password: (schema) =>
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
export const SelectUserSchema = createSelectSchema(usersTable, {
	email: (schema) =>
		schema.email
			.email()
			.refine(
				(email) =>
					email.endsWith("@srh.de") ||
					email.endsWith("@stud.srh-campus-berlin.de"),
				{
					message: "Email must end with @srh.de or @stud.srh-campus-berlin.de",
				}
			),
	password: (schema) =>
		schema.password
			.min(8)
			.max(255)
			.regex(/^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*])[a-z\d!@#$%^&*]+$/i, {
				message:
					"Password must include at least one letter, one number, and one special character",
			}),
});
