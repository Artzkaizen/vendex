import { createRoute } from "@hono/zod-openapi";
import { z } from "zod";

import {
	ProductInsertSchema,
	ProductPatchSchema,
	ProductSelectSchema,
} from "@/db/schema";
import { createRouter } from "@/lib/router-init";
import createErrorSchema from "@/utils/error-schema";
import * as StatusCodes from "@/utils/http-status-codes";
import responseContent from "@/utils/response-content";

import * as handler from "./handler";

const IdParamsSchema = z.object({
	id: z
		.string()
		.uuid()
		.openapi({
			param: {
				name: "id",
				in: "path",
			},
		}),
});

const tags = ["Product"];
export const allProducts = createRoute({
	tags,
	method: "get",
	path: "/products",
	request: {
		query: z.object({
			category: z.coerce.number().optional(),
		}),
	},
	responses: {
		[StatusCodes.OK]: responseContent(
			z.array(ProductSelectSchema),
			"All Supplies",
		),
	},
});

export const getOne = createRoute({
	tags,
	method: "get",
	path: "/products/{id}",
	request: {
		params: IdParamsSchema,
	},
	responses: {
		[StatusCodes.OK]: responseContent(ProductSelectSchema, "One Supply"),
		[StatusCodes.NOT_FOUND]: responseContent(
			z
				.object({
					message: z.string(),
				})
				.openapi({
					example: {
						message: "Supply not found",
					},
				}),
			"Supply Not Found",
		),
		[StatusCodes.UNPROCESSABLE_ENTITY]: responseContent(
			createErrorSchema(IdParamsSchema),
			"Validation Error(s)",
		),
	},
});

export const deleteOne = createRoute({
	tags,
	method: "delete",
	path: "/products/{id}",
	request: {
		params: IdParamsSchema,
	},
	responses: {
		[StatusCodes.OK]: responseContent(
			z.object({
				success: z.boolean(),
			}),
			"Supply to be deleted",
		),
		[StatusCodes.NOT_FOUND]: responseContent(
			z
				.object({
					success: z.boolean(),
				})
				.openapi({
					example: {
						success: true,
					},
				}),
			"Supply Not Found",
		),
		[StatusCodes.UNPROCESSABLE_ENTITY]: responseContent(
			createErrorSchema(IdParamsSchema),
			"Validation Error(s)",
		),
	},
});

export const create = createRoute({
	tags,
	method: "post",
	path: "/products",
	request: {
		body: responseContent(ProductInsertSchema, "New Product", true),
	},
	responses: {
		[StatusCodes.OK]: responseContent(ProductSelectSchema, "Added new Product"),
		[StatusCodes.NOT_FOUND]: responseContent(
			z
				.object({
					message: z.string(),
				})
				.openapi({
					example: {
						message: "Supply not found",
					},
				}),
			"Supply Not Found",
		),
		[StatusCodes.UNPROCESSABLE_ENTITY]: responseContent(
			createErrorSchema(ProductSelectSchema),
			"Validation Error(s)",
		),
		[StatusCodes.BAD_REQUEST]: responseContent(
			z
				.object({
					message: z.string(),
				})
				.openapi({
					example: {
						message: "Failed to create product",
					},
				}),
			"Failed to create product",
		),
	},
});
export const patch = createRoute({
	tags,
	method: "patch",
	path: "/products/{id}",
	request: {
		params: IdParamsSchema,
		body: responseContent(ProductPatchSchema, "Update Product", true),
	},
	responses: {
		[StatusCodes.OK]: responseContent(ProductSelectSchema, "Upadated Product"),
		[StatusCodes.NOT_FOUND]: responseContent(
			z
				.object({
					message: z.string(),
				})
				.openapi({
					example: {
						message: "Product not found",
					},
				}),
			"Product Not Found",
		),
		[StatusCodes.UNPROCESSABLE_ENTITY]: responseContent(
			createErrorSchema(ProductPatchSchema).or(
				createErrorSchema(IdParamsSchema),
			),
			"Validation Error(s)",
		),
	},
});

const router = createRouter()
	.openapi(allProducts, handler.all)
	.openapi(create, handler.create)
	.openapi(getOne, handler.getOne)
	.openapi(deleteOne, handler.deleteOne)
	.openapi(patch, handler.patch);

export default router;
export type AllRoute = typeof allProducts;
export type CreateRoute = typeof create;
export type GetOneRoute = typeof getOne;
export type DeleteOneRoute = typeof deleteOne;
export type PatchOneRoute = typeof patch;
