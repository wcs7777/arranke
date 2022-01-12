const {
	procedureManipulation,
	procedureSelectOne,
} = require('../database/main.database');

function addCode(email, code) {
	return procedureManipulation(
		'add_code(:email, :code)',
		{ email, code },
		{ retrieve: false },
	);
}

function fetchUserCodeId(email) {
	return procedureSelectOne('fetch_user_code_id(:email)', { email });
}

module.exports = {
	addCode,
	fetchUserCodeId,
};
