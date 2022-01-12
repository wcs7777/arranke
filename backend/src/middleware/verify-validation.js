const { deleteKey } = require('../helpers/utils');
const { invalidParameters } = require('../helpers/status-code');

function verifyValidation(
	validate,
	{
		verifyBody=true,
		verifyQuery=false,
		removeInvalids=false,
	}={},
) {
	return (request, response, next) => {
		const passed = (
			(
				verifyBody &&
				passedValidation(validate, request.body, removeInvalids)
			) ||
			(
				verifyQuery &&
				passedValidation(validate, request.query, removeInvalids)
			)
		);
		if (passed) {
			return next();
		} else {
			return response
				.status(invalidParameters)
				.json(validate.errors);
		}
	};
}

function passedValidation(validate, data, removeInvalids=false) {
	let valid = validate(data);
	if (!valid && removeInvalids) {
		const paths = [...new Set(validate.errors.map(e => e.instancePath))];
		for (const path of paths) {
			deleteKey(data, path, '/');
		}
		valid = true;
	}
	return valid;
}

module.exports = verifyValidation;
