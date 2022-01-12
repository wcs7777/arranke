const { create } = require('domain');
const cluster = require('cluster');
const logger = require('../helpers/logger');
const statusCode = require('../helpers/status-code');

function uncaughtError(server, cleanup) {
	return (request, response, next) => {
		const domain = create();
		domain.on('error', errDomain => {
			logger.error(errDomain, 'Domain error caught');
			try {
				cleanup()
					.then(() => logger.info('cleanup'))
					.catch(errCleanup => logger.error(errCleanup, 'Error cleaning up'));
				setTimeout(() => {
					logger.error('Failsafe shutdown');
					process.exit(1);
				}, 10 * 1000).unref();
				if (cluster.worker) {
					cluster.worker.disconnect();
				}
				server.close(() => {
					logger.info('Shutdown with all connections finished');
					process.exit(1);
				});
				try {
					next(errDomain);
				} catch (errExpress) {
					logger.error(errExpress, 'Express error mechanism failed');
					response.statusCode = errExpress.status || statusCode.serverError;
					response.setHeader('Content-type', 'application/json');
					response.end(JSON.stringify({ message: 'Server error' }));
				}
			} catch (err) {
				logger.error(err, 'Unable to send 500 response');
			}
		});
		domain.add(request);
		domain.add(response);
		domain.run(next);
	};
}

module.exports = uncaughtError;
