import { z } from "@hono/zod-openapi";

import type { ZodSchema } from "@/types";

import * as StatusPhrases from "@/utils/http-status-phrases";

export default function responseContent<
	T extends ZodSchema,
>(schema: T, description: string, required = false) {
	return {
		content: {
			"application/json": {
				schema,
			},
		},
		description,
		required,
	};
}

export function createMessageObjectSchema(exampleMessage: string = "Hello World") {
	return z.object({
		message: z.string(),
	}).openapi({
		example: {
			message: exampleMessage,
		},
	});
}

export const notFoundSchema = createMessageObjectSchema(StatusPhrases.NOT_FOUND);
