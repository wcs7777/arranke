const { extractPayload } = require('../helpers/token');
const config = require('../helpers/config');
const logger = require('../helpers/logger');

async function addTokenPayloadToRequest(request, response, next) {
	try {
		const token = (
			tokenFromHeader(request) ||
			request.signedCookies[config.session.token.cookie]
		);
		if (token) {
			request[config.session.user] = await extractPayload(token);
		}
	} catch (err) {
		logger.error(err, 'Token error');
	} finally {
		next();
	}
}

function tokenFromHeader(request) {
	const authorization = request.header('authorization');
	return (authorization)? authorization.split(' ')[1] : undefined;
}

module.exports = addTokenPayloadToRequest;
