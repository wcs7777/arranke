const {
	select,
	procedureSelectOne,
} = require('../database/main.database');
const {
	inConditions,
	equalConditions,
	betweenConditions,
	likeConditions,
	whereClause,
	orderByClause,
	buildSqlQuery,
} = require('../helpers/build-sql-query');

const carsBasicQuery = `
	SELECT
		DISTINCT car_id AS id,
		make_name AS make,
		model_name AS model,
		car_price AS price,
		car_mileage AS mileage,
		picture_path AS picture, (
			CASE
				WHEN garage_id IS NOT NULL THEN 'Garagem'
				ELSE 'Individual'
			END
		) AS type, (
			CASE
				WHEN garage_id IS NOT NULL THEN garage_name
				ELSE individual_name
			END
		) AS name,
		address_state AS state,
		address_city AS city
	FROM
		cars_view
`;

function fetchCars(queryString) {
	return select(
		buildSqlQuery(
			carsBasicQuery,
			buildCarsWhere(queryString),
			buildCarsOrderBy(queryString),
		),
	);
}

async function fetchCar(id) {
	return procedureSelectOne('fetch_car(:id)', { id })
		.then(row => row.car);
}

function buildCarsWhere(queryString) {
	return whereClause([
		...equalConditions({
			queryString,
			fields: [
				'used',
			],
			prefix: 'car_',
		}),
		...equalConditions({
			queryString,
			fields: [
				'doors',
				'plate_end',
			],
			prefix: 'car_',
			quotes: true,
		}),
		...inConditions({
			queryString,
			prefix: 'car_',
			fields: [
				'make',
				'model',
				'color',
				'fuel',
				'steering',
				'transmission',
				'brake',
				'drivetrain',
				'feature',
			],
		}),
		...betweenConditions({
			queryString,
			fields: ['mileage', 'price'],
			prefix: 'car_',
		}),
		...equalConditions({
			queryString,
			fields: ['state'],
			prefix: 'address_',
			quotes: true,
		}),
		...likeConditions({
			queryString,
			fields: ['city'],
			prefix: 'address_',
		}),
	]);
}

function buildCarsOrderBy(queryString) {
	return orderByClause({
		queryString,
		key: 'ordering',
		prefix: 'car_',
	});
}

module.exports = {
	fetchCars,
	fetchCar,
};
