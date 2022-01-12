const { cpus } = require('os');
const { randomSymbols } = require('./random');

const env = process.env.NODE_ENV || 'development';
const isProduction = (env === 'production');
const domain = process.env.DOMAIN;
const port = parseInt(process.env.PORT) || 3000;
const useHttps = (process.env.USE_HTTPS === '1');
const usingHttps = isProduction || useHttps;
const config = {
	isProduction,
	env,
	domain,
	port,
	useHttps,
	usingHttps,
	url: `http${(usingHttps)? 's' : ''}://${domain}:${port}/`,
	useCluster: (process.env.USE_CLUSTER === '1'),
	logLevel: process.env.LOG_LEVEL || 'info',
	cpus: parseInt(process.env.CPUS) || cpus().length,
	session: {
		user: process.env.SESSION_USER,
		token: {
			cookie: process.env.JWT_COOKIE,
			secret: process.env.JWT_SECRET,
			options: {
				algorithm: process.env.JWT_ALGORITHM,
				expiresIn: process.env.JWT_EXPIRES_IN,
			},
		},
	},
	cookie: {
		secret: process.env.COOKIE_SECRET || randomSymbols(43),
	},
	email: {
		service: process.env.MAIL_SERVICE,
		auth: {
			user: process.env.MAIL_USER,
			pass: process.env.MAIL_PASS,
		},
	},
	mysql: {
		connectionLimit: process.env.MYSQL_POOL,
		host: process.env.MYSQL_HOST,
		port: process.env.MYSQL_PORT,
		user: process.env.MYSQL_USER,
		password: process.env.MYSQL_PASSWORD,
		database: process.env.MYSQL_DATABASE,
	},
	client : {
		url: process.env.CLIENT_URL,
	},
};

module.exports = config;
