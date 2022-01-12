const { serverError } = require('./status-code');

function affectedRowsResponse({
	affectedRows,
	success,
	fail=undefined,
	attempt=undefined,
	failStatus=serverError,
}={}) {
	if (affectedRows > 0) {
		return {
			success: true,
			message: success,
		};
	} else {
		return {
			success: false,
			message: (fail !== undefined)? fail : `Error trying to ${attempt}`,
			status: failStatus,
		};
	}
}

module.exports = affectedRowsResponse;
