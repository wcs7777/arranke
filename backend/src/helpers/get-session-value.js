const config = require('./config');
const { session: { user: sessionUser } } = require('./config');

function getSessionValue(request, key) {
	return request[sessionUser][key];
}

function userId(request) {
	return getSessionValue(request, 'user');
}

function dealerId(request) {
	return getSessionValue(request, 'dealer');
}

function individualId(request) {
	return getSessionValue(request, 'individual');
}

function garageId(request) {
	return getSessionValue(request, 'garage');
}

module.exports = {
	userId,
	dealerId,
	individualId,
	garageId,
};
