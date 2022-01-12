function toLine(text) {
	return text
		.split('\n')
		.map(line => line.trim())
		.filter(line => line !== '')
		.join(' ');
}

function deleteKey(object, path, separator='.') {
	let [first, ...remaining] = path.split(separator);
	let pointer = object;
	if (!first) {
		first = remaining.shift();
	}
	for (const key of remaining) {
		pointer = pointer[first];
		first = key;
	}
	delete pointer[first];
	return object;
}

async function asyncEvery(arr, predicate) {
	for (const element of arr) {
		if (!(await predicate(element))) {
			return false;
		}
	}
	return true;
}

async function asyncMap(arr, callbackFn) {
	const mapped = [];
	for (const element of arr) {
		mapped.push(await callbackFn(element));
	}
	return mapped;
}

module.exports = {
	toLine,
	deleteKey,
	asyncEvery,
	asyncMap,
};
