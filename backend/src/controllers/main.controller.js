function home(request, response) {
	response.json({ message: 'home' });
}

module.exports = { home };
