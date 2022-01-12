const { Router } = require('express');
const controller = require('../controllers/garages.controller');
const regexParamId = require('../helpers/regex-param-id');
const { filters: { garages: validate } } = require('../helpers/validate');
const verifyFilters = require('../middleware/verify-filters');

const router = Router();

router.get(
	'/garages',
	verifyFilters(validate),
	controller.fetchGarages,
);

router.get(`/garages/:id${regexParamId}`, controller.fetchGarage);

module.exports = router;
