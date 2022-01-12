const { Router } = require('express');
const controller = require('../controllers/cars.controller');
const regexParamId = require('../helpers/regex-param-id');
const { filters: { cars: validate } } = require('../helpers/validate');
const verifyFilters = require('../middleware/verify-filters');

const router = Router();

router.get(
	'/cars',
	verifyFilters(validate),
	controller.fetchCars,
);

router.get(`/cars/:id${regexParamId}`, controller.fetchCar);

module.exports = router;
