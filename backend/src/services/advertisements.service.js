const data = require('../data/advertisements.data');
const affectedRowsResponse = require('../helpers/affected-rows-response');

function addAdvertisement(advertisement) {
	return data.addAdvertisement(advertisement);
}

function fetchAdvertisements(dealer) {
	return data.fetchAdvertisements(dealer);
}

function fetchAdvertisement(dealer, car) {
	return data.fetchAdvertisement(dealer, car);
}

async function updateAdvertisement(advertisement) {
	const belongs = await data.advertisementBelongsDealer({
		dealerId: advertisement.dealer,
		carId: advertisement.id,
	});
	return (belongs)? data.updateAdvertisement(advertisement) : null;
}

async function removeAdvertisement({ carId, dealerId }) {
	const belongs = await data.advertisementBelongsDealer({
		dealerId,
		carId,
	});
	if (belongs) {
		return affectedRowsResponse({
			affectedRows: await data.removeAdvertisement({ carId, dealerId }),
			success: 'removed',
			attempt: 'remove advertisement',
		});
	} else {
		return null;
	}
}

module.exports = {
	addAdvertisement,
	updateAdvertisement,
	fetchAdvertisements,
	fetchAdvertisement,
	removeAdvertisement,
};
