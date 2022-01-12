DROP PROCEDURE IF EXISTS fetch_individual $$
CREATE PROCEDURE fetch_individual(
	id INT
)
BEGIN
	CALL fetch_individual_pretty(id, FALSE);
END $$

DROP PROCEDURE IF EXISTS fetch_individual_pretty $$
CREATE PROCEDURE fetch_individual_pretty(
	id INT,
	pretty BOOLEAN
)
BEGIN
	DECLARE individual JSON;

	SELECT
		JSON_OBJECT(
			'id', i.id,
			'name', u.name,
			'email', u.email,
			'phone', u.phone,
			'cpf', i.cpf,
			'address', JSON_OBJECT(
				'cep', a.cep,
				'state', a.state,
				'city', a.city,
				'area', a.area,
				'street', a.street,
				'number', a.number
			)
		)
	INTO
		individual
	FROM
		dealer AS d
	INNER JOIN
		individual AS i ON i.dealer = d.id
	INNER JOIN
		user AS u ON u.id = d.user
	INNER JOIN
		address AS a ON a.id = d.address
	WHERE
		i.id = id
	LIMIT 1;

	IF pretty THEN
		SELECT JSON_PRETTY(individual) AS individual;
	ELSE
		SELECT individual;
	END IF;
END $$

DROP PROCEDURE IF EXISTS individual_id $$
CREATE PROCEDURE individual_id(
	dealer INT
)
BEGIN
	SELECT
		i.id AS id
	FROM
		individual AS i
	WHERE
		i.dealer = dealer
	LIMIT 1;
END $$
