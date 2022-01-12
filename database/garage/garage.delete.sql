DROP PROCEDURE IF EXISTS remove_garage $$
CREATE PROCEDURE remove_garage(
	id INT
)
BEGIN
	DECLARE dealer INT;

	SELECT
		g.dealer
	INTO
		dealer
	FROM
		garage AS g
	WHERE
		g.id = id
	LIMIT 1;

	DELETE FROM
		garage
	WHERE
		garage.id = id
	LIMIT 1;

	CALL remove_dealer(dealer);
END $$
