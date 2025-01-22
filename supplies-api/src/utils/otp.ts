import crypto from "node:crypto";

export function generateOTP(length: number = 6) {
	return crypto.randomInt(0, 10 ** length);
}
