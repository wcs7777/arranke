const data = require('../data/session.data');
const { encryptedIsEqual } = require('../helpers/crypt');
const { generateToken } = require('../helpers/token');

async function validCredentials(email, password) {
	return encryptedIsEqual(password, await data.userPassword(email));
}

async function generateResponse(email) {
	const row = await data.fetchUserForLogin(email);
	const authenticated = {
		name: row.name,
		type: 'Usuário',
	};
	const payload = { user: row.id };
	if (row.dealer_id) {
		payload.dealer = row.dealer_id;
		if (row.individual_id) {
			authenticated.type = 'Individual';
			payload.individual = row.individual_id;
		} else {
			authenticated.type = 'Garagem';
			authenticated.garage = row.garage_name;
			payload.garage = row.garage_id;
		}
	}
	return { authenticated, token: await generateToken(payload) };
}

module.exports = {
	validCredentials,
	generateResponse,
};
