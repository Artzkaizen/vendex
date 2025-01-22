import Stripe from "stripe";

import type { AppRouteHandler } from "@/types";

import env from "@/env";
import * as StatusCodes from "@/utils/http-status-codes";

import type { GetPublicKeyRoute, StripeCreateRoute } from "./route";

const stripe = new Stripe(env.STRIPE_SECRET_KEY);

export const stripeCreate: AppRouteHandler<StripeCreateRoute> = async (c) => {
	try {
		const { email, amount } = c.req.valid("json");
		const customer = await stripe.customers.create({ email });
		const ephemeralKey = await stripe.ephemeralKeys.create(
			{ customer: customer.id },
			{ apiVersion: "2024-10-28.acacia" },
		);
		const paymentIntent = await stripe.paymentIntents.create({
			amount: Math.floor(amount * 100),
			currency: "eur",
			customer: customer.id,
			payment_method_types: ["paypal", "card"],

		});
		return c.json({
			paymentIntent: paymentIntent.client_secret ?? "",
			ephemeralKey: ephemeralKey.secret ?? "",
			customerId: customer.id,
			publishableKey: env.STRIPE_PUBLIC_KEY,
		}, StatusCodes.OK);
	}
	catch (err) {
		if (err instanceof Error) {
			return c.json({ error: err.message }, StatusCodes.BAD_REQUEST);
		}
		return c.json({ error: "An unknown error occurred" }, StatusCodes.INTERNAL_SERVER_ERROR);
	}
};

export const getStripePublicKey: AppRouteHandler<GetPublicKeyRoute> = async (c) => {
	return c.json({ publishableKey: env.STRIPE_PUBLIC_KEY });
};
