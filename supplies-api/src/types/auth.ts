import { z } from "zod";

import { SupbaseUserSchema } from "./user";

export const SessionSchema = z.object({
	provider_token: z.string().nullable().optional(),
	provider_refresh_token: z.string().nullable().optional(),
	access_token: z.string(),
	refresh_token: z.string(),
	expires_in: z.number(),
	expires_at: z.number().optional(),
	token_type: z.string(),
	user: SupbaseUserSchema,
});

export type Session = z.infer<typeof SessionSchema>;
export const WeakPasswordSchema = z.object({
	reasons: z.array(z.string()),
	message: z.string(),
});

export type WeakPassword = z.infer<typeof WeakPasswordSchema>;
