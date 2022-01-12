DROP PROCEDURE IF EXISTS dealer_id $$
CREATE PROCEDURE dealer_id(
	user INT
)
BEGIN
	SELECT
		d.id AS id
	FROM
		dealer AS d
	WHERE
		d.user = user
	LIMIT 1;
END $$
