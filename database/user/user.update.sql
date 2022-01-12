DROP PROCEDURE IF EXISTS update_user $$
CREATE PROCEDURE update_user(
	id INT,
	name VARCHAR(60),
	email VARCHAR(60),
	phone CHAR(11),
	retrieve BOOLEAN
)
BEGIN
	UPDATE
		user AS u
	SET
		u.name = name,
		u.email = email,
		u.phone = phone
	WHERE
		u.id = id
	LIMIT 1;

	IF retrieve THEN
		CALL fetch_user(id);
	END IF;
END $$

DROP PROCEDURE IF EXISTS update_password $$
CREATE PROCEDURE update_password(
	id INT,
	password VARCHAR(72)
)
BEGIN
	UPDATE
		user AS u
	SET
		u.password = password,
		u.code = NULL
	WHERE
		u.id = id
	LIMIT 1;
END $$

DROP PROCEDURE IF EXISTS add_code $$
CREATE PROCEDURE add_code(
	email VARCHAR(60),
	code VARCHAR(72)
)
BEGIN
	UPDATE
		user AS u
	SET
		u.code = code
	WHERE
		u.email = email
	LIMIT 1;
END $$
