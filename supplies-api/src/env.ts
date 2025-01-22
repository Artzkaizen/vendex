import { config } from "dotenv";
import { expand } from "dotenv-expand";
import path from "node:path";
import { z } from "zod";

expand(
	config({
		path: path.resolve(
			process.cwd(),
			// eslint-disable-next-line node/no-process-env
			process.env.NODE_ENV === "test" ? ".env.test" : ".env",
		),
	}),
);
const stringToBoolean = z.coerce
	.string()
	.transform((val) => {
		return val === "true";
	})
	.default("false");

export const envSchema = z
	.object({
		PORT: z.coerce.number().default(3000),
		LOG_LEVEL: z
			.enum(["fatal", "error", "warn", "info", "debug", "trace", "silent"])
			.default("info"),
		SUPABASE_URL: z.string().url(),
		SUPABASE_DATABASE_URL: z.string().url(),
		SUPABASE_ANON_KEY: z.string(),
		SUPABASE_SERVICE_KEY: z.string().optional(),
		JWT_SECRET: z.string(),
		NODE_ENV: z.string(),
		DB_MIGRATING: stringToBoolean,
		DB_SEEDING: stringToBoolean,
		RESEND_API_KEY: z.string().startsWith("re"),
		STRIPE_PUBLIC_KEY: z.string(),
		STRIPE_SECRET_KEY: z.string(),
	})
	.superRefine((input, ctx) => {
		if (input.NODE_ENV === "production" && !input.SUPABASE_URL) {
			ctx.addIssue({
				code: z.ZodIssueCode.invalid_type,
				expected: "string",
				received: "undefined",
				path: ["DATABASE_AUTH_TOKEN"],
				message: "Must be set when NODE_ENV is 'production'",
			});
		}
	});

// eslint-disable-next-line node/no-process-env
const { data: env, error } = envSchema.safeParse(process.env);

if (error) {
	console.error("❌ Invalid env:");
	console.error(JSON.stringify(error.flatten().fieldErrors, null, 2));
	process.exit(1);
}

export default env!;
