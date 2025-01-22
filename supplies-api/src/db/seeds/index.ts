import { client } from "../index";
import { seedMachines } from "./machines";
import { seedCategories } from "./categories";
import { seedProducts } from "./products";
import { seedUsers } from "./users";
import { seedInventory } from "./inventory";
import { seedOrders } from "./orders";
import { seedPayments } from "./payments";

async function seed() {
	try {
		console.log("Starting seed process...");

		console.log("Seeding machines...");
		const machines = await seedMachines();

		console.log("Seeding categories...");
		const categories = await seedCategories();

		console.log("Seeding products...");
		const products = await seedProducts(categories);

		console.log("Seeding users...");
		const users = await seedUsers();

		console.log("Seeding inventory...");
		await seedInventory(machines, products);

		console.log("Seeding orders...");
		const orders = await seedOrders(machines, products, users);

		console.log("Seeding payments...");
		await seedPayments(orders, users);

		console.log("Seeding completed successfully!");
	} catch (error) {
		console.error("Error during seeding:", error);
		throw error;
	} finally {
		await client.end();
		process.exit(0);
	}
}

seed().catch((error) => {
	console.error("Error seeding the database:", error);
	process.exit(1);
});
