DROP PROCEDURE IF EXISTS remove_advertisement $$
CREATE PROCEDURE remove_advertisement(
	car INT
)
BEGIN
	CALL remove_offers_by_car(car);

	CALL remove_advertisement_pictures(car);
	CALL remove_advertisement_features(car);

	DELETE FROM
		car
	WHERE
		car.id = car
	LIMIT 1;
END $$

DROP PROCEDURE IF EXISTS remove_advertisements $$
CREATE PROCEDURE remove_advertisements(
	dealer INT
)
BEGIN
	CALL remove_offers_by_dealer(dealer);

	DELETE
		p,
		cf
	FROM
		dealer AS d
	INNER JOIN
		car AS c ON c.dealer = d.id
	INNER JOIN
		picture AS p ON p.car = c.id
	INNER JOIN
		car_feature AS cf ON cf.car = c.id
	WHERE
		d.id = dealer;

	DELETE
		c
	FROM
		dealer AS d
	INNER JOIN
		car AS c ON c.dealer = d.id
	WHERE
		d.id = dealer;
END $$

DROP PROCEDURE IF EXISTS remove_advertisement_pictures $$
CREATE PROCEDURE remove_advertisement_pictures(
	car INT
)
BEGIN
	DELETE
		p
	FROM
		picture AS p
	WHERE
		p.car = car;
END $$

DROP PROCEDURE IF EXISTS remove_advertisement_features $$
CREATE PROCEDURE remove_advertisement_features(
	car INT
)
BEGIN
	DELETE
		cf
	FROM
		car_feature AS cf
	WHERE
		cf.car = car;
END $$
