import type {
	Factor,
	UserAppMetadata,
	UserIdentity,
	UserMetadata,
} from "@supabase/supabase-js";

import { z } from "zod";

export const SupbaseUserSchema = z.object({
	id: z.string(),
	app_metadata: z.custom<UserAppMetadata>(),
	user_metadata: z.custom<UserMetadata>(),
	aud: z.string(),
	confirmation_sent_at: z.string().optional(),
	recovery_sent_at: z.string().optional(),
	email_change_sent_at: z.string().optional(),
	new_email: z.string().optional(),
	new_phone: z.string().optional(),
	invited_at: z.string().optional(),
	action_link: z.string().optional(),
	email: z.string().optional(),
	phone: z.string().optional(),
	created_at: z.string(),
	confirmed_at: z.string().optional(),
	email_confirmed_at: z.string().optional(),
	phone_confirmed_at: z.string().optional(),
	last_sign_in_at: z.string().optional(),
	role: z.string().optional(),
	updated_at: z.string().optional(),
	identities: z.array(z.custom<UserIdentity>()).optional(),
	is_anonymous: z.boolean().optional(),
	factors: z.array(z.custom<Factor>()).optional(),
});

export type SupbaseUser = z.infer<typeof SupbaseUserSchema>;
