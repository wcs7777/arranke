DROP PROCEDURE IF EXISTS remove_user $$
CREATE PROCEDURE remove_user(
	id INT
)
BEGIN
	CALL remove_offers_by_offerer(id);

	DELETE FROM
		user
	WHERE
		user.id = id
	LIMIT 1;
END $$
