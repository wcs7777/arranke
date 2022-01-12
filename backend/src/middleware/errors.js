const statusCode = require('../helpers/status-code');
const logger = require('../helpers/logger');
const {
	AppCustomError,
	SqlFieldError,
	ForeignKeyError,
	DuplicateEntryError,
	InvalidBase64ImageError,
} = require('../helpers/errors');

function notFound(request, response) {
	return response
		.status(statusCode.notFound)
		.json({ message: 'Not found' });
}

function serverError(response, err) {
	logger.error(err, 'Server error');
	return response.json({ message: 'Server error' });
}

function foreignKey(response, err) {
	return response.json({
		message: 'The value provided for the field is not registered',
		field: err.field,
	});
}

function duplicateEntry(response, err) {
	return response.json({
		message: 'The value provided for the field is already registered',
		duplicate: err.duplicate,
	});
}

function invalidBase64Image(response) {
	return response.json({ message: 'Invalid image' });
}

function handleError(err, request, response, next) {
	response.status(err.status || statusCode.serverError);
	if (!(err instanceof AppCustomError)) {
		return serverError(response, err);
	}
	if (err instanceof SqlFieldError) {
		if (err instanceof ForeignKeyError) {
			return foreignKey(response, err);
		}
		if (err instanceof DuplicateEntryError) {
			return duplicateEntry(response, err);
		}
	} else if (err instanceof InvalidBase64ImageError) {
		return invalidBase64Image(response);
	}
	return serverError(response, err);
}

module.exports = {
	notFound,
	handleError,
};
