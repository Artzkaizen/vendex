import pino from "pino";
import { logger } from "hono-pino";
import pretty from "pino-pretty";

export default function () {
	return logger({
		pino: pino(
			{
				level: "debug",
			},
			pretty()
		),
		http: {
			reqId: () => crypto.randomUUID(),
		},
	});
}
