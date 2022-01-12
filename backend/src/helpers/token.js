const jwt = require('jsonwebtoken');
const config = require('./config');

function generateToken(payload) {
	return new Promise((resolve, reject) => (
		jwt.sign(
			{ [config.session.user]: payload },
			config.session.token.secret,
			{ ...config.session.token.options },
			(err, token) => (err)? reject(err) : resolve(token),
		)
	));
}

function extractPayload(token) {
	return new Promise((resolve, reject) => (
		jwt.verify(
			token,
			config.session.token.secret,
			{ ...config.session.token.options },
			(err, decodedToken) => {
				const key = config.session.user;
				if (err) {
					return reject(err);
				} else if (key && decodedToken[key]) {
					return resolve(decodedToken[key]);
				} else {
					return decodedToken;
				}
			},
		)
	));
}

module.exports = {
	generateToken,
	extractPayload,
};
