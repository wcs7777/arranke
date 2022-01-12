const data = require('../data/unique.data');

async function isUnique({ table, field, value, id }) {
	const found = await data.fetchId({ table, field, value });
	return {
		unique: (found === undefined)? true : found === id,
	};
}

module.exports = {
	isUnique,
};
