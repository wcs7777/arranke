DROP PROCEDURE IF EXISTS add_user $$
CREATE PROCEDURE add_user(
	name VARCHAR(60),
	email VARCHAR(60),
	password VARCHAR(72),
	phone CHAR(11),
	retrieve BOOLEAN
)
BEGIN
	DECLARE id INT;

	INSERT INTO user
		(name, email, password, phone)
	VALUES
		(name, email, password, phone);

	IF retrieve THEN
		SELECT LAST_INSERT_ID() INTO id;

		CALL fetch_user(id);
	END IF;
END $$
