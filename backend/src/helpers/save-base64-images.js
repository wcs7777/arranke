const path = require('path');
const jimp = require('jimp');
const fs = require('fs-extra');
const { InvalidBase64ImageError } = require('./errors');
const { asyncEvery, asyncMap } = require('./utils');
const locations = require('./locations');
const logger = require('./logger');

async function saveBase64Images(base64Images) {
	const buffers = base64Images.map(toBuffer);
	if (await asyncEvery(buffers, isImage)) {
		const base64Pngs = await asyncMap(buffers, toBase64Png);
		const temporaryDir = await fs.mkdtemp(locations.tmpPrefix);
		const files = [];
		for (let i = 0; i < base64Pngs.length; i++) {
			const file = `${i + 1}.png`;
			files.push(file);
			await fs.writeFile(
				path.join(temporaryDir, file),
				base64Pngs[i],
				{ encoding: 'base64' },
			);
		}
		return { temporaryDir, files };
	} else {
		throw new InvalidBase64ImageError();
	}
}

function toBuffer(base64) {
	return Buffer.from(base64, 'base64');
}

async function isImage(base64) {
	try {
		const image = await jimp.read(toBuffer(base64));
		return (image.getHeight() > 0 && image.getWidth() > 0);
	} catch (err) {
		logger.error(err, 'Invalid image');
		return false;
	}
}

async function toBase64Png(buffer) {
	const image = await jimp.read(buffer);
	return image.getBufferAsync(jimp.MIME_PNG);
}

module.exports = saveBase64Images;
