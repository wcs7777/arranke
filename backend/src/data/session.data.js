const { procedureSelectOne } = require('../database/main.database');

async function userPassword(email) {
	return procedureSelectOne('fetch_user_password_by_email(:email)', { email })
		.then(row => (row)? row.password : row);
}

function fetchUserForLogin(email) {
	return procedureSelectOne('fetch_user_for_login(:email)', { email });
}

module.exports = {
	userPassword,
	fetchUserForLogin,
};
