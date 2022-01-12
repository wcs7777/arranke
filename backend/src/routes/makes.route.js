const { Router } = require('express');
const controller = require('../controllers/makes.controller');
const regexParamId = require('../helpers/regex-param-id');

const router = Router();

router.get(
	`/makes/:id${regexParamId}/models`,
	controller.fetchMakeModels,
);

module.exports = router;
