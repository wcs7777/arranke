const { Router } = require('express');
const controller = require('../controllers/password-recovery.controller');
const { verifyLoginAuthorization } = require(
	'../controllers/session.controller'
);
const verifyValidation = require('../middleware/verify-validation');
const { passwordRecovery: validate } = require('../helpers/validate');

const router = Router();

router.use(verifyLoginAuthorization);

router.route('/code')
	.post(
		verifyValidation(validate.codeGeneration),
		controller.generateCode,
	)
	.put(
		verifyValidation(validate.codeVerification),
		controller.verifyCode,
	);

router.put(
	'/new-password',
	verifyValidation(validate.newPassword),
	controller.newPassword,
);

module.exports = router;
