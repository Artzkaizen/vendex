import db from "../index";
import { categoriesTable, CategoryInsertType } from "../schema";

export async function seedCategories() {
	const categories: CategoryInsertType[] = [
		{ name: "Writing", description: "Various writing materials" },
		{ name: "Paper", description: "Paper products for students" },
		{ name: "Tech", description: "Electronic devices and accessories" },
		{ name: "Art", description: "Art supplies and materials" },
		{ name: "Writing", description: "Essential stationery items" },
		{ name: "Office Supplies", description: "Office essentials" },
	];

	return await db.insert(categoriesTable).values(categories).returning();
}
