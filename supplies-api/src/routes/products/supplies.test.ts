import { testClient } from "hono/testing";
import { describe, expect, it } from "vitest";

import { createApp } from "@/lib/router-init";
import router from "@/routes/products/route";

const app = testClient(createApp().route("/", router));

describe("supplies", () => {
	it("should return all supplies", async () => {
		const response = await app.supplies.$get();
		const supplies = await response.json();
		expect(response.status).toBe(200);
		expect(supplies).toBeInstanceOf(Array);
	});
});
