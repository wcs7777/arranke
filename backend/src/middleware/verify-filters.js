const verifyValidation = require('./verify-validation');

function verifyFilters(validate) {
	return verifyValidation(
		validate,
		{
			verifyBody: false,
			verifyQuery: true,
			removeInvalids: true,
		},
	);
}

module.exports = verifyFilters;
