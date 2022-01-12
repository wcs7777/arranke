DROP PROCEDURE IF EXISTS add_garage $$
CREATE PROCEDURE add_garage(
	name VARCHAR(60),
	cnpj CHAR(14),
	picture_path VARCHAR(200),
	responsible_name VARCHAR(60),
	responsible_email VARCHAR(60),
	responsible_password VARCHAR(72),
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
	DECLARE id INT;
	DECLARE dealer INT;

	CALL add_dealer(
		responsible_name,
		responsible_email,
		responsible_password,
		responsible_phone,
		cep,
		state,
		city,
		area,
		street,
		number
	);

	SELECT LAST_INSERT_ID() INTO dealer;

	INSERT INTO garage
		(name, cnpj, picture_path, dealer)
	VALUES
		(name, cnpj, picture_path, dealer);

	IF retrieve THEN
		SELECT LAST_INSERT_ID() INTO id;

		CALL fetch_garage(id);
	END IF;
END $$

DROP PROCEDURE IF EXISTS add_garage_by_user $$
CREATE PROCEDURE add_garage_by_user(
	user INT,
	name VARCHAR(60),
	cnpj CHAR(14),
	picture_path VARCHAR(200),
	cep CHAR(8),
	state CHAR(2),
	city VARCHAR(60),
	area VARCHAR(60),
	street VARCHAR(60),
	number VARCHAR(10),
	retrieve BOOLEAN
)
BEGIN
	DECLARE id INT;
	DECLARE dealer INT;

	CALL add_dealer_by_user(
		user,
		cep,
		state,
		city,
		area,
		street,
		number
	);

	SELECT LAST_INSERT_ID() INTO dealer;

	INSERT INTO garage
		(name, cnpj, picture_path, dealer)
	VALUES
		(name, cnpj, picture_path, dealer);

	IF retrieve THEN
		SELECT LAST_INSERT_ID() INTO id;

		CALL fetch_garage(id);
	END IF;
END $$

