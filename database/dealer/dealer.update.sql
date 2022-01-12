DROP PROCEDURE IF EXISTS update_dealer $$
CREATE PROCEDURE update_dealer(
	id INT,
	nome VARCHAR(60),
	email VARCHAR(60),
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

	CALL update_user(user, nome, email, phone, FALSE);

	UPDATE
		address AS a
	SET
		a.cep = cep,
		a.state = state,
		a.city = city,
		a.area = area,
		a.street = street,
		a.number = number
	WHERE
		a.id = address
	LIMIT 1;
END $$
