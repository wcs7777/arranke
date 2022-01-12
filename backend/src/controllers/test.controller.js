const logger = require('../helpers/logger');

function caughtError(request, response) {
	throw new Error('Caught error test');
}

function uncaughtError(request, response) {
	process.nextTick(() => {
		throw new Error('Uncaught error test');
	});
}

function filters(request, response, next) {
	logger.info(request.query, 'query');
	next();
}

function filtered(request, response) {
	logger.info(request.query, 'filtered');
	response.json(request.query);
}

module.exports = {
	caughtError,
	uncaughtError,
	filters,
	filtered,
};
