DROP PROCEDURE IF EXISTS remove_offers_by_offerer $$
CREATE PROCEDURE remove_offers_by_offerer(
	offerer INT
)
BEGIN
	DELETE
		o
	FROM
		offer AS o
	WHERE
		o.offerer = offerer;
END $$

DROP PROCEDURE IF EXISTS remove_offers_by_car $$
CREATE PROCEDURE remove_offers_by_car(
	car INT
)
BEGIN
	DELETE
		o
	FROM
		offer AS o
	WHERE
		o.car = car;
END $$

DROP PROCEDURE IF EXISTS remove_offers_by_dealer $$
CREATE PROCEDURE remove_offers_by_dealer(
	dealer INT
)
BEGIN
	DELETE
		o
	FROM
		dealer AS d
	INNER JOIN
		car AS c ON c.dealer = d.id
	INNER JOIN
		offer AS o ON o.car = c.id
	WHERE
		d.id = dealer;
END $$
