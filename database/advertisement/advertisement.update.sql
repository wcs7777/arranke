DROP PROCEDURE IF EXISTS update_advertisement $$
CREATE PROCEDURE update_advertisement(
	id INT,
	model INT,
	plate CHAR(7),
	year CHAR(4),
	price INT,
	mileage INT,
	used BOOLEAN,
	observations TEXT,
	pictures JSON,
	doors INT,
	color INT,
	fuel INT,
	steering INT,
	transmission INT,
	brake INT,
	drivetrain INT,
	features JSON,
	dealer INT,
	retrieve BOOLEAN
)
BEGIN
	UPDATE
		car AS c
	SET
		c.model = model,
		c.plate = plate,
		c.year = year,
		c.price = price,
		c.mileage = mileage,
		c.used = used,
		c.doors = doors,
		c.color = color,
		c.fuel = fuel,
		c.steering = steering,
		c.transmission = transmission,
		c.brake = brake,
		c.drivetrain = drivetrain,
		c.observations = observations
	WHERE
		c.id = id
	LIMIT 1;

	CALL update_advertisement_pictures(id, pictures, FALSE);
	CALL update_advertisement_features(id, features, FALSE);

	IF retrieve THEN
		CALL fetch_advertisement(dealer, id);
	END IF;
END $$

DROP PROCEDURE IF EXISTS update_advertisement_pictures $$
CREATE PROCEDURE update_advertisement_pictures(
	car INT,
	pictures JSON,
	retrieve BOOLEAN
)
BEGIN
	CALL remove_advertisement_pictures(car);
	CALL add_advertisement_pictures(car, pictures);

	IF retrieve THEN
		SELECT
			JSON_ARRAYAGG(
				JSON_OBJECT(
					'sequence', picture.sequence,
					'path', picture.path
				)
			) AS pictures
		FROM
			picture
		WHERE
			picture.car = car;
	END IF;
END $$

DROP PROCEDURE IF EXISTS update_advertisement_features $$
CREATE PROCEDURE update_advertisement_features(
	car INT,
	features JSON,
	retrieve BOOLEAN
)
BEGIN
	CALL remove_advertisement_features(car);
	CALL add_advertisement_features(car, features);

	IF retrieve THEN
		SELECT
			JSON_ARRAYAGG(
				JSON_OBJECT(
					'id', f.id,
					'name', f.name
				)
			) AS features
		FROM
			feature AS f
		INNER JOIN
			car_feature AS cf ON cf.feature = f.id
		WHERE
			cf.car = car;
	END IF;
END $$
