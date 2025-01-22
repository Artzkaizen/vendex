import { defineConfig } from "drizzle-kit";

import env from "@/env";

export default defineConfig({
	schema: "./src/db/schema.ts",
	out: "./supabase/migrations",
	migrations: {
		prefix: "timestamp",
	},
	dialect: "postgresql",
	dbCredentials: {
		url: env.SUPABASE_URL!,
	},
});
