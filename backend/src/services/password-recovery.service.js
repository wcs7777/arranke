const data = require('../data/password-recovery.data');
const { updatePassword: dataUpdatePassword } = require('../data/users.data');
const { randomDigits } = require('../helpers/random');
const { encrypt, encryptedIsEqual } = require('../helpers/crypt');
const renderEmailHtml = require('../helpers/render-email-html');
const config = require('../helpers/config');
const sendMail = require('../helpers/send-mail');
const affectedRowsResponse = require('../helpers/affected-rows-response');
const statusCode = require('../helpers/status-code');
const logger = require('../helpers/logger');

async function sendCode(email, send=true) {
	const code = randomDigits(8);
	const affectedRows = await data.addCode(
		email,
		await encrypt(code),
	);
	if (affectedRows > 0) {
		if (send || config.isProduction) {
			const html = await renderEmailHtml(
				'email/recovery-code',
				{
					code,
					link: `${config.url}?email=${email}&code=${code}`,
				},
			);
			await sendMail({
				to: email,
				subject: 'Arranke 🚗 - Recuperação de Senha',
				html,
			});
		} else {
			logger.info(`Send code test: Code ${code} to ${email}`);
		}
	}
	return affectedRowsResponse({
		affectedRows,
		success: 'sent',
		fail: 'The email address provided is not registered',
		failStatus: statusCode.invalidParameters,
	});
}

async function verifyCode({ email, code }) {
	return {
		valid: await validCode(code, await data.fetchUserCodeId(email)),
	};
}

async function updatePassword({ email, code, password }) {
	const row = await data.fetchUserCodeId(email);
	if (await validCode(code, row)) {
		return affectedRowsResponse({
			affectedRows: await dataUpdatePassword(row.id, await encrypt(password)),
			success: 'reset',
			attempt: 'reset password',
		});
	} else {
		return affectedRowsResponse({
			affectedRows: 0,
			fail: 'Invalid email or code',
			failStatus: statusCode.invalidParameters,
		});
	}
}

async function validCode(code, row) {
	return (row)? encryptedIsEqual(code, row.code) : false;
}

module.exports = {
	sendCode,
	verifyCode,
	updatePassword,
};
