const { Router } = require('express');
const controller = require('../controllers/unique.controller');
const verifyValidation = require('../middleware/verify-validation');
const { unique: validate } = require('../helpers/validate');

const router = Router();

router.put(
	'/unique',
	verifyValidation(validate),
	controller.verifyUnique,
);

module.exports = router;
