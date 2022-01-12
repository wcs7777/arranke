const service = require('../services/car-properties.service');
const { sendResult } = require('../helpers/async-controller');

function fetchCarProperties(request, response, next) {
	return sendResult(
		service.fetchCarProperties(),
		response,
		next,
	);
}

module.exports = {
	fetchCarProperties,
};
