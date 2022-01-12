DROP PROCEDURE IF EXISTS fetch_car_properties $$
CREATE PROCEDURE fetch_car_properties()
BEGIN
	CALL fetch_car_properties_pretty(FALSE);
END $$

DROP PROCEDURE IF EXISTS fetch_car_properties_pretty $$
CREATE PROCEDURE fetch_car_properties_pretty(pretty BOOLEAN)
BEGIN
	DECLARE car_properties JSON;

	SELECT
		JSON_OBJECT(
			'make', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', id, 'name', name))
				FROM
					make
			),
			'color', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', id, 'name', name))
				FROM
					color
			),
			'fuel', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', id, 'name', name))
				FROM
					fuel
			),
			'steering', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', id, 'name', name))
				FROM
					steering
			),
			'transmission', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', id, 'name', name))
				FROM
					transmission
			),
			'brake', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', id, 'name', name))
				FROM
					brake
			),
			'drivetrain', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', id, 'name', name))
				FROM
					drivetrain
			),
			'feature', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', id, 'name', name))
				FROM
					feature
			)
		)
	INTO
		car_properties;

	IF pretty THEN
		SELECT JSON_PRETTY(car_properties) AS car_properties;
	ELSE
		SELECT car_properties;
	END IF;
END $$

DROP PROCEDURE IF EXISTS fetch_unreferenced_car_properties_pretty $$
CREATE PROCEDURE fetch_unreferenced_car_properties_pretty(
	pretty BOOLEAN
)
BEGIN
	DECLARE car_properties JSON;

	SELECT
		JSON_OBJECT(
			'make', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', m.id, 'name', m.name))
				FROM
					make AS m
				LEFT OUTER JOIN
					model AS mo ON mo.make = m.id
				WHERE
					mo.id IS NULL
			),
			'model', (
				SELECT
					JSON_ARRAYAGG(
						JSON_OBJECT('id', m.id, 'name', m.name, 'make', ma.name)
					)
				FROM
					model AS m
				INNER JOIN
					make AS ma ON ma.id = m.make
				LEFT OUTER JOIN
					car AS c ON c.model = m.id
				WHERE
					c.id IS NULL
			),
			'color', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', c.id, 'name', c.name))
				FROM
					color AS c
				LEFT OUTER JOIN
					car AS ca ON ca.color = c.id
				WHERE
					ca.id IS NULL
			),
			'fuel', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', f.id, 'name', f.name))
				FROM
					fuel AS f
				LEFT OUTER JOIN
					car AS c ON c.fuel = f.id
				WHERE
					c.id IS NULL
			),
			'steering', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', s.id, 'name', s.name))
				FROM
					steering AS s
				LEFT OUTER JOIN
					car AS c ON c.steering = s.id
				WHERE
					c.id IS NULL
			),
			'transmission', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', t.id, 'name', t.name))
				FROM
					transmission AS t
				LEFT OUTER JOIN
					car AS c ON c.transmission = t.id
				WHERE
					c.id IS NULL
			),
			'brake', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', b.id, 'name', b.name))
				FROM
					brake AS b
				LEFT OUTER JOIN
					car AS c ON c.brake = b.id
				WHERE
					c.id IS NULL
			),
			'drivetrain', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', d.id, 'name', d.name))
				FROM
					drivetrain AS d
				LEFT OUTER JOIN
					car AS c ON c.drivetrain = d.id
				WHERE
					c.id IS NULL
			),
			'feature', (
				SELECT
					JSON_ARRAYAGG(JSON_OBJECT('id', f.id, 'name', f.name))
				FROM
					feature AS f
				LEFT OUTER JOIN
					car_feature AS cf ON cf.feature = f.id
				WHERE
					cf.feature IS NULL
			)
		)
	INTO
		car_properties;

	IF pretty THEN
		SELECT JSON_PRETTY(car_properties) AS car_properties;
	ELSE
		SELECT car_properties;
	END IF;
END $$

DROP PROCEDURE IF EXISTS fetch_models $$
CREATE PROCEDURE fetch_models(
	make INT
)
BEGIN
	SELECT
		m.id AS id,
		m.name AS name
	FROM
		model AS m
	WHERE
		m.make = make;
END $$
