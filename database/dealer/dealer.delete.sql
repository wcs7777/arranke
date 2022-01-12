DROP PROCEDURE IF EXISTS remove_dealer $$
CREATE PROCEDURE remove_dealer(
	id INT
)
BEGIN
	DECLARE user INT;
	DECLARE address INT;

	SELECT
		d.user,
		d.address
	INTO
		user,
		address
	FROM
		dealer AS d
	WHERE
		d.id = id
	LIMIT 1;

	CALL remove_advertisements(id);

	DELETE FROM
		dealer
	WHERE
		dealer.id = id
	LIMIT 1;

	DELETE FROM
		address
	WHERE
		address.id = address
	LIMIT 1;

	CALL remove_user(user);
END $$
