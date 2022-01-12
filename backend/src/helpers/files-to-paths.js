const path = require('path');

function filesToPaths(dir, files) {
	return files.map(file => path.join(dir, file));
}

module.exports = filesToPaths;
