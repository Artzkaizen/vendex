import { jwt } from "hono/jwt";

import env from "@/env";

const jwtMiddleware = jwt({
	secret: env.JWT_SECRET,
});

export default jwtMiddleware;
