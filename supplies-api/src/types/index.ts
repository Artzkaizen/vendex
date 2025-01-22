import type { OpenAPIHono, RouteConfig, RouteHandler } from "@hono/zod-openapi";
import type { PinoLogger } from "hono-pino";

import { z } from "zod";

export interface AppBindings {
	Variables: {
		logger: PinoLogger;
		uploadedFile: {
			publicUrl: string;
			originalName: string;
			size: number;
			type: string;
		};
	};
}

export type AppOpenAPI = OpenAPIHono<AppBindings>;

export type AppRouteHandler<R extends RouteConfig> = RouteHandler<
	R,
	AppBindings
>;

export type ZodSchema =
	| z.ZodUnion<[z.AnyZodObject, z.AnyZodObject]>
	| z.AnyZodObject
	| z.ZodArray<z.AnyZodObject>;

const validEmailDomains = ["@srh.de", "@stud.srh-campus-berlin.de"];
export const validEmailSchema = z.string().email().refine(
	email => validEmailDomains.some(domain => email.endsWith(domain)),
	{
		message: `Email must end with ${validEmailDomains.join(" or ")}`,
	},
);
export type ValidEmailType = z.infer<typeof validEmailSchema>;
