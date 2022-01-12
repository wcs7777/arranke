const { escape, escapeIdentifier } = require('../database/main.database');
const { toLine } = require('./utils');

function inConditions({ queryString, fields, prefix='' }={}) {
	return fields.reduce((conditions, field) => {
		const values = escape(queryString[field], true);
		return (
			(values)?
			[
				...conditions,
				`${prefix}${field} IN ${bracketsToParentheses(values)}`,
			] :
			conditions
		);
	}, []);
}

function equalConditions({
	queryString,
	fields,
	prefix='',
	quotes=false,
}={}) {
	return fields.reduce((conditions, field) => {
		const value = escape(queryString[field], !quotes);
		return (
			(value)?
			[
				...conditions,
				`${prefix}${field} = ${value}`,
			] :
			conditions
		);
	}, []);
}

function betweenConditions({
	queryString,
	fields,
	prefix='',
	quotes=false,
}={}) {
	return fields.reduce((conditions, field) => {
		const values = queryString[field];
		if (values) {
			const [min, max] = values
				.split('|')
				.map(value => escape(value, !quotes));
			return [
				...conditions,
				`${prefix}${field} BETWEEN ${min} AND ${max}`,
			];
		} else {
			return conditions;
		}
	}, []);
}

function likeConditions({ queryString, fields, prefix='' }={}) {
	return fields.reduce((conditions, field) => {
		const value = escape(queryString[field], true);
		return (
			(value)?
			[
				...conditions,
				`${prefix}${field} LIKE '%${value}%'`,
			] :
			conditions
		);
	}, []);
}

function orderByClause({ queryString, key, prefix='' }={}) {
	const value = queryString[key];
	if (value) {
		let field = value;
		let order = 'ASC';
		if (value.startsWith('-')) {
			field = field.slice(1);
			order = 'DESC';
		}
		const identifier = escapeIdentifier(`${prefix}${field}`);
		return `ORDER BY ${identifier} ${order}`;
	} else {
		return '';
	}
}

function whereClause(conditions) {
	return (conditions.length > 0)? `WHERE ${conditions.join(' AND ')}` : '';
}

function buildSqlQuery(select, where, orderBy) {
	return toLine([select, where, orderBy].join(' '));
}

function bracketsToParentheses(text) {
	return text
		.replace('[', '(')
		.replace(']', ')');
}

module.exports = {
	inConditions,
	equalConditions,
	betweenConditions,
	likeConditions,
	whereClause,
	orderByClause,
	buildSqlQuery,
};
