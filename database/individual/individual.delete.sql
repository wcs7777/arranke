DROP PROCEDURE IF EXISTS remove_individual $$
CREATE PROCEDURE remove_individual(
	id INT
)
BEGIN
	DECLARE dealer INT;

	SELECT
		i.dealer
	INTO
		dealer
	FROM
		individual AS i
	WHERE
		i.id = id
	LIMIT 1;

	DELETE FROM
		individual
	WHERE
		individual.id = id
	LIMIT 1;

	CALL remove_dealer(dealer);
END $$
