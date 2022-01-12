const service = require('../services/garages.service');
const { sendResult } = require('../helpers/async-controller');

function fetchGarages(request, response, next) {
	return sendResult(
		service.fetchGarages(request.query),
		response,
		next,
	);
}

function fetchGarage(request, response, next) {
	return sendResult(
		service.fetchGarage(request.params.id),
		response,
		next,
	);
}

module.exports = {
	fetchGarages,
	fetchGarage,
};
