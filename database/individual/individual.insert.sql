DROP PROCEDURE IF EXISTS add_individual $$
CREATE PROCEDURE add_individual(
	name VARCHAR(60),
	email VARCHAR(60),
	password VARCHAR(72),
	phone CHAR(11),
	cpf CHAR(11),
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
		name,
		email,
		password,
		phone,
		cep,
		state,
		city,
		area,
		street,
		number
	);

	SELECT LAST_INSERT_ID() INTO dealer;

	INSERT INTO individual
		(cpf, dealer)
	VALUES
		(cpf, dealer);

	IF retrieve THEN
		SELECT LAST_INSERT_ID() INTO id;

		CALL fetch_individual(id);
	END IF;
END $$

DROP PROCEDURE IF EXISTS add_individual_by_user $$
CREATE PROCEDURE add_individual_by_user(
	user INT,
	cpf CHAR(11),
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

	INSERT INTO individual
		(cpf, dealer)
	VALUES
		(cpf, dealer);

	IF retrieve THEN
		SELECT LAST_INSERT_ID() INTO id;

		CALL fetch_individual(id);
	END IF;
END $$
