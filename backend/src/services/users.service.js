const data = require('../data/users.data');
const affectedRowsResponse = require('../helpers/affected-rows-response');
const { encrypt, encryptedIsEqual } = require('../helpers/crypt');
const statusCode = require('../helpers/status-code');

function addUser(user) {
	return add(data.addUser, user);
}

function fetchUser(id) {
	return data.fetchUser(id);
}

function updateUser(user) {
	return data.updateUser(user);
}

async function removeUser(id) {
	return affectedRowsResponse({
		affectedRows: await data.removeUser(id),
		success: 'remove',
		attempt: 'remove user',
	});
}

async function updatePassword({ id, currentPassword, newPassword }) {
	if (await encryptedIsEqual(currentPassword, await data.userPassword(id))) {
		return affectedRowsResponse({
			affectedRows: await data.updatePassword(id, await encrypt(newPassword)),
			success: 'updated',
			attempt: 'update password',
		});
	} else {
		return affectedRowsResponse({
			affectedRows: 0,
			fail: 'The current password provided is incorrect',
			failStatus: statusCode.invalidParameters,
		});
	}
}

function addIndividual(individual) {
	return add(data.addIndividual, individual);
}

function upgradeToIndividual(individual) {
	return data.upgradeToIndividual(individual);
}

function updateIndividual(individual) {
	return data.updateIndividual(individual);
}

function fetchIndividual(id) {
	return data.fetchIndividual(id);
}

async function removeIndividual({ id, dealer }) {
	return affectedRowsResponse({
		affectedRows: await data.removeIndividual({ id, dealer }),
		success: 'remove',
		attempt: 'remove user',
	});
}

function addGarage(garage) {
	return add(data.addGarage, garage, 'responsible_password');
}

function upgradeToGarage(garage) {
	return data.upgradeToGarage(garage);
}

function fetchGarage(id) {
	return data.fetchGarage(id);
}

function updateGarage(garage) {
	return data.updateGarage(garage);
}

async function removeGarage({ id, dealer }) {
	return affectedRowsResponse({
		affectedRows: await data.removeGarage({ id, dealer }),
		success: 'remove',
		attempt: 'remove user',
	});
}

async function add(fn, values, passwordKey='password') {
	return fn({
		...values,
		[passwordKey]: await encrypt(values[passwordKey]),
	});
}

module.exports = {
	addUser,
	fetchUser,
	updateUser,
	removeUser,
	updatePassword,
	fetchIndividual,
	addIndividual,
	upgradeToIndividual,
	updateIndividual,
	removeIndividual,
	fetchGarage,
	addGarage,
	upgradeToGarage,
	updateGarage,
	removeGarage,
};
