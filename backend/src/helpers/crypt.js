const bcrypt = require('bcrypt');

async function encrypt(data) {
	return bcrypt.hash(data, await bcrypt.genSalt(8));
}

async function encryptedIsEqual(data, encrypted) {
	return (data && encrypted)? bcrypt.compare(data, encrypted) : false;
}

module.exports = {
	encrypt,
	encryptedIsEqual,
};
