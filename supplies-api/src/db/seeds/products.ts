import { db } from "../index";
import {
	CategorySelectType,
	ProductInsertType,
	productsTable,
} from "../schema";

export async function seedProducts(categories: CategorySelectType[]) {
	const products: ProductInsertType[] = [
		{
			categoryId: categories[0].id,
			name: "Premium Pen Set",
			description: "High-quality writing pens",
			price: "15.99",
			image: "pen-set.jpg",
		},
		{
			categoryId: categories[1].id,
			name: "Notebook Bundle",
			description: "Pack of 3 notebooks",
			price: "12.99",
			image: "notebooks.jpg",
		},
		{
			categoryId: categories[2].id,
			name: "USB Drive",
			description: "32GB USB flash drive",
			price: "19.99",
			image: "usb-drive.jpg",
		},
		{
			categoryId: categories[3].id,
			name: "Sketch Set",
			description: "Professional sketching kit",
			price: "24.99",
			image: "sketch-set.jpg",
		},
		{
			categoryId: categories[4].id,
			name: "Basic Stationery Kit",
			description: "Essential stationery items",
			price: "9.99",
			image: "stationery-kit.jpg",
		},
	];

	return await db.insert(productsTable).values(products).returning();
}
