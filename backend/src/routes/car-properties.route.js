const { Router } = require('express');
const controller = require('../controllers/car-properties.controller');

const router = Router();

router.get('/car-properties', controller.fetchCarProperties);

module.exports = router;
