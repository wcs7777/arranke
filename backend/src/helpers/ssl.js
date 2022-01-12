const { readFileSync } = require('fs');
const { fullPath } = require('./locations');

function ssl() {
	return {
		key: readFileSync(fullPath('key.pem')),
		cert: readFileSync(fullPath('cert.pem')),
	};
}

module.exports = ssl;
