const {
	procedureSelectOne,
	procedureManipulation,
} = require('../database/main.database');
const { asyncMap } = require('../helpers/utils');

async function fetchCarProperties() {
	return procedureSelectOne('fetch_car_properties()')
		.then(row => (row)? row.car_properties : row);
}

async function addCarPropertiesWithoutId(carProperties, connection) {
	const simpleCarProperties = await addSimpleCarPropertiesWithoutId(
		carProperties,
		connection,
	);
	return {
		...simpleCarProperties,
		model: await addModelWithoutId(
			carProperties.model,
			simpleCarProperties.make,
			connection,
		),
		features: await addFeaturesWithoutId(
			carProperties.features,
			connection,
		),
	};
}

async function removeUnreferencedCarProperties() {
	return procedureManipulation(
		'remove_unreferenced_car_properties(:retrieve)'
	)
		.then(row => row.affected_rows);
}

async function addSimpleCarPropertiesWithoutId(
	simpleCarProperties,
	connection,
) {
	const keys = [
		'make',
		'color',
		'fuel',
		'steering',
		'transmission',
		'brake',
		'drivetrain',
	];
	const carProperties = {};
	for (const key of keys) {
		carProperties[key] = (
			simpleCarProperties[key].id ||
			await addCarProperty(
				`add_${key}(:name, :retrieve)`,
				{ name: simpleCarProperties[key].name },
				connection,
			)
		);
	}
	return carProperties;
}

function addModelWithoutId(model, makeId, connection) {
	return (
		model.id ||
		addCarProperty(
			`add_model(:name, :make, :retrieve)`,
			{ name: model.name, make: makeId },
			connection,
		)
	);
}

function addFeaturesWithoutId(features, connection) {
	return asyncMap(features, async (feature) => (
		feature.id ||
		addCarProperty(
			'add_feature(:name, :retrieve)',
			{ name: feature.name },
			connection,
		)
	));
}

async function addCarProperty(procedure, values, connection) {
	return procedureManipulation(
		procedure,
		values,
		{ useTransaction: false },
		connection,
	)
	 .then(row => (row)? row.id : row);
}

module.exports = {
	fetchCarProperties,
	addCarPropertiesWithoutId,
	removeUnreferencedCarProperties,
};
