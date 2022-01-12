const data = require('../data/cars.data');

async function fetchCars(queryString) {
	return data
		.fetchCars(queryString)
		.then(rows => rows.map(mapRows));
}

function fetchCar(id) {
	return data
		.fetchCar(id)
		.then(row => {
			row.car.used = (row.car.used === 1);
			return row;
		});
}

function mapRows(row) {
	return {
		car: {
			id: row.id,
			make: row.make,
			model: row.model,
			price: row.price,
			mileage: row.mileage,
			picture: row.picture,
		},
		dealer: {
			type: row.type,
			name: row.name,
		},
		location: {
			state: row.state,
			city: row.city,
		},
	};
}

module.exports = {
	fetchCars,
	fetchCar,
};
