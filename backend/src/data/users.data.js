const { move, remove } = require('fs-extra');
const {
	procedureSelectOne,
	procedureManipulation,
	transaction,
} = require('../database/main.database');
const { toLine } = require('../helpers/utils');
const saveBase64Images = require('../helpers/save-base64-images');
const {
	fullPath,
	dealerPictures,
	garagePictures,
} = require('../helpers/locations');
const filesToPaths = require('../helpers/files-to-paths');

function addUser(user) {
	return procedureManipulation(
		toLine(`
			add_user(
				:name,
				:email,
				:password,
				:phone,
				:retrieve
			)
		`),
		user,
	);
}

function fetchUser(id) {
	return procedureSelectOne('fetch_user(:id)', { id });
}

function updateUser(user) {
	return procedureManipulation(
		toLine(`
			update_user(
				:id,
				:name,
				:email,
				:phone,
				:retrieve
			)
		`),
		user,
	);
}

function removeUser(id) {
	return procedureManipulation(
		'remove_user(:id)', { id }, { retrieve: false }
	);
}

async function userPassword(id) {
	return procedureSelectOne('fetch_user_password_by_id(:id)', { id })
		.then(row => (row)? row.password : row);
}

function updatePassword(id, password) {
	return procedureManipulation(
		'update_password(:id, :password)', { id, password }, { retrieve: false }
	);
}

async function addIndividual(individual) {
	return procedureManipulation(
		toLine(`
			add_individual(
				:name,
				:email,
				:password,
				:phone,
				:cpf,
				:cep,
				:state,
				:city,
				:area,
				:street,
				:number,
				:retrieve
			)
		`),
		individual,
	)
		.then(row => row.individual);
}

async function upgradeToIndividual(individual) {
	return procedureManipulation(
		toLine(`
			add_individual_by_user(
				:user,
				:cpf,
				:cep,
				:state,
				:city,
				:area,
				:street,
				:number,
				:retrieve
			)
		`),
		individual,
	)
		.then(row => row.individual);
}

async function fetchIndividual(id) {
	return procedureSelectOne('fetch_individual(:id)', { id })
		.then(row => row.individual);
}

async function updateIndividual(individual) {
	return procedureManipulation(
		toLine(`
			update_individual(
				:id,
				:name,
				:email,
				:phone,
				:cpf,
				:cep,
				:state,
				:city,
				:area,
				:street,
				:number,
				:retrieve
			)
		`),
		individual,
	)
		.then(row => row.individual);
}

function removeIndividual({ id, dealer }) {
	return transaction(connection => (
		taskDeleteDealer(
			'remove_individual(:id)', { id, dealer }, connection,
		)
	));
}

function addGarage(garage) {
	return transaction(
		transactionSaveGarage(
			toLine(`
				add_garage(
					:name,
					:cnpj,
					:picture_path,
					:responsible_name,
					:responsible_email,
					:responsible_password,
					:responsible_phone,
					:cep,
					:state,
					:city,
					:area,
					:street,
					:number,
					:retrieve
				)
			`),
			garage,
		),
	);
}

function upgradeToGarage(garage) {
	return transaction(
		transactionSaveGarage(
			toLine(`
				add_garage_by_user(
					:user,
					:name,
					:cnpj,
					:picture_path,
					:cep,
					:state,
					:city,
					:area,
					:street,
					:number,
					:retrieve
				)
			`),
			garage,
		),
	);
}

async function fetchGarage(id) {
	return procedureSelectOne('fetch_garage(:id)', { id })
		.then(row => row.garage);
}

function updateGarage(garage) {
	return transaction(
		transactionSaveGarage(
			toLine(`
				update_garage(
					:id,
					:name,
					:cnpj,
					:picture_path,
					:responsible_name,
					:responsible_email,
					:responsible_phone,
					:cep,
					:state,
					:city,
					:area,
					:street,
					:number,
					:retrieve
				)
			`),
			garage,
		),
	);
}

function removeGarage({ id, dealer }) {
	return transaction(
		async (connection) => {
			await remove(fullPath(garagePictures(id)));
			return taskDeleteDealer(
				'remove_garage(:id)', { id, dealer }, connection
			);
		},
	);
}

async function taskDeleteDealer(procedure, { id, dealer }, connection) {
	await removeDealerPictures(dealer);
	return procedureManipulation(
		procedure,
		{ id },
		{ useTransaction: false, retrieve: false },
		connection,
	);
}

function transactionSaveGarage(procedure, values) {
	return async (connection) => {
		const { temporaryDir, files } = await saveBase64Images([values.picture]);
		try {
			const garage = await procedureManipulation(
				procedure,
				{
					...values,
					picture_path: filesToPaths(temporaryDir, files).pop(),
				},
				{ useTransaction: false },
				connection,
			)
				.then(row => row.garage);
			const picture = await moveToGaragePictures(
				temporaryDir,
				files,
				garage.id,
				connection,
			);
			return { ...garage, picture };
		} catch (err) {
			await remove(temporaryDir);
			throw err;
		}
	};
}

function removeDealerPictures(dealerId) {
	return remove(fullPath(dealerPictures(dealerId)));
}

async function moveToGaragePictures(
	temporaryDir,
	files,
	garageId,
	connection,
) {
	const dir = garagePictures(garageId);
	await move(
		temporaryDir,
		fullPath(dir),
		{ overwrite: true },
	);
	return updateGaragePicture(
		{
			id: garageId,
			picture_path: filesToPaths(dir, files).pop(),
		},
		connection,
	)
		.then(row => (row)? row.picture : row);
}

function updateGaragePicture(values, connection) {
	return procedureManipulation(
		'update_garage_picture(:id, :picture_path, :retrieve)',
		values,
		{ useTransaction: false },
		connection,
	);
}

module.exports = {
	addUser,
	fetchUser,
	updateUser,
	removeUser,
	userPassword,
	updatePassword,
	addIndividual,
	upgradeToIndividual,
	fetchIndividual,
	updateIndividual,
	removeIndividual,
	addGarage,
	upgradeToGarage,
	fetchGarage,
	updateGarage,
	removeGarage,
};
