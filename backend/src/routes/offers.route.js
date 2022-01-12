const { Router } = require('express');
const controller = require('../controllers/offers.controller');
const { verifyAuthentication } = require('../controllers/session.controller');
const { verifyDealerAuthorization } = require(
	'../controllers/users.controller'
);
const regexParamId = require('../helpers/regex-param-id');
const verifyValidation = require('../middleware/verify-validation');
const { offer: validate } = require('../helpers/validate');

const router = Router();

router.use(
	[
		'/offers',
		`/offers/:id${regexParamId}`,
		`/advertisements/:id${regexParamId}/offers`,
	],
	verifyAuthentication,
	verifyDealerAuthorization,
);

router.get('/offers', controller.fetchOffers);
router.get(`/offers/:id${regexParamId}`, controller.fetchOffer);

router.get(
	`/advertisements/:id${regexParamId}/offers`,
	controller.fetchAdvertisementOffers,
);

router.post(
	`/cars/:id${regexParamId}/offers`,
	verifyAuthentication,
	verifyValidation(validate),
	controller.makeOffer,
);

module.exports = router;
