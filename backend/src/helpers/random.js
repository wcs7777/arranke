const { randomInt } = require('crypto');

const symbols = range(33, 127)
	.map(mapCharCode)
	.join('')
	.replace("'", '')
	.replace('"', '')
	.replace('`', '');

function randomDigits(n) {
	return random(n, 48, 58);
}

function randomSymbols(n) {
	return range(n)
		.map(() => symbols.charAt(randomInt(symbols.length)))
		.reverse()
		.join('');
}

function random(n, startCode, endCode) {
	return range(n)
		.map(() => randomChar(startCode, endCode))
		.reverse()
		.join('');
}

function range(start, end) {
	if (end === undefined) {
		end = start;
		start = 0;
	}
	return [...Array(end - start).keys()].map(n => n + start);
}

function randomChar(start, end) {
	return mapCharCode(randomInt(start, end));
}

function mapCharCode(code) {
	return String.fromCharCode(code);
}

module.exports = {
	randomDigits,
	randomSymbols,
};
