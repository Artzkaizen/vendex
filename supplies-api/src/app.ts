import env from "@/env";
import { configOpenAPI } from "@/lib/openapi";
import { createApp } from "@/lib/router-init";
import { createMockTimeOut } from "@/middlewares/mock-timeout";
import auth from "@/routes/auth/route";
import categories from "@/routes/categories/route";
import payments from "@/routes/payments/route";
import supplies from "@/routes/products/route";

const routes = [auth, supplies, categories, payments];

export const app = createApp();
configOpenAPI(app);

env.NODE_ENV === "development" && app.use(createMockTimeOut());

routes.forEach((route) => {
	app.route("/", route);
});

export type AppType = (typeof routes)[number];
export default app;
