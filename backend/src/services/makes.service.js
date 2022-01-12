const data = require('../data/makes.data');

function fetchMakeModels(make) {
	return data.fetchModels(make);
}

module.exports = {
	fetchMakeModels,
};
