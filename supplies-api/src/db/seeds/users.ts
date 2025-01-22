import bcrypt from "bcrypt";
import { db } from "../index";
import { UserInsertType, usersTable } from "../schema";

export async function seedUsers() {
	const hashedPassword = await bcrypt.hash(Date.now().toString(), 10);

	const users: UserInsertType[] = [
		{
			email: "admin@example.com",
			role: "admin",
			password: hashedPassword,
		},
		{
			email: "user1@example.com",
			role: "user",
			password: hashedPassword,
		},
		{
			email: "user2@example.com",
			role: "user",
			password: hashedPassword,
		},
	];

	return await db.insert(usersTable).values(users).returning();
}
