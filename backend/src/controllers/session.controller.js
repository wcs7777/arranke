const service = require('../services/session.service');
const config = require('../helpers/config');
const statusCode = require('../helpers/status-code');

async function authenticate(request, response, next) {
	try {
		const { email, password } = request.body;
		if (await service.validCredentials(email, password)) {
			const { authenticated, token } = await service.generateResponse(email);
			if (request.query.token) {
				authenticated.token = token;
			}
			return response
				.cookie(
					config.session.token.cookie,
					token,
					{
						httpOnly: config.usingHttps,
						sameSite: (config.usingHttps)? 'none' : 'lax',
						signed: true,
						secure: config.usingHttps,
					},
				)
				.json(authenticated);
		} else {
			return response
				.status(statusCode.invalidCredentials)
				.json({ message: 'Invalid credentials' });
		}
	} catch (err) {
		next(err);
	}
}

function isAuthenticated(request) {
	return (request[config.session.user] !== undefined);
}

function verifyAuthentication(request, response, next) {
	if (isAuthenticated(request)) {
		next();
	} else {
		response
			.status(statusCode.unauthenticated)
			.json({ message: 'Need authentication' });
	}
}

function verifyLoginAuthorization(request, response, next) {
	if (!isAuthenticated(request)) {
		next();
	} else {
		response
			.json({ message: 'User is already authenticated' });
	}
}

function finishSession(request, response, next) {
	response.clearCookie(config.session.token.cookie, { path : '/' });
	next();
}

function logout(request, response) {
	response
		.location('/login')
		.json({
			message: 'logout',
		});
}

function authenticated(request, response) {
	response.json({ authenticated: isAuthenticated(request) });
}

module.exports = {
	authenticate,
	isAuthenticated,
	verifyAuthentication,
	verifyLoginAuthorization,
	finishSession,
	logout,
	authenticated,
};
