const { Router } = require('express');
const controller = require('../controllers/advertisements.controller');
const { verifyAuthentication } = require('../controllers/session.controller');
const { verifyDealerAuthorization } = require(
	'../controllers/users.controller'
);
const verifyValidation = require('../middleware/verify-validation');
const { advertisement: validate } = require('../helpers/validate');
const regexParamId = require('../helpers/regex-param-id');

const router = Router();

router.use(
	[
		'/advertisements',
		`/advertisements/:id${regexParamId}`,
	],
	verifyAuthentication,
	verifyDealerAuthorization,
);

router.post(
	'/advertisements',
	verifyValidation(validate),
	controller.addAdvertisement,
);

router.get('/advertisements', controller.fetchAdvertisements);

router.route(`/advertisements/:id${regexParamId}`)
	.get(controller.fetchAdvertisement)
	.put(
		verifyValidation(validate),
		controller.updateAdvertisement,
	)
	.delete(controller.removeAdvertisement);

module.exports = router;
