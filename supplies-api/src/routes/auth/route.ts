import { createRoute } from "@hono/zod-openapi";
import { z } from "zod";

import { insertUserSchema } from "@/db/types";
import { createRouter } from "@/lib/router-init";
import { SessionSchema, WeakPasswordSchema } from "@/types/auth";
import { SupbaseUserSchema } from "@/types/user";
import * as StatusCodes from "@/utils/http-status-codes";
import responseContent from "@/utils/response-content";

import * as handler from "./handler";

const AuthSchema = z.object({
	user: SupbaseUserSchema.nullable(),
	session: SessionSchema.nullable(),
	weakPassword: WeakPasswordSchema.optional(),
});

const login = createRoute({
	tags: ["Auth"],
	method: "post",
	path: "/auth/login",
	request: {
		body: responseContent(insertUserSchema, "User Credentials", true),
	},
	responses: {
		[StatusCodes.OK]: responseContent(AuthSchema, "User Logged in"),
		[StatusCodes.BAD_REQUEST]: responseContent(
			z.object({
				message: z.string(),
			}),
			"User already registered",
		),
		[StatusCodes.UNAUTHORIZED]: responseContent(
			z.object({
				message: z.string(),
			}),
			"User already registered",
		),
	},
});

const signup = createRoute({
	tags: ["Auth"],
	method: "post",
	path: "/auth/signup",
	request: {
		body: responseContent(insertUserSchema, "User Credentials", true),
	},
	responses: {
		[StatusCodes.CREATED]: responseContent(AuthSchema, "New User Created"),
		[StatusCodes.BAD_REQUEST]: responseContent(
			z.object({
				message: z.string(),
			}),
			"User already registered",
		),
	},
});
const signupWithOtp = createRoute({
	tags: ["Auth"],
	method: "post",
	path: "/auth/signup-otp",
	request: {
		body: responseContent(insertUserSchema, "User Credentials", true),
	},
	responses: {
		[StatusCodes.CREATED]: responseContent(AuthSchema, "New User Created"),
		[StatusCodes.BAD_REQUEST]: responseContent(
			z.object({
				message: z.string(),
			}),
			"User already registered",
		),
	},
});

const verifyEmail = createRoute({
	tags: ["Auth"],
	method: "get",
	path: "/auth/verify-email",
	request: {
		query: z.object({
			access_token: z.string(),
		}),
	},
	responses: {
		[StatusCodes.OK]: responseContent(
			z.object({
				message: z.string(),
				user: SupbaseUserSchema.nullable(),
			}),
			"Email Verified",
		),
		[StatusCodes.BAD_REQUEST]: responseContent(
			z.object({
				message: z.string(),
			}),
			"Invalid or Expired Token",
		),
	},
});

const resendVerification = createRoute({
	tags: ["Auth"],
	method: "post",
	path: "/auth/resend-verification",
	request: {
		body: responseContent(
			z.object({
				email: z.string().email(),
			}),
			"Resend Verification Email",
			true,
		),
	},
	responses: {
		[StatusCodes.OK]: responseContent(
			z.object({
				message: z.string(),
			}),
			"Verification Email Resent",
		),
		[StatusCodes.BAD_REQUEST]: responseContent(
			z.object({
				message: z.string(),
			}),
			"Invalid Request",
		),
	},
});

const logout = createRoute({
	tags: ["Auth"],
	method: "post",
	path: "/auth/logout",
	responses: {
		[StatusCodes.NO_CONTENT]: {
			description: "Task deleted",
		},
	},
});

const sendOtp = createRoute({
	tags: ["Auth"],
	method: "post",
	path: "/send-otp",
	request: {
		body: responseContent(
			z.object({
				email: z.string(),
			}),
			"Send OTP to Email",
			true,
		),
	},
	responses: {
		[StatusCodes.OK]: responseContent(
			z.object({
				success: z.boolean(),
				message: z.string(),
			}),
			"OTP Sent",
		),
	},
});

const verifyOtp = createRoute({
	tags: ["Auth"],
	method: "post",
	path: "/verify-otp",
	request: {
		body: responseContent(
			z.object({
				email: z.string(),
				otp: z.coerce.number(),
			}),
			"Verify OTP",
			true,
		),
	},
	responses: {
		[StatusCodes.OK]: responseContent(
			z.object({
				success: z.boolean(),
				message: z.string(),
			}),
			"OTP Verified",
		),
	},
});
;

const router = createRouter()
	.openapi(login, handler.login)
	.openapi(signup, handler.signup)
	.openapi(signupWithOtp, handler.signupWithOtp)
	.openapi(logout, handler.logout)
	.openapi(verifyEmail, handler.verifyEmail)
	.openapi(resendVerification, handler.resendVerification);

export default router;
export type LoginRoute = typeof login;
export type LogoutRoute = typeof logout;
export type SignUpRoute = typeof signup;
export type SignUpOTPRoute = typeof signupWithOtp;
export type SendOtpRoute = typeof sendOtp;
export type VerifyOtpRoute = typeof verifyOtp;
export type VerifyEmailRoute = typeof verifyEmail;
export type ResendVerificationRoute = typeof resendVerification;
