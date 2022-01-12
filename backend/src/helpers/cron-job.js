const cron = require('node-cron');
const logger = require('../helpers/logger');
const {
	removeUnreferencedCarProperties
} = require("../data/car-properties.data");
const config = require('./config');

function removeUnreferencedCarPropertiesCronJob() {
	return cron.schedule(
		(
			(config.isProduction)?
			'* * */1 * * *' : // every 1 hour
			'*/30 * * * * *' // every 30 seconds
		),
		removeUnreferencedCarPropertiesJob,
	)
}

async function removeUnreferencedCarPropertiesJob() {
	try {
		logger.info(
			await removeUnreferencedCarProperties(),
			'Unreferenced car properties removed',
		);
	} catch (err) {
		logger.error(
			err,
			'Error removing unreferenced car properties',
		);
	}
}

module.exports = {
	removeUnreferencedCarPropertiesCronJob,
};
