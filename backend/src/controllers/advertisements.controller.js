const service = require('../services/advertisements.service');
const { sendResult, sendFeedback } = require('../helpers/async-controller');
const { dealerId } = require('../helpers/get-session-value');

function addAdvertisement(request, response, next) {
	return sendResult(
		service.addAdvertisement({
			...extractAdvertisement(request.body),
			dealer: dealerId(request),
		}),
		response,
		next,
	);
}

function updateAdvertisement(request, response, next) {
	return sendResult(
		service.updateAdvertisement({
			...extractAdvertisement(request.body),
			dealer: dealerId(request),
			id: request.params.id,
		}),
		response,
		next,
	);
}

function removeAdvertisement(request, response, next) {
	return sendFeedback(
		service.removeAdvertisement({
			carId: request.params.id,
			dealerId: dealerId(request),
		}),
		response,
		next,
	);
}

function fetchAdvertisement(request, response, next) {
	return sendResult(
		service.fetchAdvertisement(
			dealerId(request),
			request.params.id,
		),
		response,
		next,
	);
}

function fetchAdvertisements(request, response, next) {
	return sendResult(
		service.fetchAdvertisements(dealerId(request)),
		response,
		next,
	);
}

function extractAdvertisement(body) {
	return {
		plate: body.plate,
		year: body.year,
		price: body.price,
		mileage: body.mileage,
		used: body.used,
		observations: body.observations,
		pictures: body.pictures,
		doors: body.specifications.doors,
		carProperties: {
			make: body.make,
			model: body.model,
			color: body.specifications.color,
			fuel: body.specifications.fuel,
			steering: body.specifications.steering,
			transmission: body.specifications.transmission,
			brake: body.specifications.brake,
			drivetrain: body.specifications.drivetrain,
			features: body.specifications.features,
		},
	};
}

module.exports = {
	addAdvertisement,
	updateAdvertisement,
	removeAdvertisement,
	fetchAdvertisement,
	fetchAdvertisements,
};
