DROP PROCEDURE IF EXISTS update_garage $$
CREATE PROCEDURE update_garage(
	id INT,
	name VARCHAR(60),
	cnpj CHAR(14),
	picture_path VARCHAR(200),
	responsible_name VARCHAR(60),
	responsible_email VARCHAR(60),
	responsible_phone CHAR(11),
	cep CHAR(8),
	state CHAR(2),
	city VARCHAR(60),
	area VARCHAR(60),
	street VARCHAR(60),
	number VARCHAR(10),
	retrieve BOOLEAN
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

	CALL update_dealer(
		dealer,
		responsible_name,
		responsible_email,
		responsible_phone,
		cep,
		state,
		city,
		area,
		street,
		number
	);

	UPDATE
		garage AS g
	SET
		g.name = name,
		g.cnpj = cnpj,
		g.picture_path = picture_path
	WHERE
		g.id = id
	LIMIT 1;

	IF retrieve THEN
		CALL fetch_garage(id);
	END IF;
END $$

DROP PROCEDURE IF EXISTS update_garage_picture $$
CREATE PROCEDURE update_garage_picture(
	id INT,
	picture_path VARCHAR(200),
	retrieve BOOLEAN
)
BEGIN
	UPDATE
		garage AS g
	SET
		g.picture_path = picture_path
	WHERE
		g.id = id
	LIMIT 1;

	IF retrieve THEN
		SELECT picture_path AS picture;
	END IF;
END $$
