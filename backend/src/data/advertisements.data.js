const { move, remove } = require('fs-extra');
const {
	procedureSelect,
	procedureSelectOne,
	procedureManipulation,
	transaction,
	exists,
} = require('../database/main.database');
const {
	addCarPropertiesWithoutId,
} = require('./car-properties.data');
const { fullPath, carPictures } = require('../helpers/locations');
const filesToPaths = require('../helpers/files-to-paths');
const saveBase64Images = require('../helpers/save-base64-images');
const { toLine } = require('../helpers/utils');
const {
	AppCustomError,
	ForeignKeyError,
} = require('../helpers/errors');
const logger = require('../helpers/logger');

function fetchAdvertisements(dealer) {
	return procedureSelect('fetch_advertisements(:dealer)', { dealer });
}

async function fetchAdvertisement(dealer, car) {
	return procedureSelectOne(
		'fetch_advertisement(:dealer, :car)', { dealer, car }
	)
		.then(row => (row)? row.advertisement : row);
}

function addAdvertisement(advertisement) {
	return transaction(
		transactionTasksSaveAdvertisement(
			toLine(`
				add_advertisement(
					:model,
					:plate,
					:year,
					:price,
					:mileage,
					:used,
					:observations,
					:pictures,
					:doors,
					:color,
					:fuel,
					:steering,
					:transmission,
					:brake,
					:drivetrain,
					:features,
					:dealer,
					:retrieve
				)
			`),
			advertisement,
		),
	);
}

function updateAdvertisement(advertisement) {
	return transaction(
		transactionTasksSaveAdvertisement(
			toLine(`
				update_advertisement(
					:id,
					:model,
					:plate,
					:year,
					:price,
					:mileage,
					:used,
					:observations,
					:pictures,
					:doors,
					:color,
					:fuel,
					:steering,
					:transmission,
					:brake,
					:drivetrain,
					:features,
					:dealer,
					:retrieve
				)
			`),
			advertisement,
		),
	);
}

function removeAdvertisement({ carId, dealerId }) {
	return transaction(
		async (connection) => {
			await remove(fullPath(carPictures(dealerId, carId)));
			return procedureManipulation(
				'remove_advertisement(:car)',
				{ car: carId },
				{ useTransaction: false, retrieve: false },
				connection,
			);
		},
	);
}

function advertisementBelongsDealer({ carId, dealerId }) {
	return exists({
		table: 'car',
		condition: 'dealer = :dealer AND id = :id',
		values: { dealer: dealerId, id: carId },
	});
}

function transactionTasksSaveAdvertisement(procedure, values) {
	return async (connection) => {
		const { temporaryDir, files } = await saveBase64Images(
			values.pictures.map(p => p.encoding),
		);
		const paths = filesToPaths(temporaryDir, files);
		const pictures = values.pictures.map((p, i) => ({
			sequence: p.sequence,
			path: paths[i],
		}));
		let carProperties = values.carProperties;
		const totalAttempts = 2;
		for (let attempt = 1; attempt <= totalAttempts; attempt++) {
			try {
				const carPropertiesIds = await addCarPropertiesWithoutId(
					carProperties,
				);
				const advertisement = await procedureManipulation(
					procedure,
					{
						...values,
						...carPropertiesIds,
						pictures,
					},
					{ useTransaction: false },
					connection,
				)
					.then(row => (row)? row.advertisement : row);
				const movedPictures = await moveToCarPictures({
					temporaryDir,
					files,
					dealerId: values.dealer,
					carId: advertisement.id,
					pictures: advertisement.pictures,
					connection,
				});
				return { ...advertisement, pictures: movedPictures };
			} catch (err) {
				if (tryAgain(attempt, totalAttempts, err)) {
					carProperties = removeCarPropertiesIds(carProperties);
					logger.info(`Attempt ${attempt + 1} to save the advertisement`);
				} else {
					await remove(temporaryDir);
					throw err;
				}
			}
		}
	};
}

async function moveToCarPictures({
	temporaryDir,
	files,
	dealerId,
	carId,
	pictures,
	connection,
}) {
	const dir = carPictures(dealerId, carId);
	const paths = filesToPaths(dir, files);
	await move(temporaryDir, fullPath(dir), { overwrite: true });
	return updateAdvertisementPictures(
		carId,
		pictures.map((picture, i) => {
			return { sequence: picture.sequence, path: paths[i] };
		}),
		connection,
	);
}

function removeCarPropertiesIds(carProperties) {
	const keys = [
		'make',
		'color',
		'fuel',
		'steering',
		'transmission',
		'brake',
		'drivetrain',
		'model',
	];
	const carPropertiesCopy = { ...carProperties };
	for (const key of keys) {
		carPropertiesCopy[key] = { ...carProperties[key] };
		delete carPropertiesCopy[key].id;
	}
	carPropertiesCopy.features = carProperties.features.map(feature => {
		const featureCopy = { ...feature };
		delete featureCopy.id;
		return featureCopy;
	});
	return carPropertiesCopy;
}

function tryAgain(attempt, totalAttempts, err) {
	return (
		attempt < totalAttempts &&
		err instanceof AppCustomError &&
		err instanceof ForeignKeyError
	);
}

async function updateAdvertisementPictures(car, pictures, connection) {
	return procedureManipulation(
		'update_advertisement_pictures(:car, :pictures, :retrieve)',
		{ car, pictures },
		{ useTransaction: false },
		connection,
	)
		.then(row => row.pictures);
}

module.exports = {
	fetchAdvertisements,
	fetchAdvertisement,
	addAdvertisement,
	updateAdvertisement,
	removeAdvertisement,
	advertisementBelongsDealer,
};
