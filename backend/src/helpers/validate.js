const Ajv2020 = require('ajv/dist/2020');
const logger = require('./logger');
const config = require('../helpers/config');
const idProperty = require(
	'../json-schemas/properties/id.schema.json'
);
const nameProperty = require(
	'../json-schemas/properties/name.schema.json'
);
const nameWithNumberProperty = require(
	'../json-schemas/properties/name-with-number.schema.json'
);
const addressProperties = require(
	'../json-schemas/properties/address.schema.json'
);
const carPropertiesProperties = require(
	'../json-schemas/properties/car-properties.schema.json'
);
const pictureProperties = require(
	'../json-schemas/properties/picture.schema.json'
);
const userProperties = require(
	'../json-schemas/properties/users.schema.json'
);
const individualProperties = require(
	'../json-schemas/properties/individuals.schema.json'
);
const garageProperties = require(
	'../json-schemas/properties/garages.schema.json'
);
const codeProperty = require(
	'../json-schemas/properties/code.schema.json'
);
const codeGenerationProperties = require(
	'../json-schemas/properties/code-generation.schema.json'
);
const codeVerificationProperties = require(
	'../json-schemas/properties/code-verification.schema.json'
);
const passwordRecoveryProperties = require(
	'../json-schemas/properties/password-recovery.schema.json'
);
const offerProperties = require(
	'../json-schemas/properties/offers.schema.json'
);
const advertisementProperties = require(
	'../json-schemas/properties/advertisements.schema.json'
);
const filtersProperties = require(
	'../json-schemas/properties/filters.schema.json'
);
const carFiltersProperties = require(
	'../json-schemas/properties/cars-filters.schema.json'
);
const garageFiltersProperties = require(
	'../json-schemas/properties/garages-filters.schema.json'
);
const unique = require(
	'../json-schemas/resources/unique/unique.schema.json'
);
const userAdd = require(
	'../json-schemas/resources/users/user-add.schema.json'
);
const userUpdate = require(
	'../json-schemas/resources/users/user-update.schema.json'
);
const individualAdd = require(
	'../json-schemas/resources/users/individual-add.schema.json'
);
const individualUpdate = require(
	'../json-schemas/resources/users/individual-update.schema.json'
);
const upgradeToIndividual = require(
	'../json-schemas/resources/users/upgrade-to-individual.schema.json'
);
const garageAdd = require(
	'../json-schemas/resources/users/garage-add.schema.json'
);
const garageUpdate = require(
	'../json-schemas/resources/users/garage-update.schema.json'
);
const upgradeToGarage = require(
	'../json-schemas/resources/users/upgrade-to-garage.schema.json'
);
const newPassword = require(
	'../json-schemas/resources/users/new-password.schema.json'
);
const codeGeneration = require(
	'../json-schemas/resources/password-recovery/code-generation.schema.json'
);
const codeVerification = require(
	'../json-schemas/resources/password-recovery/code-verification.schema.json'
);
const passwordRecovery = require(
	'../json-schemas/resources/password-recovery/password-recovery.schema.json'
);
const login = require(
	'../json-schemas/resources/session/login.schema.json'
);
const advertisement = require(
	'../json-schemas/resources/advertisements/advertisements.schema.json'
);
const offer = require(
	'../json-schemas/resources/offers/offers.schema.json'
);
const carFilters = require(
	'../json-schemas/resources/filters/cars.schema.json'
);
const garageFilters = require(
	'../json-schemas/resources/filters/garages.schema.json'
);

const ajv = new Ajv2020({
	allErrors: !config.isProduction,
	logger: {
		log: logger.info,
		warn: logger.warn,
		error: logger.error,
	},
	schemas: [
		idProperty,
		nameProperty,
		nameWithNumberProperty,
		addressProperties,
		carPropertiesProperties,
		pictureProperties,
		userProperties,
		individualProperties,
		offerProperties,
		garageProperties,
		codeProperty,
		codeGenerationProperties,
		codeVerificationProperties,
		passwordRecoveryProperties,
		advertisementProperties,
		filtersProperties,
		carFiltersProperties,
		garageFiltersProperties,
		unique,
		userAdd,
		userUpdate,
		individualAdd,
		individualUpdate,
		upgradeToIndividual,
		garageAdd,
		garageUpdate,
		upgradeToGarage,
		newPassword,
		codeGeneration,
		codeVerification,
		passwordRecovery,
		login,
		advertisement,
		offer,
		carFilters,
		garageFilters,
	]
});

const validate = {
	unique: ajv.getSchema(unique.$id),
	user: {
		add: ajv.getSchema(userAdd.$id),
		update: ajv.getSchema(userUpdate.$id),
		upgrade: {
			individual: ajv.getSchema(upgradeToIndividual.$id),
			garage: ajv.getSchema(upgradeToGarage.$id),
		},
		newPassword: ajv.getSchema(newPassword.$id),
	},
	individual: {
		add: ajv.getSchema(individualAdd.$id),
		update: ajv.getSchema(individualUpdate.$id),
	},
	garage: {
		add: ajv.getSchema(garageAdd.$id),
		update: ajv.getSchema(garageUpdate.$id),
	},
	passwordRecovery: {
		codeGeneration: ajv.getSchema(codeGeneration.$id),
		codeVerification: ajv.getSchema(codeVerification.$id),
		newPassword: ajv.getSchema(passwordRecovery.$id),
	},
	session: {
		login: ajv.getSchema(login.$id),
	},
	advertisement: ajv.getSchema(advertisement.$id),
	offer: ajv.getSchema(offer.$id),
	filters: {
		cars: ajv.getSchema(carFilters.$id),
		garages: ajv.getSchema(garageFilters.$id),
	},
};

module.exports = validate;
