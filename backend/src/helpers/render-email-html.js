const express = require('express');
const { create } = require('express-handlebars');
const { fullPath } = require('./locations');

const app = express();

app.engine(
	'handlebars',
	create({
		defaultLayout: 'email',
	}).engine,
);
app.set('view engine', 'handlebars');
app.set('views', fullPath('/src/views'));

function renderEmailHtml(view, locals={}) {
	return new Promise((resolve, reject) => (
		app.render(view, locals, (err, html) => (
			(err)? reject(err) : resolve(html)
		))
	));
}

module.exports = renderEmailHtml;
