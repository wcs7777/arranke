DROP PROCEDURE IF EXISTS add_advertisement $$
CREATE PROCEDURE add_advertisement(
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
	DECLARE id INT;

	INSERT INTO car (
		model,
		plate,
		year,
		price,
		mileage,
		used,
		doors,
		color,
		fuel,
		steering,
		transmission,
		brake,
		drivetrain,
		observations,
		dealer
	) VALUES (
		model,
		plate,
		year,
		price,
		mileage,
		used,
		doors,
		color,
		fuel,
		steering,
		transmission,
		brake,
		drivetrain,
		observations,
		dealer
	);

	SELECT LAST_INSERT_ID() INTO id;

	CALL add_advertisement_pictures(id, pictures);
	CALL add_advertisement_features(id, features);

	IF retrieve THEN
		CALL fetch_advertisement(dealer, id);
	END IF;
END $$

DROP PROCEDURE IF EXISTS add_advertisement_pictures $$
CREATE PROCEDURE add_advertisement_pictures(
	car INT,
	pictures JSON
)
BEGIN
	DECLARE pictures_length INT;

	SELECT
		JSON_LENGTH(pictures)
	INTO
		pictures_length;

	INSERT INTO picture
		(car, path, sequence)
	SELECT
		car,
		extracted_picture->>'$.path' AS path,
		extracted_picture->'$.sequence' AS sequence
	FROM (
		SELECT
			JSON_EXTRACT(pictures, i) AS extracted_picture
		FROM
			json_indexes
		LIMIT pictures_length
	) AS extracted_pictures;
END $$

DROP PROCEDURE IF EXISTS add_advertisement_features $$
CREATE PROCEDURE add_advertisement_features(
	car INT,
	features JSON
)
BEGIN
	DECLARE features_length INT;

	SELECT
		JSON_LENGTH(features)
	INTO
		features_length;

	INSERT INTO car_feature
		(car, feature)
	SELECT
		car,
		JSON_EXTRACT(features, i) AS feature
	FROM
		json_indexes
	LIMIT features_length;
END $$
