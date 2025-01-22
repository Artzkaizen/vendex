import { createRoute } from "@hono/zod-openapi";
import { z } from "zod";

import { CategorySelectSchema } from "@/db/schema";
import { createRouter } from "@/lib/router-init";
import * as StatusCodes from "@/utils/http-status-codes";
import responseContent from "@/utils/response-content";

import * as handler from "./handler";

const tags = ["categories"];
export const allCategories = createRoute({
	tags,
	method: "get",
	path: "/categories",
	responses: {
		[StatusCodes.OK]: responseContent(
			z.array(CategorySelectSchema._def.schema),
			"All Categories",
		),
	},
});

const router = createRouter().openapi(allCategories, handler.all);
// .openapi(create, handler.create)
// .openapi(getOne, handler.getOne)
// .openapi(deleteOne, handler.deleteOne)
// .openapi(patch, handler.patch);

export default router;
export type AllRoute = typeof allCategories;
// export type CreateRoute = typeof create;
// export type GetOneRoute = typeof getOne;
// export type DeleteOneRoute = typeof deleteOne;
// export type PatchOneRoute = typeof patch;
