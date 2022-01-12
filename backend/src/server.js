const express = require('express');
const { createServer: createHttp } = require('http');
const { createServer: createHttps } = require('https');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const cookieParser = require('cookie-parser');
const expressPinoLogger = require('express-pino-logger');
const { ensureDirSync } = require('fs-extra');
const logger = require('./helpers/logger');
const config = require('./helpers/config');
const locations = require('./helpers/locations');
const ssl = require('./helpers/ssl');
const { end: endDatabase } = require('./database/main.database');
const uncaughtError = require('./middleware/uncaught-error');
const addTokenPayloadToRequest = require(
	'./middleware/add-token-payload-to-request'
);
const testRoute = require('./routes/test.route');
const mainRoute = require('./routes/main.route');
const sessionRoute = require('./routes/session.route');
const passwordRecoveryRoute = require('./routes/password-recovery.route');
const usersRoute = require('./routes/users.route');
const carPropertiesRoute = require('./routes/car-properties.route');
const makesRoute = require('./routes/makes.route');
const advertisementsRoute = require('./routes/advertisements.route');
const offersRoute = require('./routes/offers.route');
const uniqueRoute = require('./routes/unique.route');
const carsRoute = require('./routes/cars.route');
const garagesRoute = require('./routes/garages.route');
const errorsMiddleware = require('./middleware/errors');

const app = express();
const server = (config.useHttps)? createHttps(ssl(), app) : createHttp(app);

ensureDirSync(locations.pictures);
app.use(helmet());
app.use(compression());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));
app.use(cookieParser(config.cookie.secret));
app.use(
	cors({
		origin: [config.client.url],
		methods: ['GET', 'PUT', 'POST', 'DELETE', 'OPTIONS'],
		credentials: true,
	}),
);
app.use(uncaughtError(server, cleanup));
app.use(
	locations.picturesPrefix,
	express.static(locations.pictures, { index: false }),
);
app.use(expressPinoLogger({ logger }))
app.use(addTokenPayloadToRequest);
if (!config.isProduction) {
	app.use((request, response, next) => {
		console.log('\n'.repeat(5));
		next();
	});
	app.use('/test', testRoute);
}
app.use(mainRoute);
app.use(sessionRoute);
app.use('/password-recovery', passwordRecoveryRoute);
app.use(usersRoute);
app.use(carPropertiesRoute);
app.use(makesRoute);
app.use(advertisementsRoute);
app.use(offersRoute);
app.use(uniqueRoute);
app.use(carsRoute);
app.use(garagesRoute);
app.use(errorsMiddleware.notFound);
app.use(errorsMiddleware.handleError);

process.on('unhandledRejection', (reason, promise) => {
	logger.error(reason, 'Unhandled rejection. Reason');
});

Array
	.from(['SIGUSR2', 'SIGTERM', 'SIGINT', 'exit'])
	.forEach(event => process.once(event, processSignalHandler));

async function cleanup() {
	cleanup.isCleaned = cleanup.isCleaned || false;
	if (!cleanup.isCleaned) {
		endDatabase()
			.then(() => logger.info('MySQL pool ended'))
			.catch(err => logger.error(err, 'Error ending MySQL pool'));
		cleanup.isCleaned = true;
	}
}

function processSignalHandler(signal) {
	logger.info(`Signal: ${signal}`);
	cleanup()
		.then(() => logger.info('cleanup'))
		.catch(err => logger.error(err, 'Error cleaning up'))
		.finally(() => process.kill(process.pid, signal));
}

module.exports = server;
