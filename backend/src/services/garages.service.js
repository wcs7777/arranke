const data = require('../data/garages.data');

async function fetchGarages(queryString) {
	return data
		.fetchGarages(queryString)
		.then(rows => rows.map(mapRows));
}

function fetchGarage(garage) {
	return data.fetchGarageForVisitor(garage);
}

function mapRows(row) {
	return {
		id: row.id,
		name: row.name,
		cars: row.cars,
		picture: row.picture,
		location: {
			state: row.state,
			city: row.city,
		},
	};
}

module.exports = {
	fetchGarages,
	fetchGarage,
};
