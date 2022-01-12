const service = require('../services/users.service');
const statusCode = require('../helpers/status-code');
const { isAuthenticated } = require('./session.controller');
const verifyValidation = require('../middleware/verify-validation');
const {
	sendResult,
	sendFeedback,
	nextIfSuccess,
} = require('../helpers/async-controller');
const {
	userId,
	dealerId,
	individualId,
	garageId,
} = require('../helpers/get-session-value');

const prohibitedMessage = {
	message: 'The current user does not have permission for this action',
};

function addUser(request, response, next) {
	return sendResult(
		service.addUser(request.body),
		response,
		next,
		{ locationSuccess: '/login' },
	);
}

function fetchUser(request, response, next) {
	return sendResult(
		service.fetchUser(userId(request)),
		response,
		next,
	);
}

function updateUser(request, response, next) {
	return sendResult(
		service.updateUser({
			...request.body,
			id: userId(request),
		}),
		response,
		next,
	);
}

function removeUser(request, response, next) {
	return nextIfSuccess(
		service.removeUser(userId(request)),
		response,
		next,
	);
}

function updatePassword(request, response, next) {
	return sendFeedback(
		service.updatePassword({
			...request.body,
			id: userId(request),
		}),
		response,
		next,
	);
}

function addIndividual(request, response, next) {
	const { name, email, password, phone, cpf, address } = request.body;
	const individual = {
		name,
		email,
		password,
		phone,
		cpf,
		...address,
	};
	const authenticated = isAuthenticated(request);
	const promise = (
		(!authenticated)?
		service.addIndividual(individual) :
		service.upgradeToIndividual({
			...individual,
			user: userId(request),
		})
	);
	return sendResult(
		promise,
		response,
		next,
		{ locationSuccess: (!authenticated)? '/login' : '/logout' },
	);
}

function fetchIndividual(request, response, next) {
	return sendResult(
		service.fetchIndividual(individualId(request)),
		response,
		next,
	);
}

function updateIndividual(request, response, next) {
	const { name, email, phone, cpf, address } = request.body;
	const individual = {
		name,
		email,
		phone,
		cpf,
		...address,
	};
	return sendResult(
		service.updateIndividual({
			...individual,
			id: individualId(request),
		}),
		response,
		next,
	);
}

function removeIndividual(request, response, next) {
	return nextIfSuccess(
		service.removeIndividual({
			id: individualId(request),
			dealer: dealerId(request),
		}),
		response,
		next,
	)
}

function addGarage(request, response, next) {
	const { name, cnpj, picture, address } = request.body;
	const responsible = request.body.responsible || {};
	const garage = {
		name,
		cnpj,
		picture,
		responsible_name: responsible.name,
		responsible_email: responsible.email,
		responsible_password: responsible.password,
		responsible_phone: responsible.phone,
		...address,
	};
	const authenticated = isAuthenticated(request);
	const promise = (
		(!authenticated)?
		service.addGarage(garage) :
		service.upgradeToGarage({
			...garage,
			user: userId(request),
		})
	);
	return sendResult(
		promise,
		response,
		next,
		{ locationSuccess: (!authenticated)? '/login' : '/logout' },
	);
}

function fetchGarage(request, response, next) {
	return sendResult(
		service.fetchGarage(garageId(request)),
		response,
		next,
	)
}

function updateGarage(request, response, next) {
	const { name, cnpj, picture, responsible, address } = request.body;
	const garage = {
		name,
		cnpj,
		picture,
		responsible_name: responsible.name,
		responsible_email: responsible.email,
		responsible_phone: responsible.phone,
		...address,
	};
	return sendResult(
		service.updateGarage({
			...garage,
			id: garageId(request),
		}),
		response,
		next,
	);
}

function removeGarage(request, response, next) {
	return nextIfSuccess(
		service.removeGarage({
			id: garageId(request),
			dealer: dealerId(request),
		}),
		response,
		next,
	);
}

function removeAllUserTypes(request, response, next) {
	if (!isDealer(request)) {
		return removeUser(request, response, next);
	} else if (isGarage(request)) {
		return removeGarage(request, response, next);
	} else {
		return removeIndividual(request, response, next);
	}
}

function verifyUserRegistrationAuthorization(request, response, next) {
	return verifyAuthorization(!isAuthenticated(request), response, next);
}

function verifyDealerRegistrationAuthorization(validate={add, upgrade}) {
	return (request, response, next) => {
		if (!isAuthenticated(request)) {
			return verifyValidation(validate.add)(request, response, next);
		}
		if (!isDealer(request)) {
			return verifyValidation(validate.upgrade)(request, response, next);
		} else {
			return response
				.status(statusCode.unauthorized)
				.json(prohibitedMessage);
		}
	};
}

function verifyDealerAuthorization(request, response, next) {
	return verifyAuthorization(isDealer(request), response, next);
}

function verifyIndividualAuthorization(request, response, next) {
	return verifyAuthorization(isIndividual(request), response, next);
}

function verifyGarageAuthorization(request, response, next) {
	return verifyAuthorization(isGarage(request), response, next);
}

function isDealer(request) {
	return (isAuthenticated(request) && dealerId(request) !== undefined);
}

function isIndividual(request) {
	return (isDealer(request) && individualId(request) !== undefined);
}

function isGarage(request) {
	return (isDealer(request) && garageId(request) !== undefined);
}

function verifyAuthorization(predicate, response, next) {
	if (predicate) {
		return next();
	} else {
		return response
			.status(statusCode.unauthorized)
			.json(prohibitedMessage);
	}
}

module.exports = {
	addUser,
	fetchUser,
	updateUser,
	updatePassword,
	addIndividual,
	fetchIndividual,
	updateIndividual,
	removeIndividual,
	addGarage,
	fetchGarage,
	updateGarage,
	removeGarage,
	removeAllUserTypes,
	verifyUserRegistrationAuthorization,
	verifyDealerRegistrationAuthorization,
	verifyDealerAuthorization,
	verifyIndividualAuthorization,
	verifyGarageAuthorization,
};
