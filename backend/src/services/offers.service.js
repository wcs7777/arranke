const data = require('../data/offers.data');

function fetchOffers(dealer) {
	return data.fetchOffers(dealer);
}

function fetchOffer({ dealer, offer }) {
	return data.fetchOffer({ dealer, offer });
}

function fetchAdvertisementOffers({ dealer, car }) {
	return data.fetchAdvertisementOffers({ dealer, car });
}

function addOffer({ car, offerer, message }) {
	return data.addOffer({ car, offerer, message });
}

module.exports = {
	fetchOffers,
	fetchOffer,
	fetchAdvertisementOffers,
	addOffer,
};
