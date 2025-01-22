import { fakerEN, fakerDE, fakerZH_CN } from "@faker-js/faker";

for (const faker of [fakerEN, fakerDE, fakerZH_CN]) {
	const fullName = faker.person.fullName();
	console.log(fullName);
}

const emailProviders = ["stud.srh-campus-berlin.de", "srh.de"];

const getRandomProvider = () => {
	const random = Math.floor((Math.random() * 10) % 2);
	emailProviders[random];

	return emailProviders[random];
};

fakerEN.internet.email({
	firstName: "Jeanne",
	lastName: "Doe",
	provider: getRandomProvider(),
}); // 'Jeanne_Doe88@example.fakerjs.dev'
