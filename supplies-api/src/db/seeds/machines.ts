import { db } from "../index";
import { MachineInsertType, machinesTable } from "../schema";

export async function seedMachines() {
	const machines: MachineInsertType[] = [
		{
			name: "Machine A",
			address: "123 University Rd",
			machineCode: "MCH001",
			numberOfLockers: 10,
			status: "active",
		},
		{
			name: "Machine B",
			address: "456 University St",
			machineCode: "MCH002",
			numberOfLockers: 15,
			status: "active",
		},
		{
			name: "Machine C",
			address: "789 University Ave",
			machineCode: "MCH003",
			numberOfLockers: 12,
			status: "active",
		},
		{
			name: "Machine D",
			address: "101 University Blvd",
			machineCode: "MCH004",
			numberOfLockers: 8,
			status: "active",
		},
		{
			name: "Machine E",
			address: "202 University Ln",
			machineCode: "MCH005",
			numberOfLockers: 20,
			status: "active",
		},
		{
			name: "Machine F",
			address: "303 University Pl",
			machineCode: "MCH006",
			numberOfLockers: 25,
			status: "active",
		},
	];

	return await db.insert(machinesTable).values(machines).returning();
}
