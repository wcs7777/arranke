DROP PROCEDURE IF EXISTS update_individual $$
CREATE PROCEDURE update_individual(
	id INT,
	name VARCHAR(60),
	email VARCHAR(60),
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

	CALL update_dealer(
		dealer,
		name,
		email,
		phone,
		cep,
		state,
		city,
		area,
		street,
		number
	);

	UPDATE
		individual AS i
	SET
		i.cpf = cpf
	WHERE
		i.id = id
	LIMIT 1;

	IF retrieve THEN
		CALL fetch_individual(id);
	END IF;
END $$
