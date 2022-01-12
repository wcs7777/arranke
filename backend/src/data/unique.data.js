const { selectUnique } = require('../database/main.database');

async function fetchId({ table, field, value }) {
	return selectUnique({ table, field, value })
		.then(row => (row)? row.id : row);
}

module.exports = {
	fetchId,
};
