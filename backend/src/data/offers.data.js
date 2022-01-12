const {
	procedureSelectOne,
	procedureManipulation,
} = require('../database/main.database');

async function fetchOffers(dealer) {
	return procedureSelectOne('fetch_offers(:dealer)', { dealer })
		.then(({ offers }) => (offers)? offers : []);
}

async function fetchOffer({ dealer, offer }) {
	return procedureSelectOne(
		'fetch_offer(:dealer, :offer)', { dealer, offer }
	)
		.then(row => row.offer_json);
}

async function fetchAdvertisementOffers({ dealer, car }) {
	return procedureSelectOne(
		'fetch_advertisement_offers(:dealer, :car)', { dealer, car }
	)
		.then(({ offers }) => (offers)? offers : []);
}

async function addOffer({ car, offerer, message }) {
	return procedureManipulation(
		'add_offer(:car, :offerer, :message, :retrieve)',
		{ car, offerer, message },
	)
		.then(row => row.offer_json);
}

module.exports = {
	fetchOffers,
	fetchOffer,
	fetchAdvertisementOffers,
	addOffer,
};
