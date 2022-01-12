const nodemailer = require('nodemailer');
const { htmlToText } = require('nodemailer-html-to-text');
const config = require('./config');

const { email: { service, auth } } = config;
const transporter = nodemailer.createTransport(
	{ service, auth, secure: true },
	{ from: `"Arranke 🚗" <${auth.user}>` },
);
transporter.use('compile', htmlToText());

function sendMail({ to, subject, html }) {
	return transporter.sendMail({ to, subject, html });
}

module.exports = sendMail;
