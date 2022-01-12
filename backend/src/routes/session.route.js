const { Router } = require('express');
const controller = require('../controllers/session.controller');
const verifyValidation = require('../middleware/verify-validation');
const { session: { login: validate } } = require('../helpers/validate');

const router = Router();

router.post(
	'/login',
	controller.verifyLoginAuthorization,
	verifyValidation(validate),
	controller.authenticate,
);

router.post(
	'/logout',
	controller.verifyAuthentication,
	controller.finishSession,
	controller.logout,
);

router.get('/authenticated', controller.authenticated);

module.exports = router;
