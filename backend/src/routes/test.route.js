const { Router } = require('express');
const controller = require('../controllers/test.controller');
const { filters: { cars: validate } } = require('../helpers/validate');
const verifyValidation = require('../middleware/verify-validation');

const router = Router();

router.get('/caught', controller.caughtError);
router.get('/uncaught', controller.uncaughtError);
router.get(
	'/filters',
	controller.filters,
	verifyValidation(
		validate, {
			verifyBody: false,
			verifyQuery: true,
			removeInvalids: true,
		},
	),
	controller.filtered,
);

module.exports = router;
