import { createRoute, z } from "@hono/zod-openapi";

import { createRouter } from "@/lib/router-init";
import { validEmailSchema } from "@/types";
import createErrorSchema from "@/utils/error-schema";
import * as StatusCodes from "@/utils/http-status-codes";
import responseContent from "@/utils/response-content";

import * as handler from "./handler";

const StripeCreateSchema = z.object({
	paymentIntent: z.string(),
	ephemeralKey: z.string(),
	customerId: z.string().uuid(),
	publishableKey: z.string(),
});
const tags = ["Payments"];
export const stripeCreate = createRoute({
	tags,
	method: "post",
	path: "/payments/stripe/create",
	request: {
		body: responseContent(z.object({
			userId: z.string().uuid(),
			email: validEmailSchema,
			amount: z.coerce.number().refine(v => v > 0, { message: "Amount must be greater than 0" }),
		}), "Create Payment Intent", true),

	},
	responses: {
		[StatusCodes.OK]: responseContent(StripeCreateSchema, "Create a payment intent"),
		[StatusCodes.UNPROCESSABLE_ENTITY]: responseContent(
			createErrorSchema(StripeCreateSchema),
			"Validation Error(s)",
		),
		[StatusCodes.INTERNAL_SERVER_ERROR]: responseContent(
			z.object({ error: z.string() }),
			"Validation Error(s)",
		),
	},
});
export const getStripePublicKey = createRoute({
	tags,
	method: "get",
	path: "/payments/stripe",
	responses: {
		[StatusCodes.OK]: responseContent(z.object({
			publishableKey: z.string(),
		}), "Stripe Public Key"),

	},
});

const router = createRouter()
	.openapi(stripeCreate, handler.stripeCreate)
	.openapi(getStripePublicKey, handler.getStripePublicKey);

export default router;

export type StripeCreateRoute = typeof stripeCreate;
export type GetPublicKeyRoute = typeof getStripePublicKey;
