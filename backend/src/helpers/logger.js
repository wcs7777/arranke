const pino = require('pino');
const { logLevel: level } = require('./config');

const logger = pino({ level });

module.exports = logger;
