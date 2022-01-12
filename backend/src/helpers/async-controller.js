const statusCode = require('./status-code');
const { notFound } = require('../middleware/errors');

function sendResult(
	promise,
	response,
	next,
	{
		locationSuccess=undefined,
		statusSuccess=statusCode.success,
	}={},
) {
	return commonLogic(
		promise,
		response,
		next,
		{
			locationSuccess,
			statusSuccess,
		},
	);
}

function nextIfSuccess(
	promise,
	response,
	next,
	{
		locationSuccess=undefined,
		statusSuccess=statusCode.success,
		successKey='success',
		responseKey='message',
	}={},
) {
	return commonLogic(
		promise,
		response,
		next,
		{
			locationSuccess,
			statusSuccess,
			successKey,
			responseKey,
			verifySuccess: true,
			toNextIfSuccess: true,
		},
	);
}

function sendFeedback(
	promise,
	response,
	next,
	{
		locationSuccess=undefined,
		statusSuccess=statusCode.success,
		successKey='success',
		responseKey='message',
	}={},
) {
	return commonLogic(
		promise,
		response,
		next,
		{
			locationSuccess,
			statusSuccess,
			successKey,
			responseKey,
			verifySuccess: true,
		},
	);
}

async function commonLogic(
	promise,
	response,
	next,
	{
		locationSuccess=undefined,
		statusSuccess=statusCode.success,
		successKey='success',
		responseKey='message',
		verifySuccess=false,
		toNextIfSuccess=false,
	}={},
) {
	try {
		const result = await promise;
		if (!result) {
			return notFound(undefined, response);
		}
		if (!verifySuccess) {
			setLocation(response, locationSuccess);
			return response
				.status(statusSuccess)
				.json(result);
		}
		if (result[successKey]) {
			setLocation(response, locationSuccess);
			response.status(statusSuccess);
			if (toNextIfSuccess) {
				return next();
			}
		} else {
			response.status(result.status || statusCode.invalidParameters);
		}
		return response.json({ [responseKey]: result[responseKey] });
	} catch (err) {
		return next(err);
	}
}

function setLocation(response, path) {
	if (path) {
		response.location(path);
	}
}

module.exports = {
	sendResult,
	nextIfSuccess,
	sendFeedback,
};
