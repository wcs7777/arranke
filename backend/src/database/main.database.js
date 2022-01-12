const mysql = require('mysql2');
const config = require('../helpers/config');
const { toLine } = require('../helpers/utils');
const {
	ForeignKeyError,
	DuplicateEntryError,
} = require('../helpers/errors');

const pool = mysql.createPool(config.mysql);
const poolDotPromise = pool.promise();

async function select(sql, values, connection=undefined) {
	return execute(sql, values, connection)
		.then(([rows]) => rows);
}

async function selectOne(sql, values, connection=undefined) {
	return select(sql, values, connection)
		.then(([row]) => row);
}

async function selectUnique({
	table,
	field,
	value,
	returnField='id',
	connection=undefined,
}={}) {
	return selectOne(
		toLine(`
			SELECT
				${returnField}
			FROM
				${table}
			WHERE
				${field} = :value
			LIMIT 1
		`),
		{ value },
		connection,
	);
}

async function exists({
	table,
	condition,
	values,
	returnField='id',
	connection=undefined,
}={}) {
	return await selectOne(
		toLine(`
			SELECT
				${returnField}
			FROM
				${table}
			WHERE
				${condition}
			LIMIT 1
		`),
		values,
		connection,
	) !== undefined;
}

async function procedureSelect(procedure, values, connection=undefined) {
	return execute(`CALL ${procedure}`, values, connection)
		.then(([[rows]]) => rows);
}

async function procedureSelectOne(procedure, values, connection=undefined) {
	return procedureSelect(procedure, values, connection)
		.then(([row]) => row);
}

async function procedureManipulation(
	procedure,
	values,
	{
		retrieve=true,
		useTransaction=true,
		discardChanges=false,
	}={},
	connection=undefined,
) {
	const gotConnection = (!connection);
	if (gotConnection) {
		connection = await getConnection();
	}
	try {
		useTransaction = useTransaction || discardChanges;
		if (useTransaction) {
			await beginTransaction(connection);
		}
		const result = await execute(
			`CALL ${procedure}`,
			{ ...values, retrieve },
			connection,
		)
			.then(res => {
				if (retrieve) {
					const [[[row]]] = res;
					return row;
				} else {
					const [{ affectedRows }] = res;
					return affectedRows;
				}
			});
		if (useTransaction) {
			if (!discardChanges) {
				await commit(connection);
			} else {
				await rollback(connection);
			}
		}
		return result;
	} catch (err) {
		if (useTransaction) {
			await rollback(connection);
		}
		throw err;
	} finally {
		if (gotConnection) {
			connection.release();
		}
	}
}

async function transaction(asyncTask, connection=undefined) {
	const gotConnection = (!connection);
	if (gotConnection) {
		connection = await getConnection();
	}
	try {
		await beginTransaction(connection);
		const result = await asyncTask(connection);
		await commit(connection);
		return result;
	} catch (err) {
		await rollback(connection);
		throw err;
	} finally {
		if (gotConnection) {
			connection.release();
		}
	}
}

async function beginTransaction(connection) {
	await connection.query('SET autocommit = OFF');
	return connection.query('START TRANSACTION');
}

async function commit(connection) {
	await connection.query('COMMIT');
	return connection.query('SET autocommit = ON');
}

async function rollback(connection) {
	await connection.query('ROLLBACK');
	return connection.query('SET autocommit = ON');
}

async function execute(sql, values={}, connection=undefined) {
	const gotConnection = (!connection);
	if (gotConnection) {
		connection = await getConnection();
	}
	try {
		return await connection.execute(sql, values);
	} catch (err) {
		if (err.errno && err.sqlMessage) {
			if (err.errno === 1452) {
				const match = err.sqlMessage.match(/FOREIGN KEY \(`(.+?)`/);
				throw new ForeignKeyError(err.message, match[1]);
			} else if (err.errno === 1062) {
				const match = err.sqlMessage.match(
					/Duplicate entry '(.+?)' for key '(.+?)\.(.+?)'/
				);
				throw new DuplicateEntryError(
					err.message,
					{
						table: match[2],
						field: match[3],
						value: match[1],
					},
				);
			}
		}
		throw err;
	} finally {
		if (gotConnection) {
			connection.release();
		}
	}
}

async function getConnection() {
	const connection = await poolDotPromise.getConnection();
	connection.config.namedPlaceholders = true;
	return connection;
}

async function end() {
	return poolDotPromise.end();
}

function escape(value, removeQuotes=false) {
	if (value) {
		const escaped = pool.escape(value);
		return (removeQuotes)? escaped.slice(1, -1) : escaped;
	} else {
		return value;
	}
}

function escapeIdentifier(value) {
	return (value)? pool.escapeId(value) : value;
}

module.exports = {
	select,
	selectOne,
	selectUnique,
	exists,
	procedureSelect,
	procedureSelectOne,
	procedureManipulation,
	transaction,
	beginTransaction,
	commit,
	rollback,
	execute,
	getConnection,
	end,
	escape,
	escapeIdentifier,
};
