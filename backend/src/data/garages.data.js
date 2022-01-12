const {
	select,
	procedureSelectOne,
} = require('../database/main.database');
const {
	equalConditions,
	likeConditions,
	whereClause,
	orderByClause,
	buildSqlQuery,
} = require('../helpers/build-sql-query');

const garagesBasicQuery = `
	SELECT
		id AS id,
		name AS name,
		cars AS cars,
		picture AS picture,
		state AS state,
		city AS city
	FROM
		garages_view
`;

function fetchGarages(queryString) {
	return select(
		buildSqlQuery(
			garagesBasicQuery,
			buildGaragesWhere(queryString),
			buildGaragesOrderBy(queryString),
		),
	);
}

async function fetchGarageForVisitor(garage) {
	return procedureSelectOne(
		'fetch_garage_for_visitor(:garage)',
		{ garage },
	)
		.then(row => row.garage);
}

function buildGaragesWhere(queryString) {
	return whereClause([
		...equalConditions({
			queryString,
			fields: ['state'],
			quotes: true,
		}),
		...likeConditions({
			queryString,
			fields: ['city', 'name'],
		}),
	]);
}

function buildGaragesOrderBy(queryString) {
	return orderByClause({
		queryString,
		key: 'ordering',
	});
}

module.exports = {
	fetchGarages,
	fetchGarageForVisitor,
};
