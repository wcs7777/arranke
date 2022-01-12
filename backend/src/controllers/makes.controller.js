const service = require('../services/makes.service');
const { sendResult } = require('../helpers/async-controller');

function fetchMakeModels(request, response, next) {
	return sendResult(
		service.fetchMakeModels(request.params.id),
		response,
		next,
	);
}

module.exports = {
	fetchMakeModels,
};
