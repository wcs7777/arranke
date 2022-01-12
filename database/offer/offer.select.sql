DROP PROCEDURE IF EXISTS fetch_offers $$
CREATE PROCEDURE fetch_offers(
	dealer INT
)
BEGIN
	CALL fetch_offers_pretty(dealer, FALSE);
END $$

DROP PROCEDURE IF EXISTS fetch_offers_pretty $$
CREATE PROCEDURE fetch_offers_pretty(
	dealer INT,
	pretty BOOLEAN
)
BEGIN
	DECLARE offers JSON;

	SELECT
		JSON_ARRAYAGG(
			JSON_OBJECT(
				'id', offer.id,
				'car', JSON_OBJECT(
					'id', car.id,
					'plate', car.plate,
					'make', make.name,
					'model', model.name,
					'price', car.price,
					'picture', picture.path
				),
				'offerer', user.name
			)
		)
	INTO
		offers
	FROM
		dealer
	INNER JOIN
		car ON car.dealer = dealer.id
	INNER JOIN
		offer ON offer.car = car.id
	INNER JOIN
		user ON user.id = offer.offerer
	INNER JOIN
		model ON model.id = car.model
	INNER JOIN
		make ON make.id = model.make
	INNER JOIN
		picture ON picture.car = car.id
	WhERE
		dealer.id = dealer AND
		picture.sequence = 1
	ORDER BY
		offer.id
	DESC;

	IF pretty THEN
		SELECT JSON_PRETTY(offers) AS offers;
	ELSE
		SELECT offers;
	END IF;
END $$

DROP PROCEDURE IF EXISTS fetch_offer $$
CREATE PROCEDURE fetch_offer(
	dealer INT,
	offer INT
)
BEGIN
	CALL fetch_offer_pretty(dealer, offer, FALSE);
END $$

DROP PROCEDURE IF EXISTS fetch_offer_pretty $$
CREATE PROCEDURE fetch_offer_pretty(
	dealer INT,
	offer INT,
	pretty BOOLEAN
)
BEGIN
	DECLARE offer_json JSON;

	SELECT
		JSON_OBJECT(
			'id', offer.id,
			'car', JSON_OBJECT(
				'id', car.id,
				'make', make.name,
				'model', model.name,
				'picture', picture.path
			),
			'offerer', JSON_OBJECT(
				'name', user.name,
				'phone', user.phone,
				'message', offer.message
			)
		)
	INTO
		offer_json
	FROM
		dealer
	INNER JOIN
		car ON car.dealer = dealer.id
	INNER JOIN
		offer ON offer.car = car.id
	INNER JOIN
		user ON user.id = offer.offerer
	INNER JOIN
		model ON model.id = car.model
	INNER JOIN
		make ON make.id = model.make
	INNER JOIN
		picture ON picture.car = car.id
	WHERE
		dealer.id = dealer AND
		offer.id = offer AND
		picture.sequence = 1
	LIMIT 1;

	IF pretty THEN
		SELECT JSON_PRETTY(offer_json) AS offer_json;
	ELSE
		SELECT offer_json;
	END IF;
END $$

DROP PROCEDURE IF EXISTS fetch_advertisement_offers $$
CREATE PROCEDURE fetch_advertisement_offers(
	dealer INT,
	car INT
)
BEGIN
	CALL fetch_advertisement_offers_pretty(dealer, car, FALSE);
END $$

DROP PROCEDURE IF EXISTS fetch_advertisement_offers_pretty $$
CREATE PROCEDURE fetch_advertisement_offers_pretty(
	dealer INT,
	car INT,
	pretty BOOLEAN
)
BEGIN
	DECLARE offers JSON;

	SELECT
		JSON_ARRAYAGG(
			JSON_OBJECT(
				'id', offer.id,
				'offerer', JSON_OBJECT(
					'name', user.name,
					'phone', user.phone,
					'message', offer.message
				)
			)
		)
	INTO
		offers
	FROM
		dealer
	INNER JOIN
		car ON car.dealer = dealer.id
	INNER JOIN
		offer ON offer.car = car.id
	INNER JOIN
		user ON user.id = offer.offerer
	WHERE
		dealer.id = dealer AND
		car.id = car
	ORDER BY
		offer.id
	DESC;

	IF pretty THEN
		SELECT JSON_PRETTY(offers) AS offers;
	ELSE
		SELECT offers;
	END IF;
END $$
