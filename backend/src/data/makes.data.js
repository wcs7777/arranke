const {
	procedureSelect,
} = require('../database/main.database');

function fetchModels(make) {
	return procedureSelect('fetch_models(:make)', { make });
}

module.exports = {
	fetchModels,
};
