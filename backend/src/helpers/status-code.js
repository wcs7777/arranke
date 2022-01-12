const statusCode = {
	success: 200,
	invalidCredentials: 401,
	unauthenticated: 401,
	unauthorized: 403,
	notFound: 404,
	invalidParameters: 422,
	serverError: 500,
};

module.exports = statusCode;
