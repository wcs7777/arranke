const statusCode = require('./status-code');

class AppCustomError extends Error {
	constructor(message) {
		super(message);
		this.name = 'AppCustomError';
	}
}

class SqlFieldError extends AppCustomError {
	constructor(message) {
		super(message);
		this.name = 'SqlFieldError';
		this.status = statusCode.invalidParameters;
	}
}

class ForeignKeyError extends SqlFieldError {
	constructor(message, field) {
		super(message);
		this.name = 'ForeignKeyError';
		this.field = field;
	}
}

class DuplicateEntryError extends SqlFieldError {
	constructor(message, duplicate) {
		super(message);
		this.name = 'DuplicateEntryError';
		this.duplicate = duplicate;
	}
}

class InvalidBase64ImageError extends AppCustomError {
	constructor(message='Invalid base64 image') {
		super(message);
		this.name = 'InvalidBase64ImageError';
		this.status = statusCode.invalidParameters;
	}
}

module.exports = {
	AppCustomError,
	SqlFieldError,
	ForeignKeyError,
	DuplicateEntryError,
	InvalidBase64ImageError,
};
