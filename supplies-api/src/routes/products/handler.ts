import { createClient } from "@supabase/supabase-js";
import { eq } from "drizzle-orm";
import { Buffer } from "node:buffer";
import { z } from "zod";

import type { AppRouteHandler } from "@/types";

import db from "@/db";
import { productsTable } from "@/db/schema";
import env from "@/env";
import * as StatusCodes from "@/utils/http-status-codes";

import type {
	AllRoute,
	CreateRoute,
	DeleteOneRoute,
	GetOneRoute,
	PatchOneRoute,
} from "./route";

const supabase = createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_KEY ?? env.SUPABASE_ANON_KEY);

export const all: AppRouteHandler<AllRoute> = async (c) => {
	const { category } = c.req.valid("query");
	if (!category) {
		const products = await db.query.productsTable.findMany();
		return c.json(products);
	}

	const products = await db.query.productsTable.findMany({
		where: (product, { eq }) => eq(product.categoryId, category),
	});
	return c.json(products);
};

export const fileSchema = z.string().refine(val => /^data:image\/\w+;base64,/.test(val), {
	message: "Invalid image format. Expected Base64 string with MIME type.",
}).transform((val) => {
	const match = val.match(/^data:(image\/\w+);base64,(.+)$/);
	return {
		fileType: match ? match[1] : "image/jpg",
		encoded: match ? match[2] : val,
	};
});

async function uploadFile(image: string) {
	const parsedImage = fileSchema.parse(image);
	const buffer = Buffer.from(parsedImage.encoded, "base64");
	const uniqueFileName = `${crypto.randomUUID()}.${parsedImage.fileType.split("/")[1]}`;

	const { error: uploadError } = await supabase.storage
		.from("images")
		.upload(uniqueFileName, buffer, {
			contentType: parsedImage.fileType,
			upsert: false,
		});

	if (uploadError) {
		console.error(uploadError);
		return { message: "Failed to upload file" };
	}

	const { data } = supabase.storage.from("images").getPublicUrl(uniqueFileName);

	return { imageUrl: data.publicUrl };
}

export const create: AppRouteHandler<CreateRoute> = async (c) => {
	const newProduct = c.req.valid("json");

	const { imageUrl } = await uploadFile(newProduct.image);
	if (!imageUrl) {
		return c.json({ message: "Failed to upload image" }, StatusCodes.BAD_REQUEST);
	}
	const [product] = await db
		.insert(productsTable)
		.values({
			...newProduct,
			image: imageUrl,
		})
		.returning();
	return c.json(product, StatusCodes.OK);
};
export const getOne: AppRouteHandler<GetOneRoute> = async (c) => {
	const { id } = c.req.valid("param");
	const supply = await db.query.productsTable.findFirst({
		where: (supply, { eq }) => eq(supply.id, id),
	});
	if (!supply)
		return c.json({ message: "Supply not found" }, StatusCodes.NOT_FOUND);

	return c.json(supply, StatusCodes.OK);
};
export const deleteOne: AppRouteHandler<DeleteOneRoute> = async (c) => {
	const { id } = c.req.valid("param");
	const [product] = await db
		.delete(productsTable)
		.where(eq(productsTable.id, id))
		.returning();

	if (!product)
		return c.json({ success: false }, StatusCodes.NOT_FOUND);

	return c.json({ success: true }, StatusCodes.OK);
};
export const patch: AppRouteHandler<PatchOneRoute> = async (c) => {
	const { id } = c.req.valid("param");
	const supplyUpdate = c.req.valid("json");
	const [supply] = await db
		.update(productsTable)
		.set(supplyUpdate)
		.where(eq(productsTable.id, id))
		.returning();

	if (!supply)
		return c.json({ message: "Supply not found" }, StatusCodes.NOT_FOUND);

	return c.json(supply, StatusCodes.OK);
};
