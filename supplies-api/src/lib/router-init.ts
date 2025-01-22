import { OpenAPIHono } from "@hono/zod-openapi";

import { cors } from "hono/cors";
import type { AppBindings } from "@/types";

import onError from "@/middlewares/error";
import notFound from "@/middlewares/not-found";

import { defaultHook } from "./openapi";
import logger from "@/middlewares/logger";

export function createRouter() {
	return new OpenAPIHono<AppBindings>({
		strict: false,
		defaultHook,
	});
}

export function createApp() {
	const app = createRouter();
	app.use(logger());
	app.use("*", cors());

	app.notFound(notFound);
	app.onError(onError);
	return app;
}
