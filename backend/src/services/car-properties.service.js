const data = require('../data/car-properties.data');

function fetchCarProperties() {
	return data.fetchCarProperties();
}

module.exports = {
	fetchCarProperties,
};
