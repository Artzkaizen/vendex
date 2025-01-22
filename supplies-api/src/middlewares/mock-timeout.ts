import type { MiddlewareHandler } from "hono";

export function createMockTimeOut(timeoutMs: number = 2000): MiddlewareHandler {
	return async (_, next) => {
		await new Promise(resolve => setTimeout(resolve, timeoutMs));
		await next();
	};
}
