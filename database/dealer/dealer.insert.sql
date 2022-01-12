DROP PROCEDURE IF EXISTS add_dealer $$
CREATE PROCEDURE add_dealer(
	nome VARCHAR(60),
	email VARCHAR(60),
	password VARCHAR(72),
	phone CHAR(11),
	cep CHAR(8),
	state CHAR(2),
	city VARCHAR(60),
	area VARCHAR(60),
	street VARCHAR(60),
	number VARCHAR(10)
)
BEGIN
	DECLARE user INT;
	DECLARE address INT;

	CALL add_user(nome, email, password, phone, FALSE);

	SELECT LAST_INSERT_ID() INTO user;

	INSERT INTO address
		(cep, state, city, area, street, number)
	VALUES
		(cep, state, city, area, street, number);

	SELECT LAST_INSERT_ID() INTO address;

	INSERT INTO dealer
		(user, address)
	VALUES
		(user, address);
END $$

DROP PROCEDURE IF EXISTS add_dealer_by_user $$
CREATE PROCEDURE add_dealer_by_user(
	user INT,
	cep CHAR(8),
	state CHAR(2),
	city VARCHAR(60),
	area VARCHAR(60),
	street VARCHAR(60),
	number VARCHAR(10)
)
BEGIN
	DECLARE address INT;

	INSERT INTO address
		(cep, state, city, area, street, number)
	VALUES
		(cep, state, city, area, street, number);

	SELECT LAST_INSERT_ID() INTO address;

	INSERT INTO dealer
		(user, address)
	VALUES
		(user, address);
END $$
