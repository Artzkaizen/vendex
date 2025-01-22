import type { AppRouteHandler } from "@/types";

import db from "@/db";

import type { AllRoute } from "./route";

export const all: AppRouteHandler<AllRoute> = async (c) => {
	const categories = await db.query.categoriesTable.findMany();
	return c.json(categories);
};
