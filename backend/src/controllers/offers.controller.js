const service = require('../services/offers.service');
const { sendResult } = require('../helpers/async-controller');
const { dealerId, userId } = require('../helpers/get-session-value');

function fetchOffer(request, response, next) {
	return sendResult(
		service.fetchOffer({
			dealer: dealerId(request),
			offer: request.params.id,
		}),
		response,
		next,
	);
}

function fetchOffers(request, response, next) {
	return sendResult(
		service.fetchOffers(dealerId(request)),
		response,
		next,
	);
}

function fetchAdvertisementOffers(request, response, next) {
	return sendResult(
		service.fetchAdvertisementOffers({
			dealer: dealerId(request),
			car: request.params.id,
		}),
		response,
		next,
	);
}

function makeOffer(request, response, next) {
	return sendResult(
		service.addOffer({
			car: request.params.id,
			offerer: userId(request),
			message: request.body.message,
		}),
		response,
		next,
	);
}

module.exports = {
	fetchOffer,
	fetchOffers,
	fetchAdvertisementOffers,
	makeOffer,
};
