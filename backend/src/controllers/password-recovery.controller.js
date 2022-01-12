const service = require('../services/password-recovery.service');
const { sendResult, sendFeedback } = require('../helpers/async-controller');

function generateCode(request, response, next) {
	return sendFeedback(
		service.sendCode(
			request.body.email,
			request.query.send !== '0',
		),
		response,
		next,
	);
}

function verifyCode(request, response, next) {
	return sendResult(
		service.verifyCode(request.body),
		response,
		next,
	);
}

function newPassword(request, response, next) {
	return sendFeedback(
		service.updatePassword(request.body),
		response,
		next,
		{ locationSuccess: '/login' },
	);
}

module.exports = {
	generateCode,
	verifyCode,
	newPassword,
};
