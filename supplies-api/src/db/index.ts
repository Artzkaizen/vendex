import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";

import env from "@/env";

import * as schema from "./schema";

export const client = postgres(env.SUPABASE_DATABASE_URL, {
	max: env.DB_MIGRATING || env.DB_SEEDING ? 1 : undefined,
	onnotice: env.DB_SEEDING ? () => {} : undefined,
});

export const db = drizzle(client, { schema });

export default db;
