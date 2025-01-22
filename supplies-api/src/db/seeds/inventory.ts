import { db } from "../index";
import {
	inventoryTable,
	MachineSelectType,
	ProductSelectType,
} from "../schema";

export async function seedInventory(
	machines: MachineSelectType[],
	products: ProductSelectType[]
) {
	const inventory = machines.flatMap((machine) =>
		products.map((product, index) => ({
			machineId: machine.id,
			productId: product.id,
			quantity: Math.floor(Math.random() * 20) + 5,
			lockerNumber: `${machine.machineCode}-${(index + 1)
				.toString()
				.padStart(2, "0")}`,
		}))
	);

	return await db.insert(inventoryTable).values(inventory).returning();
}
