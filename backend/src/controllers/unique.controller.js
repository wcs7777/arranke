const service = require('../services/unique.service');
const { sendResult } = require('../helpers/async-controller');

function verifyUnique(request, response, next) {
	return sendResult(
		service.isUnique(request.body),
		response,
		next,
	);
}

module.exports = {
	verifyUnique,
};
