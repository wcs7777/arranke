const service = require('../services/cars.service');
const { sendResult } = require('../helpers/async-controller');

function fetchCars(request, response, next) {
	return sendResult(
		service.fetchCars(request.query),
		response,
		next,
	);
}

function fetchCar(request, response, next) {
	return sendResult(
		service.fetchCar(request.params.id),
		response,
		next,
	);
}

module.exports = {
	fetchCars,
	fetchCar,
};
