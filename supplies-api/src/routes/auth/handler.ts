import { createClient } from "@supabase/supabase-js";
import bcrypt from "bcrypt";

import type { AppRouteHandler } from "@/types";

import db from "@/db";
import { usersTable } from "@/db/schema";
import env from "@/env";
import * as StatusCodes from "@/utils/http-status-codes";

import type {
	LoginRoute,
	LogoutRoute,
	ResendVerificationRoute,
	SignUpOTPRoute,
	SignUpRoute,
	VerifyEmailRoute,
} from "./route";

const supabase = createClient(env.SUPABASE_URL, env.SUPABASE_ANON_KEY);

export const signup: AppRouteHandler<SignUpRoute> = async (c) => {
	const newUser = c.req.valid("json");

	const { data, error } = await supabase.auth.signUp({
		email: newUser.email,
		password: newUser.password,
	});
	if (error)
		return c.json({ message: error.message }, StatusCodes.BAD_REQUEST);
	const hashedPassword = await bcrypt.hash(newUser.password, 10);
	await db
		.insert(usersTable)
		.values({
			...newUser,
			password: hashedPassword,
		})
		.returning();
	return c.json(data, StatusCodes.CREATED);
};
export const signupWithOtp: AppRouteHandler<SignUpOTPRoute> = async (c) => {
	const newUser = c.req.valid("json");

	const { data, error } = await supabase.auth.signUp({
		email: newUser.email,
		password: newUser.password,
	});
	if (error)
		return c.json({ message: error.message }, StatusCodes.BAD_REQUEST);
	const hashedPassword = await bcrypt.hash(newUser.password, 10);
	await db
		.insert(usersTable)
		.values({
			...newUser,
			password: hashedPassword,
		})
		.returning();
	return c.json(data, StatusCodes.CREATED);
};
export const login: AppRouteHandler<LoginRoute> = async (c) => {
	try {
		const user = c.req.valid("json");

		const { data, error } = await supabase.auth.signInWithPassword({
			email: user.email,
			password: user.password,
		});

		if (error) {
			return c.json({ message: error.message }, StatusCodes.BAD_REQUEST);
		}

		return c.json(
			{
				message: "Login successful",
				...data,
			},
			StatusCodes.OK,
		);
	}
	catch (err) {
		console.error(err);
		return c.json({ message: "Invalid credentials" }, StatusCodes.UNAUTHORIZED);
	}
};
export const logout: AppRouteHandler<LogoutRoute> = async (c) => {
	try {
		const { error } = await supabase.auth.signOut();

		if (error) {
			return c.json({ message: error.message }, StatusCodes.BAD_REQUEST);
		}

		return c.body(null, StatusCodes.NO_CONTENT);
	}
	catch (err) {
		console.error(err);
		return c.json({ message: "Error during logout" }, StatusCodes.INTERNAL_SERVER_ERROR);
	}
};

export const verifyEmail: AppRouteHandler<VerifyEmailRoute> = async (c) => {
	const { access_token } = c.req.valid("query");

	if (!access_token) {
		return c.json({ error: "Access token is required" }, 400);
	}

	// const { data, error } = await supabase.auth.getUser(access_token);

	const { data, error } = await supabase.auth.verifyOtp({
		token_hash: access_token,
		type: "signup",
		options: {
			redirectTo: `http://localhost:3000/auth/verify-email`,
		},
	});

	if (error || !data) {
		return c.json({ error: "Invalid access token" }, 401);
	}

	// Here, you can perform additional logic if needed, such as updating user status
	// For example, activating the user account

	return c.json({ message: "Email verified successfully", user: data }, 200);
};

export const resendVerification: AppRouteHandler<
	ResendVerificationRoute
> = async (c) => {
	try {
		const { email } = c.req.valid("json");

		// Check if user exists and is unverified
		const {
			data: { users },
		} = await supabase.auth.admin.listUsers();
		const user = users?.find(u => u.email === email && !u.email_confirmed_at);

		if (!user) {
			return c.json(
				{
					message: "No pending verification found for this email",
				},
				StatusCodes.BAD_REQUEST,
			);
		}

		// Resend verification email
		const { error } = await supabase.auth.resend({
			type: "signup",
			email,
			options: {
				emailRedirectTo: `http:localhost:3000/auth/verify-email`,
			},
		});

		if (error) {
			return c.json({ message: error.message }, StatusCodes.BAD_REQUEST);
		}

		return c.json(
			{
				message: "Verification email resent successfully",
			},
			StatusCodes.OK,
		);
	}
	catch (err) {
		console.error(err);
		return c.json(
			{
				message: "Error resending verification email",
			},
			StatusCodes.BAD_REQUEST,
		);
	}
};
