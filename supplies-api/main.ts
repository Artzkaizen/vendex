import { fakerDE, fakerEN } from "@faker-js/faker";
import fs from "node:fs";

const users = [];
const faker = [fakerEN, fakerDE];
for (let i = 0; i < 100; i++) {
	const random = Math.floor((Math.random() * 10) % 2);

	const { lastName, firstName } = faker[random].person;

	const FirstName = firstName();
	const LastName = lastName();

	const emailProviders = ["stud.srh-campus-berlin.de", "srh.de"];
	const getRandomProvider = () => emailProviders[random];
	const user = {
		FirstName,
		LastName,
		email: fakerEN.internet
			.email({
				firstName: FirstName,
				lastName: LastName,
				provider: getRandomProvider(),
			})
			.toLowerCase(),
	};
	users.push(user);
}
fs.appendFileSync("users.json", `${[JSON.stringify(users, null, 2)]}\n`);
