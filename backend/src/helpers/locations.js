const path = require('path');
const os = require('os');

const base = path.join(__dirname, '../../');
const tmpPrefix = path.join(os.tmpdir(), 'arranke-');
const picturesPrefix = '/pictures';
const pictures = path.join(base, picturesPrefix);

function fullPath(relative) {
	return path.join(base, relative);
}

function garagePictures(id) {
	return path.join(picturesPrefix, '/garages', `/${id}`);
}

function dealerPictures(id) {
	return path.join(picturesPrefix, `/dealers/${id}`);
}

function carPictures(dealerId, carId) {
	return path.join(dealerPictures(dealerId), `/cars/${carId}`);
}

module.exports = {
	base,
	tmpPrefix,
	picturesPrefix,
	pictures,
	fullPath,
	garagePictures,
	dealerPictures,
	carPictures,
};
