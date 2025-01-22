import type { Hook } from "@hono/zod-openapi";

import { apiReference } from "@scalar/hono-api-reference";

import type { AppOpenAPI } from "@/types";

import { UNPROCESSABLE_ENTITY } from "@/utils/http-status-codes";

import packageJson from "../../package.json";

export const defaultHook: Hook<any, any, any, any> = (result, c) => {
	if (!result.success) {
		return c.json(
			{
				success: result.success,
				error: result.error,
			},
			UNPROCESSABLE_ENTITY,
		);
	}
};

export function configOpenAPI(app: AppOpenAPI) {
	app.doc("/docs", {
		openapi: "3.0.0",
		info: {
			version: packageJson.version,
			description: "This is a Supplies API documentation",
			title: "API Documentation",
		},
	});
	app.get("/reference", apiReference({
		theme: "kepler",
		layout: "classic",
		defaultHttpClient: {
			targetKey: "javascript",
			clientKey: "fetch",
		},
		spec: {
			url: "/docs",
		},
	}));
};
