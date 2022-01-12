DROP PROCEDURE IF EXISTS fetch_garage $$
CREATE PROCEDURE fetch_garage(
	id INT
)
BEGIN
	CALL fetch_garage_pretty(id, FALSE);
END $$

DROP PROCEDURE IF EXISTS fetch_garage_pretty $$
CREATE PROCEDURE fetch_garage_pretty(
	id INT,
	pretty BOOLEAN
)
BEGIN
	DECLARE garage JSON;

	SELECT
		JSON_OBJECT(
			'id', g.id,
			'name', g.name,
			'cnpj', g.cnpj,
			'picture', g.picture_path,
			'responsible', JSON_OBJECT(
				'name', u.name,
				'email', u.email,
				'phone', u.phone
			),
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
		garage
	FROM
		dealer AS d
	INNER JOIN
		garage AS g ON g.dealer = d.id
	INNER JOIN
		user AS u ON u.id = d.user
	INNER JOIN
		address AS a ON a.id = d.address
	WHERE
		g.id = id
	LIMIT 1;

	IF pretty THEN
		SELECT JSON_PRETTY(garage) AS garage;
	ELSE
		SELECT garage;
	END IF;
END $$

DROP PROCEDURE IF EXISTS garage_id $$
CREATE PROCEDURE garage_id(
	dealer INT
)
BEGIN
	SELECT
		g.id AS id
	FROM
		garage AS g
	WHERE
		g.dealer = dealer
	LIMIT 1;
END $$

DROP PROCEDURE IF EXISTS fetch_garage_for_visitor $$
CREATE PROCEDURE fetch_garage_for_visitor(
	garage INT
)
BEGIN
	CALL fetch_garage_for_visitor_pretty(garage, FALSE);
END $$

DROP PROCEDURE IF EXISTS fetch_garage_for_visitor_pretty $$
CREATE PROCEDURE fetch_garage_for_visitor_pretty(
	garage INT,
	pretty BOOLEAN
)
BEGIN
	DECLARE garage_json JSON;

	SELECT
		JSON_OBJECT(
			'cars', (
				SELECT
					JSON_ARRAYAGG(
						JSON_OBJECT(
							'id', car.id,
							'make', make.name,
							'model', model.name,
							'price', car.price,
							'picture', picture.path
						)
					)
				FROM
					car
				INNER JOIN
					model ON model.id = car.model
				INNER JOIN
					make ON make.id = model.make
				INNER JOIN
					picture ON picture.car = car.id
				WHERE
					car.dealer = dealer.id AND
					picture.sequence = 1
			),
			'garage', JSON_OBJECT(
				'id', garage.id,
				'name', garage.name,
				'picture', garage.picture_path,
				'phone', user.phone,
				'address', JSON_OBJECT(
					'state', address.state,
					'city', address.city,
					'area', address.area,
					'street', address.street,
					'number', address.number
				)
			)
		)
	INTO
		garage_json
	FROM
		garage
	INNER JOIN
		dealer ON garage.dealer = dealer.id
	INNER JOIN
		user ON user.id = dealer.user
	INNER JOIN
		address ON address.id = dealer.address
	WHERE
		garage.id = garage
	LIMIT 1;

	IF pretty THEN
		SELECT JSON_PRETTY(garage_json) AS garage;
	ELSE
		SELECT garage_json AS garage;
	END IF;
END $$

CREATE OR REPLACE VIEW garages_view AS
SELECT
	g.id AS id,
	g.name AS name,
	g.picture_path AS picture, (
		SELECT count(*) FROM car WHERE car.dealer = d.id
	) AS cars,
	a.state AS state,
	a.city AS city
FROM
	garage AS g
INNER JOIN
	dealer AS d ON d.id = g.dealer
INNER JOIN
	address AS a ON a.id = d.address;

/* query básica para garagens (sem filtros) */
SELECT
	id AS id,
	name AS name,
	cars AS cars,
	picture AS picture,
	state AS state,
	city AS city
FROM
	garages_view;

/* exemplo de query para garagens com todos os filtros */
SELECT
	id AS id,
	name AS name,
	cars AS cars,
	picture AS picture,
	state AS state,
	city AS city
FROM
	garages_view
WHERE
	state = 'E1' AND
	city LIKE '%Cidade%';
