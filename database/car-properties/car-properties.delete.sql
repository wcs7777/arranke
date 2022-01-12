DROP PROCEDURE IF EXISTS remove_unreferenced_car_properties $$
CREATE PROCEDURE remove_unreferenced_car_properties(
	retrieve BOOLEAN
)
BEGIN
	DECLARE affected_rows JSON;

	DELETE
		m
	FROM
		model AS m
	INNER JOIN
		make AS ma ON ma.id = m.make
	LEFT OUTER JOIN
		car AS c ON c.model = m.id
	WHERE
		c.id IS NULL;

	IF retrieve THEN
		SELECT
			JSON_OBJECT('model', ROW_COUNT())
		INTO
			affected_rows;
	END IF;

	DELETE
		m
	FROM
		make AS m
	LEFT OUTER JOIN
		model AS mo ON mo.make = m.id
	WHERE
		mo.id IS NULL;

	IF retrieve THEN
		SELECT
			JSON_MERGE_PRESERVE(
				affected_rows,
				JSON_OBJECT('make', ROW_COUNT())
			)
		INTO
			affected_rows;
	END IF;

	DELETE
		c
	FROM
		color AS c
	LEFT OUTER JOIN
		car AS ca ON ca.color = c.id
	WHERE
		ca.id IS NULL;

	IF retrieve THEN
		SELECT
			JSON_MERGE_PRESERVE(
				affected_rows,
				JSON_OBJECT('color', ROW_COUNT())
			)
		INTO
			affected_rows;
	END IF;

	DELETE
		f
	FROM
		fuel AS f
	LEFT OUTER JOIN
		car AS c ON c.fuel = f.id
	WHERE
		c.id IS NULL;

	IF retrieve THEN
		SELECT
			JSON_MERGE_PRESERVE(
				affected_rows,
				JSON_OBJECT('fuel', ROW_COUNT())
			)
		INTO
			affected_rows;
	END IF;

	DELETE
		s
	FROM
		steering AS s
	LEFT OUTER JOIN
		car AS c ON c.steering = s.id
	WHERE
		c.id IS NULL;

	IF retrieve THEN
		SELECT
			JSON_MERGE_PRESERVE(
				affected_rows,
				JSON_OBJECT('steering', ROW_COUNT())
			)
		INTO
			affected_rows;
	END IF;

	DELETE
		t
	FROM
		transmission AS t
	LEFT OUTER JOIN
		car AS c ON c.transmission = t.id
	WHERE
		c.id IS NULL;

	IF retrieve THEN
		SELECT
			JSON_MERGE_PRESERVE(
				affected_rows,
				JSON_OBJECT('transmission', ROW_COUNT())
			)
		INTO
			affected_rows;
	END IF;

	DELETE
		b
	FROM
		brake AS b
	LEFT OUTER JOIN
		car AS c ON c.brake = b.id
	WHERE
		c.id IS NULL;

	IF retrieve THEN
		SELECT
			JSON_MERGE_PRESERVE(
				affected_rows,
				JSON_OBJECT('brake', ROW_COUNT())
			)
		INTO
			affected_rows;
	END IF;

	DELETE
		d
	FROM
		drivetrain AS d
	LEFT OUTER JOIN
		car AS c ON c.drivetrain = d.id
	WHERE
		c.id IS NULL;

	IF retrieve THEN
		SELECT
			JSON_MERGE_PRESERVE(
				affected_rows,
				JSON_OBJECT('drivetrain', ROW_COUNT())
			)
		INTO
			affected_rows;
	END IF;

	DELETE
		f
	FROM
		feature AS f
	LEFT OUTER JOIN
		car_feature AS cf ON cf.feature = f.id
	WHERE
		cf.feature IS NULL;

	IF retrieve THEN
		SELECT
			JSON_MERGE_PRESERVE(
				affected_rows,
				JSON_OBJECT('feature', ROW_COUNT())
			)
		AS
			affected_rows;
	END IF;
END $$
