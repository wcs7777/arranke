DROP DATABASE IF EXISTS arranke;
CREATE DATABASE arranke;
USE arranke;

CREATE TABLE car (
	id INT PRIMARY KEY AUTO_INCREMENT,
	model INT NOT NULL,
	plate CHAR(7) NOT NULL UNIQUE,
	year CHAR(4) NOT NULL,
	price INT NOT NULL,
	mileage INT DEFAULT 0,
	used BOOLEAN DEFAULT TRUE,
	doors INT NOT NULL,
	color INT NOT NULL,
	fuel INT NOT NULL,
	steering INT NOT NULL,
	transmission INT NOT NULL,
	brake INT NOT NULL,
	drivetrain INT NOT NULL,
	observations TEXT,
	dealer INT NOT NULL
);

CREATE TABLE make (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE model (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(40) NOT NULL,
	make INT NOT NULL,
	UNIQUE KEY unique_model_name_make(name, make)
);

CREATE TABLE feature (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE car_feature (
	car INT NOT NULL,
	feature INT NOT NULL,
	PRIMARY KEY(car, feature)
);

CREATE TABLE color (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE fuel (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE steering (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE transmission (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE brake (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE drivetrain (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE picture (
	id INT PRIMARY KEY AUTO_INCREMENT,
	car INT NOT NULL,
	path VARCHAR(200) UNIQUE NOT NULL,
	sequence INT NOT NULL
);

CREATE TABLE user (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(60) NOT NULL,
	email VARCHAR(60) UNIQUE NOT NULL,
	password VARCHAR(72) NOT NULL, /* hash */
	code VARCHAR(72), /* hash */
	phone CHAR(11)
);

CREATE TABLE dealer (
	id INT PRIMARY KEY AUTO_INCREMENT,
	user INT UNIQUE NOT NULL,
	address INT UNIQUE NOT NULL
);

CREATE TABLE address (
	id INT PRIMARY KEY AUTO_INCREMENT,
	cep CHAR(8) NOT NULL,
	state CHAR(2) NOT NULL,
	city VARCHAR(60) NOT NULL,
	area VARCHAR(60) NOT NULL,
	street VARCHAR(60) NOT NULL,
	number VARCHAR(10) NOT NULL
);

CREATE TABLE individual (
	id INT PRIMARY KEY AUTO_INCREMENT,
	cpf CHAR(11) UNIQUE NOT NULL,
	dealer INT UNIQUE NOT NULL
);

CREATE TABLE garage (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(60) NOT NULL,
	cnpj CHAR(14) UNIQUE NOT NULL,
	picture_path VARCHAR(200) UNIQUE NOT NULL,
	dealer INT UNIQUE NOT NULL
);

CREATE TABLE offer (
	id INT PRIMARY KEY AUTO_INCREMENT,
	car INT NOT NULL,
	offerer INT NOT NULL,
	message TEXT NOT NULL
);

CREATE TABLE integers (
	i INT
);

CREATE TABLE json_indexes (
	i VARCHAR(10)
);

INSERT INTO integers
	SELECT
		@i := @i + 1 AS i
	FROM
		(SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t1,
		(SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t2,
		(SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t3,
		(SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t4,
		(SELECT @i:= -1) AS numbers;

INSERT INTO json_indexes
	SELECT
		CONCAT('$[', integers.i, ']') AS i
	FROM
		integers;

DROP TABLE integers;

/* foreign keys e indexes */

ALTER TABLE car
	ADD CONSTRAINT fk_car_model
		FOREIGN KEY (model)
		REFERENCES model(id),
	ADD CONSTRAINT fk_car_color
		FOREIGN KEY (color)
		REFERENCES color(id),
	ADD CONSTRAINT fk_car_fuel
		FOREIGN KEY (fuel)
		REFERENCES fuel(id),
	ADD CONSTRAINT fk_car_steering
		FOREIGN KEY (steering)
		REFERENCES steering(id),
	ADD CONSTRAINT fk_car_transmission
		FOREIGN KEY (transmission)
		REFERENCES transmission(id),
	ADD CONSTRAINT fk_car_brake
		FOREIGN KEY (brake)
		REFERENCES brake(id),
	ADD CONSTRAINT fk_car_drivetrain
		FOREIGN KEY (drivetrain)
		REFERENCES drivetrain(id),
	ADD CONSTRAINT fk_car_dealer
		FOREIGN KEY (dealer)
		REFERENCES dealer(id);

ALTER TABLE model
	ADD CONSTRAINT fk_model_make
		FOREIGN KEY (make)
		REFERENCES make(id);

ALTER TABLE car_feature
	ADD CONSTRAINT fk_car_feature_car
		FOREIGN KEY (car)
		REFERENCES car(id),
	ADD CONSTRAINT fk_car_feature_feature
		FOREIGN KEY (feature)
		REFERENCES feature(id);

ALTER TABLE picture
	ADD CONSTRAINT fk_picture_car
		FOREIGN KEY (car)
		REFERENCES car(id);

ALTER TABLE dealer
	ADD CONSTRAINT fk_dealer_user
		FOREIGN KEY (user)
		REFERENCES user(id),
	ADD CONSTRAINT fk_dealer_address
		FOREIGN KEY (address)
		REFERENCES address(id);

ALTER TABLE individual
	ADD CONSTRAINT fk_individual_dealer
		FOREIGN KEY (dealer)
		REFERENCES dealer(id);

ALTER TABLE garage
	ADD CONSTRAINT fk_garage_dealer
		FOREIGN KEY (dealer)
		REFERENCES dealer(id);

ALTER TABLE offer
	ADD CONSTRAINT fk_offer_car
		FOREIGN KEY (car)
		REFERENCES car(id),
	ADD CONSTRAINT fk_offer_offerer
		FOREIGN KEY (offerer)
		REFERENCES user(id);

/* index */

CREATE INDEX
	index_picture_sequence
ON
	picture(sequence);

CREATE UNIQUE INDEX
	index_dealer_user_address
ON
	dealer(user, address);

CREATE INDEX
	index_address_state
ON
	address(state);

CREATE INDEX
	index_address_city
ON
	address(city);

DELIMITER $$

DROP PROCEDURE IF EXISTS fetch_advertisements $$
CREATE PROCEDURE fetch_advertisements(
	dealer INT
)
BEGIN
	SELECT
		car.id AS id,
		car.plate AS plate,
		car.mileage AS mileage,
		make.name AS make,
		model.name AS model,
		car.price AS price, (
			SELECT count(*) FROM offer WHERE offer.car = car.id
		) AS offers
	FROM
		car
	INNER JOIN
		dealer ON dealer.id = car.dealer
	INNER JOIN
		model ON model.id = car.model
	INNER JOIN
		make ON make.id = model.make
	WHERE
		dealer.id = dealer;
END $$

DROP PROCEDURE IF EXISTS fetch_advertisement $$
CREATE PROCEDURE fetch_advertisement(
	dealer INT,
	car INT
)
BEGIN
	CALL fetch_advertisement_pretty(dealer, car, FALSE);
END $$

DROP PROCEDURE IF EXISTS fetch_advertisement_pretty $$
CREATE PROCEDURE fetch_advertisement_pretty(
	dealer INT,
	car INT,
	pretty BOOLEAN
)
BEGIN
	DECLARE advertisement JSON;

	SELECT
		JSON_OBJECT(
			'id', car.id,
			'make', JSON_OBJECT('id', make.id, 'name', make.name),
			'model', JSON_OBJECT('id', model.id, 'name', model.name),
			'plate', car.plate,
			'year', car.year,
			'price', car.price,
			'mileage', car.mileage,
			'used', car.used,
			'observations', car.observations,
			'pictures', (
				SELECT
					JSON_ARRAYAGG(
						JSON_OBJECT(
							'id', picture.id,
							'sequence', picture.sequence,
							'path', picture.path
						)
					)
				FROM
					picture
				WHERE
					picture.car = car.id
			),
			'specifications', JSON_OBJECT(
				'doors', car.doors,
				'color', JSON_OBJECT(
					'id', color.id, 'name', color.name
				),
				'fuel', JSON_OBJECT(
					'id', fuel.id, 'name', fuel.name
				),
				'steering', JSON_OBJECT(
					'id', steering.id, 'name', steering.name
				),
				'transmission', JSON_OBJECT(
					'id', transmission.id, 'name', transmission.name
				),
				'brake', JSON_OBJECT(
					'id', brake.id, 'name', brake.name
				),
				'drivetrain', JSON_OBJECT(
					'id', drivetrain.id, 'name', drivetrain.name
				)
			),
			'features', (
				SELECT
					JSON_ARRAYAGG(
						JSON_OBJECT(
							'id', f.id,
							'name', f.name
						)
					)
				FROM
					feature AS f
				INNER JOIN
					car_feature AS cf ON cf.feature = f.id
				WHERE
					cf.car = car.id
			)
		)
	INTO
		advertisement
	FROM
		dealer
	INNER JOIN
		car ON car.dealer = dealer.id
	INNER JOIN
		model ON model.id = car.model
	INNER JOIN
		make ON make.id = model.make
	INNER JOIN
		color ON color.id = car.color
	INNER JOIN
		fuel ON fuel.id = car.fuel
	INNER JOIN
		steering ON steering.id = car.steering
	INNER JOIN
		transmission ON transmission.id = car.transmission
	INNER JOIN
		brake ON brake.id = car.brake
	INNER JOIN
		drivetrain ON drivetrain.id = car.drivetrain
	WHERE
		dealer.id = dealer AND
		car.id = car
	LIMIT 1;

	IF pretty THEN
		SELECT JSON_PRETTY(advertisement) AS advertisement;
	ELSE
		SELECT advertisement;
	END IF;
END $$

DROP PROCEDURE IF EXISTS remove_advertisement $$
CREATE PROCEDURE remove_advertisement(
	car INT
)
BEGIN
	CALL remove_offers_by_car(car);

	CALL remove_advertisement_pictures(car);
	CALL remove_advertisement_features(car);

	DELETE FROM
		car
	WHERE
		car.id = car
	LIMIT 1;
END $$

DROP PROCEDURE IF EXISTS remove_advertisements $$
CREATE PROCEDURE remove_advertisements(
	dealer INT
)
BEGIN
	CALL remove_offers_by_dealer(dealer);

	DELETE
		p,
		cf
	FROM
		dealer AS d
	INNER JOIN
		car AS c ON c.dealer = d.id
	INNER JOIN
		picture AS p ON p.car = c.id
	INNER JOIN
		car_feature AS cf ON cf.car = c.id
	WHERE
		d.id = dealer;

	DELETE
		c
	FROM
		dealer AS d
	INNER JOIN
		car AS c ON c.dealer = d.id
	WHERE
		d.id = dealer;
END $$

DROP PROCEDURE IF EXISTS remove_advertisement_pictures $$
CREATE PROCEDURE remove_advertisement_pictures(
	car INT
)
BEGIN
	DELETE
		p
	FROM
		picture AS p
	WHERE
		p.car = car;
END $$

DROP PROCEDURE IF EXISTS remove_advertisement_features $$
CREATE PROCEDURE remove_advertisement_features(
	car INT
)
BEGIN
	DELETE
		cf
	FROM
		car_feature AS cf
	WHERE
		cf.car = car;
END $$

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

DROP PROCEDURE IF EXISTS fetch_car $$
CREATE PROCEDURE fetch_car(
	id INT
)
BEGIN
	CALL fetch_car_pretty(id, FALSE);
END $$

DROP PROCEDURE IF EXISTS fetch_car_pretty $$
CREATE PROCEDURE fetch_car_pretty(
	id INT,
	pretty BOOLEAN
)
BEGIN
	DECLARE car_json JSON;

	SELECT
		JSON_OBJECT(
			'car', JSON_OBJECT(
				'id', car.id,
				'make', JSON_OBJECT(
					'id', make.id,
					'name', make.name
				),
				'model', JSON_OBJECT(
					'id', model.id,
					'name', model.name
				),
				'plateEnd', right(car.plate, 1),
				'year', car.year,
				'price', car.price,
				'mileage', car.mileage,
				'used', car.used,
				'observations', car.observations,
				'pictures', (
					SELECT
						JSON_ARRAYAGG(
							JSON_OBJECT(
								'sequence', picture.sequence,
								'path', picture.path
							)
						)
					FROM
						picture
					WHERE
						picture.car = car.id
				),
				'specifications', JSON_OBJECT(
					'doors', car.doors,
					'color', JSON_OBJECT(
						'id', color.id, 'name', color.name
					),
					'fuel', JSON_OBJECT(
						'id', fuel.id, 'name', fuel.name
					),
					'steering', JSON_OBJECT(
						'id', steering.id, 'name', steering.name
					),
					'transmission', JSON_OBJECT(
						'id', transmission.id, 'name', transmission.name
					),
					'brake', JSON_OBJECT(
						'id', brake.id, 'name', brake.name
					),
					'drivetrain', JSON_OBJECT(
						'id', drivetrain.id, 'name', drivetrain.name
					),
					'features', (
						SELECT
							JSON_ARRAYAGG(
								JSON_OBJECT('id', feature.id, 'name', feature.name)
							)
						FROM
							car_feature
						INNER JOIN
							feature ON feature.id = car_feature.feature
						WHERE
							car_feature.car = car.id
					)
				)
			),
			'dealer', JSON_OBJECT(
				'type', (
					CASE
						WHEN garage.name IS NOT NULL THEN 'Garagem'
						ELSE 'Individual'
					END
				),
				'name', (
					CASE
						WHEN garage.name IS NOT NULL THEN garage.name
						ELSE user.name
					END
				),
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
		car_json
	FROM
		car
	INNER JOIN
		color ON color.id = car.color
	INNER JOIN
		fuel ON fuel.id = car.fuel
	INNER JOIN
		steering ON steering.id = car.steering
	INNER JOIN
		transmission ON transmission.id = car.transmission
	INNER JOIN
		brake ON brake.id = car.brake
	INNER JOIN
		drivetrain ON drivetrain.id = car.drivetrain
	INNER JOIN
		model ON model.id = car.model
	INNER JOIN
		make ON make.id = model.make
	INNER JOIN
		dealer ON dealer.id = car.dealer
	INNER JOIN
		user ON user.id = dealer.user
	INNER JOIN
		address ON address.id = dealer.address
	LEFT OUTER JOIN
		garage ON garage.dealer = dealer.id
	WHERE
		car.id = id
	LIMIT 1;

	IF pretty THEN
		SELECT JSON_PRETTY(car_json) AS car;
	ELSE
		SELECT car_json AS car;
	END IF;
END $$

CREATE OR REPLACE VIEW cars_view AS
SELECT
	car.id AS car_id,
	right(car.plate, 1) AS car_plate_end,
	car.year AS car_year,
	car.price AS car_price,
	car.mileage AS car_mileage,
	car.used AS car_used,
	car.doors AS car_doors,
	car.color AS car_color,
	car.fuel AS car_fuel,
	car.steering AS car_steering,
	car.transmission AS car_transmission,
	car.brake AS car_brake,
	car.drivetrain AS car_drivetrain,
	car_feature.feature AS car_feature,
	make.id AS car_make,
	make.name AS make_name,
	model.id AS car_model,
	model.name AS model_name,
	picture.path AS picture_path,
	dealer.id AS dealer_id,
	user.name AS individual_name,
	garage.id AS garage_id,
	garage.name AS garage_name,
	address.state AS address_state,
	address.city AS address_city
FROM
	car
INNER JOIN
	dealer ON dealer.id = car.dealer
INNER JOIN
	user ON user.id = dealer.user
INNER JOIN
	address ON address.id = dealer.address
LEFT OUTER JOIN
	garage ON garage.dealer = dealer.id
INNER JOIN
	car_feature ON car_feature.car = car.id
INNER JOIN
	model ON model.id = car.model
INNER JOIN
	make ON make.id = model.make
INNER JOIN
	picture ON picture.car = car.id
WHERE
	picture.sequence = 1;

/* query básica para carros (sem filtros) */
SELECT
	DISTINCT car_id AS id,
	make_name AS make,
	model_name AS model,
	car_price AS price,
	car_mileage AS mileage,
	picture_path AS picture, (
		CASE
			WHEN garage_id IS NOT NULL THEN 'Garagem'
			ELSE 'Individual'
		END
	) AS type, (
		CASE
			WHEN garage_id IS NOT NULL THEN garage_name
			ELSE individual_name
		END
	) AS name,
	address_state AS state,
	address_city AS city
FROM
	cars_view;

/* exemplo de query para carros com todos os filtros */
SELECT
	DISTINCT car_id AS id,
	make_name AS make,
	model_name AS model,
	car_price AS price,
	car_mileage AS mileage,
	picture_path AS picture, (
		CASE
			WHEN garage_id IS NOT NULL THEN 'Garagem'
			ELSE 'Individual'
		END
	) AS type, (
		CASE
			WHEN garage_id IS NOT NULL THEN garage_name
			ELSE individual_name
		END
	) AS name,
	address_state AS state,
	address_city AS city
FROM
	cars_view
WHERE
	car_used = 1 AND
	car_make IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) AND
	car_model IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11) AND
	car_color IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) AND
	car_fuel IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) AND
	car_steering IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) AND
	car_transmission IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) AND
	car_brake IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) AND
	car_drivetrain IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) AND
	car_feature IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) AND
	car_mileage BETWEEN 0 AND 10000000 AND
	car_price BETWEEN 0 AND 10000000 AND
	car_plate_end = '1' AND
	car_doors = 2 AND
	address_state = 'SP' AND
	address_city LIKE '%Taquaritinga%'
ORDER BY
	car_price ASC,
	car_mileage DESC;

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

DROP PROCEDURE IF EXISTS add_car_property $$
CREATE PROCEDURE add_car_property(
	table_name VARCHAR(60),
	name VARCHAR(40),
	retrieve BOOLEAN
)
BEGIN
	DECLARE EXIT HANDLER FOR 1062 BEGIN
		IF retrieve THEN
			PREPARE duplicate_stmt FROM @duplicate;
			EXECUTE duplicate_stmt;
			DEALLOCATE PREPARE duplicate_stmt;
		END IF;
	END;

	SET @base = CONCAT(
		'SELECT '
			'id, '
			'name '
		'FROM ',
			table_name, ' ',
		'WHERE '
	);
	SET @duplicate = CONCAT(
		@base,
			table_name, '.name = ''', name, ''' ',
		'LIMIT 1'
	);
	SET @new = CONCAT(
		@base,
			table_name, '.id = LAST_INSERT_ID() '
		'LIMIT 1'
	);
	SET @insert_query = CONCAT(
		'INSERT INTO ', table_name, ' ',
			'(name) ',
		'VALUES ',
			'(''', name, ''')'
	);

	PREPARE insert_query_stmt FROM @insert_query;
	EXECUTE insert_query_stmt;
	DEALLOCATE PREPARE insert_query_stmt;

	IF retrieve THEN
		PREPARE new_stmt FROM @new;
		EXECUTE new_stmt;
		DEALLOCATE PREPARE new_stmt;
	END IF;
END $$

DROP PROCEDURE IF EXISTS add_make $$
CREATE PROCEDURE add_make(
	name VARCHAR(40),
	retrieve BOOLEAN
)
BEGIN
	CALL add_car_property('make', name, retrieve);
END $$

DROP PROCEDURE IF EXISTS add_color $$
CREATE PROCEDURE add_color(
	name VARCHAR(40),
	retrieve BOOLEAN
)
BEGIN
	CALL add_car_property('color', name, retrieve);
END $$

DROP PROCEDURE IF EXISTS add_fuel $$
CREATE PROCEDURE add_fuel(
	name VARCHAR(40),
	retrieve BOOLEAN
)
BEGIN
	CALL add_car_property('fuel', name, retrieve);
END $$

DROP PROCEDURE IF EXISTS add_steering $$
CREATE PROCEDURE add_steering(
	name VARCHAR(40),
	retrieve BOOLEAN
)
BEGIN
	CALL add_car_property('steering', name, retrieve);
END $$

DROP PROCEDURE IF EXISTS add_transmission $$
CREATE PROCEDURE add_transmission(
	name VARCHAR(40),
	retrieve BOOLEAN
)
BEGIN
	CALL add_car_property('transmission', name, retrieve);
END $$

DROP PROCEDURE IF EXISTS add_brake $$
CREATE PROCEDURE add_brake(
	name VARCHAR(40),
	retrieve BOOLEAN
)
BEGIN
	CALL add_car_property('brake', name, retrieve);
END $$

DROP PROCEDURE IF EXISTS add_drivetrain $$
CREATE PROCEDURE add_drivetrain(
	name VARCHAR(40),
	retrieve BOOLEAN
)
BEGIN
	CALL add_car_property('drivetrain', name, retrieve);
END $$

DROP PROCEDURE IF EXISTS add_feature $$
CREATE PROCEDURE add_feature(
	name VARCHAR(40),
	retrieve BOOLEAN
)
BEGIN
	CALL add_car_property('feature', name, retrieve);
END $$

DROP PROCEDURE IF EXISTS add_model $$
CREATE PROCEDURE add_model(
	name VARCHAR(40),
	make INT,
	retrieve BOOLEAN
)
BEGIN
	DECLARE EXIT HANDLER FOR 1062 BEGIN
		IF retrieve THEN
			SELECT
				id,
				name,
				make
			FROM
				model
			WHERE
				model.make = make AND
				model.name = name
			LIMIT 1;
		END IF;
	END;

	INSERT INTO model
		(name, make)
	VALUES
		(name, make);

	IF retrieve THEN
		SELECT
			id,
			name,
			make
		FROM
			model
		WHERE
			id = LAST_INSERT_ID()
		LIMIT 1;
	END IF;
END $$

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

DROP PROCEDURE IF EXISTS dealer_id $$
CREATE PROCEDURE dealer_id(
	user INT
)
BEGIN
	SELECT
		d.id AS id
	FROM
		dealer AS d
	WHERE
		d.user = user
	LIMIT 1;
END $$

DROP PROCEDURE IF EXISTS remove_dealer $$
CREATE PROCEDURE remove_dealer(
	id INT
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

	CALL remove_advertisements(id);

	DELETE FROM
		dealer
	WHERE
		dealer.id = id
	LIMIT 1;

	DELETE FROM
		address
	WHERE
		address.id = address
	LIMIT 1;

	CALL remove_user(user);
END $$

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

DROP PROCEDURE IF EXISTS update_garage $$
CREATE PROCEDURE update_garage(
	id INT,
	name VARCHAR(60),
	cnpj CHAR(14),
	picture_path VARCHAR(200),
	responsible_name VARCHAR(60),
	responsible_email VARCHAR(60),
	responsible_phone CHAR(11),
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
		g.dealer
	INTO
		dealer
	FROM
		garage AS g
	WHERE
		g.id = id
	LIMIT 1;

	CALL update_dealer(
		dealer,
		responsible_name,
		responsible_email,
		responsible_phone,
		cep,
		state,
		city,
		area,
		street,
		number
	);

	UPDATE
		garage AS g
	SET
		g.name = name,
		g.cnpj = cnpj,
		g.picture_path = picture_path
	WHERE
		g.id = id
	LIMIT 1;

	IF retrieve THEN
		CALL fetch_garage(id);
	END IF;
END $$

DROP PROCEDURE IF EXISTS update_garage_picture $$
CREATE PROCEDURE update_garage_picture(
	id INT,
	picture_path VARCHAR(200),
	retrieve BOOLEAN
)
BEGIN
	UPDATE
		garage AS g
	SET
		g.picture_path = picture_path
	WHERE
		g.id = id
	LIMIT 1;

	IF retrieve THEN
		SELECT picture_path AS picture;
	END IF;
END $$

DROP PROCEDURE IF EXISTS add_garage $$
CREATE PROCEDURE add_garage(
	name VARCHAR(60),
	cnpj CHAR(14),
	picture_path VARCHAR(200),
	responsible_name VARCHAR(60),
	responsible_email VARCHAR(60),
	responsible_password VARCHAR(72),
	responsible_phone CHAR(11),
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
		responsible_name,
		responsible_email,
		responsible_password,
		responsible_phone,
		cep,
		state,
		city,
		area,
		street,
		number
	);

	SELECT LAST_INSERT_ID() INTO dealer;

	INSERT INTO garage
		(name, cnpj, picture_path, dealer)
	VALUES
		(name, cnpj, picture_path, dealer);

	IF retrieve THEN
		SELECT LAST_INSERT_ID() INTO id;

		CALL fetch_garage(id);
	END IF;
END $$

DROP PROCEDURE IF EXISTS add_garage_by_user $$
CREATE PROCEDURE add_garage_by_user(
	user INT,
	name VARCHAR(60),
	cnpj CHAR(14),
	picture_path VARCHAR(200),
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

	INSERT INTO garage
		(name, cnpj, picture_path, dealer)
	VALUES
		(name, cnpj, picture_path, dealer);

	IF retrieve THEN
		SELECT LAST_INSERT_ID() INTO id;

		CALL fetch_garage(id);
	END IF;
END $$


DROP PROCEDURE IF EXISTS remove_garage $$
CREATE PROCEDURE remove_garage(
	id INT
)
BEGIN
	DECLARE dealer INT;

	SELECT
		g.dealer
	INTO
		dealer
	FROM
		garage AS g
	WHERE
		g.id = id
	LIMIT 1;

	DELETE FROM
		garage
	WHERE
		garage.id = id
	LIMIT 1;

	CALL remove_dealer(dealer);
END $$

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

DROP PROCEDURE IF EXISTS remove_individual $$
CREATE PROCEDURE remove_individual(
	id INT
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

	DELETE FROM
		individual
	WHERE
		individual.id = id
	LIMIT 1;

	CALL remove_dealer(dealer);
END $$

DROP PROCEDURE IF EXISTS fetch_offers $$
CREATE PROCEDURE fetch_offers(
	dealer INT
)
BEGIN
	CALL fetch_offers_pretty(dealer, FALSE);
END $$

DROP PROCEDURE IF EXISTS fetch_offers_pretty $$
CREATE PROCEDURE fetch_offers_pretty(
	dealer INT,
	pretty BOOLEAN
)
BEGIN
	DECLARE offers JSON;

	SELECT
		JSON_ARRAYAGG(
			JSON_OBJECT(
				'id', offer.id,
				'car', JSON_OBJECT(
					'id', car.id,
					'plate', car.plate,
					'make', make.name,
					'model', model.name,
					'price', car.price,
					'picture', picture.path
				),
				'offerer', user.name
			)
		)
	INTO
		offers
	FROM
		dealer
	INNER JOIN
		car ON car.dealer = dealer.id
	INNER JOIN
		offer ON offer.car = car.id
	INNER JOIN
		user ON user.id = offer.offerer
	INNER JOIN
		model ON model.id = car.model
	INNER JOIN
		make ON make.id = model.make
	INNER JOIN
		picture ON picture.car = car.id
	WhERE
		dealer.id = dealer AND
		picture.sequence = 1
	ORDER BY
		offer.id
	DESC;

	IF pretty THEN
		SELECT JSON_PRETTY(offers) AS offers;
	ELSE
		SELECT offers;
	END IF;
END $$

DROP PROCEDURE IF EXISTS fetch_offer $$
CREATE PROCEDURE fetch_offer(
	dealer INT,
	offer INT
)
BEGIN
	CALL fetch_offer_pretty(dealer, offer, FALSE);
END $$

DROP PROCEDURE IF EXISTS fetch_offer_pretty $$
CREATE PROCEDURE fetch_offer_pretty(
	dealer INT,
	offer INT,
	pretty BOOLEAN
)
BEGIN
	DECLARE offer_json JSON;

	SELECT
		JSON_OBJECT(
			'id', offer.id,
			'car', JSON_OBJECT(
				'id', car.id,
				'make', make.name,
				'model', model.name,
				'picture', picture.path
			),
			'offerer', JSON_OBJECT(
				'name', user.name,
				'phone', user.phone,
				'message', offer.message
			)
		)
	INTO
		offer_json
	FROM
		dealer
	INNER JOIN
		car ON car.dealer = dealer.id
	INNER JOIN
		offer ON offer.car = car.id
	INNER JOIN
		user ON user.id = offer.offerer
	INNER JOIN
		model ON model.id = car.model
	INNER JOIN
		make ON make.id = model.make
	INNER JOIN
		picture ON picture.car = car.id
	WHERE
		dealer.id = dealer AND
		offer.id = offer AND
		picture.sequence = 1
	LIMIT 1;

	IF pretty THEN
		SELECT JSON_PRETTY(offer_json) AS offer_json;
	ELSE
		SELECT offer_json;
	END IF;
END $$

DROP PROCEDURE IF EXISTS fetch_advertisement_offers $$
CREATE PROCEDURE fetch_advertisement_offers(
	dealer INT,
	car INT
)
BEGIN
	CALL fetch_advertisement_offers_pretty(dealer, car, FALSE);
END $$

DROP PROCEDURE IF EXISTS fetch_advertisement_offers_pretty $$
CREATE PROCEDURE fetch_advertisement_offers_pretty(
	dealer INT,
	car INT,
	pretty BOOLEAN
)
BEGIN
	DECLARE offers JSON;

	SELECT
		JSON_ARRAYAGG(
			JSON_OBJECT(
				'id', offer.id,
				'offerer', JSON_OBJECT(
					'name', user.name,
					'phone', user.phone,
					'message', offer.message
				)
			)
		)
	INTO
		offers
	FROM
		dealer
	INNER JOIN
		car ON car.dealer = dealer.id
	INNER JOIN
		offer ON offer.car = car.id
	INNER JOIN
		user ON user.id = offer.offerer
	WHERE
		dealer.id = dealer AND
		car.id = car
	ORDER BY
		offer.id
	DESC;

	IF pretty THEN
		SELECT JSON_PRETTY(offers) AS offers;
	ELSE
		SELECT offers;
	END IF;
END $$

DROP PROCEDURE IF EXISTS add_offer $$
CREATE PROCEDURE add_offer(
	car INT,
	offerer INT,
	message TEXT,
	retrieve BOOLEAN
)
BEGIN
	DECLARE id INT;
	DECLARE dealer INT;

	INSERT INTO offer
		(car, offerer, message)
	VALUES
		(car, offerer, message);

	IF retrieve THEN
		SELECT
			LAST_INSERT_ID()
		INTO
			id;

		SELECT
			car.dealer
		INTO
			dealer
		FROM
			car
		WHERE
			car.id = car;

		CALL fetch_offer(dealer, id);
	END IF;
END $$

DROP PROCEDURE IF EXISTS remove_offers_by_offerer $$
CREATE PROCEDURE remove_offers_by_offerer(
	offerer INT
)
BEGIN
	DELETE
		o
	FROM
		offer AS o
	WHERE
		o.offerer = offerer;
END $$

DROP PROCEDURE IF EXISTS remove_offers_by_car $$
CREATE PROCEDURE remove_offers_by_car(
	car INT
)
BEGIN
	DELETE
		o
	FROM
		offer AS o
	WHERE
		o.car = car;
END $$

DROP PROCEDURE IF EXISTS remove_offers_by_dealer $$
CREATE PROCEDURE remove_offers_by_dealer(
	dealer INT
)
BEGIN
	DELETE
		o
	FROM
		dealer AS d
	INNER JOIN
		car AS c ON c.dealer = d.id
	INNER JOIN
		offer AS o ON o.car = c.id
	WHERE
		d.id = dealer;
END $$

DROP PROCEDURE IF EXISTS fetch_user_for_login $$
CREATE PROCEDURE fetch_user_for_login(
	email VARCHAR(60)
)
BEGIN
	SELECT
		u.id AS id,
		u.name AS name,
		d.id AS dealer_id,
		i.id AS individual_id,
		g.id AS garage_id,
		g.name AS garage_name
	FROM
		user AS u
	LEFT OUTER JOIN
		dealer AS d ON d.user = u.id
	LEFT OUTER JOIN
		individual AS i ON i.dealer = d.id
	LEFT OUTER JOIN
		garage AS g ON g.dealer = d.id
	WHERE
		u.email = email
	LIMIT 1;
END $$

DROP PROCEDURE IF EXISTS fetch_user $$
CREATE PROCEDURE fetch_user(
	id INT
)
BEGIN
	SELECT
		u.id AS id,
		u.name AS name,
		u.email AS email,
		u.phone AS phone
	FROM
		user AS u
	WHERE
		u.id = id
	LIMIT 1;
END $$

DROP PROCEDURE IF EXISTS fetch_user_password_by_email $$
CREATE PROCEDURE fetch_user_password_by_email(
	email VARCHAR(60)
)
BEGIN
	SELECT
		u.password AS password
	FROM
		user AS u
	WHERE
		u.email = email
	LIMIT 1;
END $$

DROP PROCEDURE IF EXISTS fetch_user_password_by_id $$
CREATE PROCEDURE fetch_user_password_by_id(
	id INT
)
BEGIN
	SELECT
		u.password AS password
	FROM
		user AS u
	WHERE
		u.id = id
	LIMIT 1;
END $$

DROP PROCEDURE IF EXISTS fetch_user_code_id $$
CREATE PROCEDURE fetch_user_code_id(
	email VARCHAR(60)
)
BEGIN
	SELECT
		u.id AS id,
		u.code AS code
	FROM
		user AS u
	WHERE
		u.email = email
	LIMIT 1;
END $$

DROP PROCEDURE IF EXISTS add_user $$
CREATE PROCEDURE add_user(
	name VARCHAR(60),
	email VARCHAR(60),
	password VARCHAR(72),
	phone CHAR(11),
	retrieve BOOLEAN
)
BEGIN
	DECLARE id INT;

	INSERT INTO user
		(name, email, password, phone)
	VALUES
		(name, email, password, phone);

	IF retrieve THEN
		SELECT LAST_INSERT_ID() INTO id;

		CALL fetch_user(id);
	END IF;
END $$

DROP PROCEDURE IF EXISTS update_user $$
CREATE PROCEDURE update_user(
	id INT,
	name VARCHAR(60),
	email VARCHAR(60),
	phone CHAR(11),
	retrieve BOOLEAN
)
BEGIN
	UPDATE
		user AS u
	SET
		u.name = name,
		u.email = email,
		u.phone = phone
	WHERE
		u.id = id
	LIMIT 1;

	IF retrieve THEN
		CALL fetch_user(id);
	END IF;
END $$

DROP PROCEDURE IF EXISTS update_password $$
CREATE PROCEDURE update_password(
	id INT,
	password VARCHAR(72)
)
BEGIN
	UPDATE
		user AS u
	SET
		u.password = password,
		u.code = NULL
	WHERE
		u.id = id
	LIMIT 1;
END $$

DROP PROCEDURE IF EXISTS add_code $$
CREATE PROCEDURE add_code(
	email VARCHAR(60),
	code VARCHAR(72)
)
BEGIN
	UPDATE
		user AS u
	SET
		u.code = code
	WHERE
		u.email = email
	LIMIT 1;
END $$

DROP PROCEDURE IF EXISTS remove_user $$
CREATE PROCEDURE remove_user(
	id INT
)
BEGIN
	CALL remove_offers_by_offerer(id);

	DELETE FROM
		user
	WHERE
		user.id = id
	LIMIT 1;
END $$

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

DROP PROCEDURE IF EXISTS dealer_id $$
CREATE PROCEDURE dealer_id(
	user INT
)
BEGIN
	SELECT
		d.id AS id
	FROM
		dealer AS d
	WHERE
		d.user = user
	LIMIT 1;
END $$

DROP PROCEDURE IF EXISTS remove_dealer $$
CREATE PROCEDURE remove_dealer(
	id INT
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

	CALL remove_advertisements(id);

	DELETE FROM
		dealer
	WHERE
		dealer.id = id
	LIMIT 1;

	DELETE FROM
		address
	WHERE
		address.id = address
	LIMIT 1;

	CALL remove_user(user);
END $$

DELIMITER ;

INSERT INTO make
	(name)
VALUES
	('Bmw'),
	('Ford'),
	('Fiat'),
	('Honda'),
	('Renault'),
	('Toyota');

INSERT INTO model
	(name, make)
VALUES
	('Z4 Roadster', 1),
	('M4', 1),
	('EcoSport', 2),
	('Focus Hatch', 2),
	('Fusion', 2),
	('Strada', 3),
	('Civic', 4),
	('Fit', 4),
	('HR-V', 4),
	('City', 4),
	('Accord', 4);

INSERT INTO feature
	(name)
VALUES
	('Airbag'),
	('GPS'),
	('Alarme'),
	('Sensor de Chuva'),
	('Ar condicionado'),
	('Limpador traseiro');

INSERT INTO color
	(name)
VALUES
	('Azul'),
	('Prata'),
	('Vermelho'),
	('Amarelo'),
	('Verde'),
	('Bronze'),
	('Preto'),
	('Marrom');

INSERT INTO fuel
	(name)
VALUES
	('Gasolina'),
	('Álcool'),
	('Flex'),
	('Gás natural');

INSERT INTO steering
	(name)
VALUES
	('Mecânica'),
	('Hidráulica'),
	('Elétrica'),
	('Eletro-hidráulica'),
	('Direção Cinco');

INSERT INTO transmission
	(name)
VALUES
	('Manual'),
	('Automático'),
	('Semi-automático'),
	('Automático sequencial'),
	('Câmbio Cinco'),
	('Câmbio Seis');

INSERT INTO brake
	(name)
VALUES
	('ABS'),
	('Disco'),
	('Tambor'),
	('Eletrônico'),
	('Freio Cinco');

INSERT INTO drivetrain
	(name)
VALUES
	('Dianteira'),
	('Traseira'),
	('Tração Três');

INSERT INTO user
	(name, email, password, phone)
VALUES
	('Usuário Um', 'arranke-usuario1@outlook.com', '$2b$08$M20x/p56uvpouwYGcvdLveJEIddaMjlXnKMLaaudmwOuPrSMTd.pu', '91165975165'),
	('Usuário Dois', 'usuario2@email.com', '$2b$08$g7tDEeeJ4SZmvjR0xfvAaedZOWEQIrWjMTLqj7l1Lg7Tou3aD/ncy', '14347130163'),
	('Usuário Três', 'usuario3@email.com', '$2b$08$R55ywN5k2k0QFSjp00coduRwb5GUs221ZeE/ow81TKmQ6kQfB1EMu', '15126602721'),
	('Usuário Quatro', 'usuario4@email.com', '$2b$08$EBcUY6zSRorNq/EE94OOdOYQHnehB3s.4XI5yccJ/snFBDVdeAnOm', '87558215102'),
	('Usuário Cinco', 'usuario5@email.com', '$2b$08$jY3TTLDXOrA3mk1evkkXUORrvTVcW18b6iMFbJPnOKvomBMt9/iiK', '03355716979'),
	('Usuário Seis', 'usuario6@email.com', '$2b$08$yoGMjHB0HD9W.A4PezaAPOLoxW42oqgz8avClZUIPpQ0JrV9ElwDS', '24640404522'),
	('Usuário Sete', 'usuario7@email.com', '$2b$08$MeUf1wsIqCF2c7E5yD1kaOL6CR0Mz.Alcae.NLyzQb5qpjOka9lN2', '29591855443'),
	('Usuário Oito', 'usuario8@email.com', '$2b$08$Vj92nyznogbvobPdUvK.GOmArAJn9Xymcfedju1y.WgaVXJ2nY6wy', '02416264125'),
	('Usuário Nove', 'usuario9@email.com', '$2b$08$O8Ez9pH9bFNCAtbmF7vxRuKtJBjll5xpSFU9pzfkh83bHQA7o1Oxu', '85828204530');

INSERT INTO address
	(cep, state, city, area, street, number)
VALUES
	('15900970', 'SP', 'Taquaritinga', 'Centro', 'Praça Doutor Horácio Ramalho', '12'),
	('15900009', 'SP', 'Taquaritinga', 'Centro', 'Rua São José ', '32'),
	('24425500', 'RJ', 'São Gonçalo', 'Neves', 'Travessa Carolina', '354'),
	('06665100', 'SP', 'Itapevi', ' Conjunto Habitacional - Setor A', 'Rua Macaúba', '232'),
	('27130500', 'RJ', 'Barra do Piraí', 'Química', 'Rua Prefeito Heitor Favieri', '143'),
	('24476260', 'RJ', 'São Gonçalo', 'Itaúna', 'Rua Henrique Ferreira Porto', '831');

INSERT INTO dealer
	(user, address)
VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 5),
	(6, 6);

INSERT INTO individual
	(cpf, dealer)
VALUES
	('59802626015', 2),
	('81833099095', 4),
	('60428969038', 6);

INSERT INTO garage
	(cnpj, name, picture_path, dealer)
VALUES
	('25618474000122', 'Garagem Um', '/pictures/garages/1/1.png', 1),
	('07215137000102', 'Garagem Dois', '/pictures/garages/2/1.png', 3),
	('08665585000170', 'Garagem Três', '/pictures/garages/3/1.png', 5);

INSERT INTO car
	(model, plate, year, price, mileage, used, doors, color, fuel, steering, transmission, brake, drivetrain, observations, dealer)
VALUES
	( 1, 'CAG9561', '2000',    5000,    5000, 1, 2, 5, 3, 1, 1, 3, 1, 'Carro 01', 1),
	( 1, 'TIX6J85', '2000',   10000,  100000, 1, 4, 2, 1, 2, 2, 2, 1, 'Carro 02', 3),
	( 2, 'DDN3473', '2010',  100000, 2000000, 1, 4, 4, 2, 4, 1, 4, 2, 'Carro 03', 2),
	( 2, 'YBY3H11', '2015',   30000,       0, 0, 2, 4, 3, 2, 1, 1, 1, 'Carro 04', 5),
	( 3, 'DGS8344', '2000',  200000,  100000, 1, 4, 5, 1, 1, 1, 1, 2, 'Carro 05', 5),
	( 3, 'HPL0W74', '2000',   30000,    5000, 1, 2, 1, 2, 3, 4, 2, 1, 'Carro 06', 3),
	( 4, 'CWI2396', '1998',   10000,  100000, 1, 2, 2, 3, 2, 2, 3, 1, 'Carro 07', 5),
	( 4, 'RIM3P71', '2000',   30000, 2000000, 1, 2, 1, 1, 1, 1, 1, 2, 'Carro 08', 5),
	( 5, 'EOX9764', '2000',   10000,       0, 0, 4, 3, 3, 3, 1, 1, 1, 'Carro 09', 1),
	( 5, 'HVB9K90', '2010',  100000,  100000, 1, 4, 3, 2, 4, 4, 3, 1, 'Carro 10', 3),
	( 7, 'VTN4640', '1998',   10000,       0, 0, 2, 5, 1, 2, 1, 4, 2, 'Carro 11', 4),
	( 7, 'ODF7A34', '2015',   10000,  100000, 1, 4, 5, 1, 1, 2, 1, 1, 'Carro 12', 5),
	( 2, 'FPE6884', '2000',   10000, 2000000, 1, 2, 1, 3, 1, 4, 2, 1, 'Carro 13', 1),
	( 3, 'HRI0A22', '2010',    5000,  100000, 1, 2, 2, 1, 3, 1, 3, 1, 'Carro 14', 3),
	( 9, 'XKX5845', '2000',   10000,    5000, 1, 2, 1, 1, 2, 4, 1, 1, 'Carro 15', 1),
	( 9, 'LQQ8Z24', '1998',   10000,  100000, 1, 4, 4, 2, 1, 2, 1, 2, 'Carro 16', 5),
	(10, 'EOZ5478', '2000',   30000,  300000, 1, 2, 3, 3, 1, 1, 2, 1, 'Carro 17', 1),
	(10, 'FRQ0E56', '2010',   10000,    5000, 1, 4, 5, 3, 3, 2, 1, 1, 'Carro 18', 3),
	(11, 'TFX3801', '2000',   30000,  100000, 1, 2, 4, 1, 1, 3, 3, 1, 'Carro 19', 5),
	(11, 'SOI4G24', '2000',   10000,       0, 0, 2, 1, 3, 2, 1, 1, 2, 'Carro 20', 1),
	( 9, 'KCO6081', '2010',  100000,  100000, 1, 2, 5, 1, 4, 2, 2, 1, 'Carro 21', 3),
	( 1, 'FXE0K76', '2000',   10000, 2000000, 1, 2, 2, 2, 3, 4, 4, 1, 'Carro 22', 1),
	( 9, 'SSD5020', '2015',   10000,  100000, 1, 2, 1, 3, 2, 3, 1, 1, 'Carro 23', 5),
	( 2, 'YLA0Q44', '2000',    5000,       0, 0, 2, 1, 3, 1, 1, 3, 2, 'Carro 24', 1),
	( 2, 'OIC3473', '2000',   10000,  100000, 1, 4, 2, 1, 4, 2, 1, 1, 'Carro 25', 6),
	( 1, 'PNL0Z45', '2015',  100000,  100000, 1, 2, 4, 1, 3, 3, 3, 1, 'Carro 26', 5),
	( 3, 'WNX2254', '2000',   10000,    5000, 1, 4, 1, 2, 1, 1, 4, 1, 'Carro 27', 3),
	(10, 'ESI5H41', '2000',    5000,       0, 0, 4, 2, 3, 2, 3, 1, 2, 'Carro 28', 1),
	( 1, 'URQ4551', '2015',   30000,  100000, 1, 2, 5, 1, 4, 1, 3, 1, 'Carro 29', 5),
	( 3, 'RTG5O18', '1998',  100000, 2000000, 1, 4, 3, 2, 3, 2, 2, 2, 'Carro 30', 3);

INSERT INTO picture
	(car, path, sequence)
VALUES
	( 1, '/pictures/dealers/1/cars/1/1.png', 1),
	( 1, '/pictures/dealers/1/cars/1/2.png', 2),
	( 1, '/pictures/dealers/1/cars/1/3.png', 3),
	( 1, '/pictures/dealers/1/cars/1/4.png', 4),
	( 2, '/pictures/dealers/3/cars/2/1.png', 1),
	( 2, '/pictures/dealers/3/cars/2/2.png', 2),
	( 2, '/pictures/dealers/3/cars/2/3.png', 3),
	( 3, '/pictures/dealers/2/cars/3/4.png', 1),
	( 3, '/pictures/dealers/2/cars/3/5.png', 2),
	( 4, '/pictures/dealers/5/cars/4/1.png', 1),
	( 4, '/pictures/dealers/5/cars/4/2.png', 2),
	( 4, '/pictures/dealers/5/cars/4/3.png', 3),
	( 5, '/pictures/dealers/5/cars/5/1.png', 1),
	( 5, '/pictures/dealers/5/cars/5/2.png', 2),
	( 5, '/pictures/dealers/5/cars/5/3.png', 3),
	( 5, '/pictures/dealers/5/cars/5/4.png', 4),
	( 5, '/pictures/dealers/5/cars/5/5.png', 5),
	( 6, '/pictures/dealers/3/cars/6/1.png', 1),
	( 6, '/pictures/dealers/3/cars/6/2.png', 2),
	( 7, '/pictures/dealers/5/cars/7/1.png', 1),
	( 8, '/pictures/dealers/5/cars/8/1.png', 1),
	( 8, '/pictures/dealers/5/cars/8/2.png', 2),
	( 8, '/pictures/dealers/5/cars/8/3.png', 3),
	( 8, '/pictures/dealers/5/cars/8/4.png', 4),
	( 8, '/pictures/dealers/5/cars/8/5.png', 5),
	( 8, '/pictures/dealers/5/cars/8/6.png', 6),
	( 9, '/pictures/dealers/1/cars/9/1.png', 1),
	( 9, '/pictures/dealers/1/cars/9/2.png', 2),
	( 9, '/pictures/dealers/1/cars/9/3.png', 3),
	(10, '/pictures/dealers/3/cars/10/1.png', 1),
	(10, '/pictures/dealers/3/cars/10/2.png', 2),
	(10, '/pictures/dealers/3/cars/10/3.png', 3),
	(11, '/pictures/dealers/4/cars/11/1.png', 1),
	(11, '/pictures/dealers/4/cars/11/2.png', 2),
	(11, '/pictures/dealers/4/cars/11/3.png', 3),
	(12, '/pictures/dealers/5/cars/12/1.png', 1),
	(12, '/pictures/dealers/5/cars/12/2.png', 2),
	(13, '/pictures/dealers/1/cars/13/1.png', 1),
	(13, '/pictures/dealers/1/cars/13/2.png', 2),
	(13, '/pictures/dealers/1/cars/13/3.png', 3),
	(13, '/pictures/dealers/1/cars/13/4.png', 4),
	(14, '/pictures/dealers/3/cars/14/1.png', 1),
	(14, '/pictures/dealers/3/cars/14/2.png', 2),
	(14, '/pictures/dealers/3/cars/14/3.png', 3),
	(14, '/pictures/dealers/3/cars/14/4.png', 4),
	(15, '/pictures/dealers/1/cars/15/1.png', 1),
	(15, '/pictures/dealers/1/cars/15/2.png', 2),
	(15, '/pictures/dealers/1/cars/15/3.png', 3),
	(15, '/pictures/dealers/1/cars/15/4.png', 4),
	(15, '/pictures/dealers/1/cars/15/5.png', 5),
	(16, '/pictures/dealers/5/cars/16/1.png', 1),
	(17, '/pictures/dealers/1/cars/17/1.png', 1),
	(17, '/pictures/dealers/1/cars/17/2.png', 2),
	(17, '/pictures/dealers/1/cars/17/3.png', 3),
	(18, '/pictures/dealers/3/cars/18/1.png', 1),
	(18, '/pictures/dealers/3/cars/18/2.png', 2),
	(19, '/pictures/dealers/5/cars/19/1.png', 1),
	(19, '/pictures/dealers/5/cars/19/2.png', 2),
	(19, '/pictures/dealers/5/cars/19/3.png', 3),
	(20, '/pictures/dealers/1/cars/20/1.png', 1),
	(20, '/pictures/dealers/1/cars/20/2.png', 2),
	(21, '/pictures/dealers/3/cars/21/1.png', 1),
	(21, '/pictures/dealers/3/cars/21/2.png', 2),
	(21, '/pictures/dealers/3/cars/21/3.png', 3),
	(22, '/pictures/dealers/1/cars/22/1.png', 1),
	(22, '/pictures/dealers/1/cars/22/2.png', 2),
	(22, '/pictures/dealers/1/cars/22/3.png', 3),
	(23, '/pictures/dealers/5/cars/23/1.png', 1),
	(23, '/pictures/dealers/5/cars/23/2.png', 2),
	(24, '/pictures/dealers/1/cars/24/1.png', 1),
	(24, '/pictures/dealers/1/cars/24/2.png', 2),
	(24, '/pictures/dealers/1/cars/24/3.png', 3),
	(24, '/pictures/dealers/1/cars/24/4.png', 4),
	(25, '/pictures/dealers/6/cars/25/1.png', 1),
	(25, '/pictures/dealers/6/cars/25/2.png', 2),
	(25, '/pictures/dealers/6/cars/25/3.png', 3),
	(26, '/pictures/dealers/5/cars/26/1.png', 1),
	(26, '/pictures/dealers/5/cars/26/2.png', 2),
	(27, '/pictures/dealers/3/cars/27/1.png', 1),
	(27, '/pictures/dealers/3/cars/27/2.png', 2),
	(27, '/pictures/dealers/3/cars/27/3.png', 3),
	(28, '/pictures/dealers/1/cars/28/1.png', 1),
	(29, '/pictures/dealers/5/cars/29/1.png', 1),
	(29, '/pictures/dealers/5/cars/29/2.png', 2),
	(30, '/pictures/dealers/3/cars/30/1.png', 1),
	(30, '/pictures/dealers/3/cars/30/2.png', 2);

INSERT INTO car_feature
	(car, feature)
VALUES
	( 1, 2),
	( 1, 3),
	( 1, 4),
	( 1, 5),
	( 2, 1),
	( 2, 2),
	( 2, 3),
	( 2, 4),
	( 2, 5),
	( 3, 1),
	( 3, 3),
	( 3, 5),
	( 4, 1),
	( 4, 2),
	( 4, 3),
	( 4, 4),
	( 4, 5),
	( 5, 3),
	( 5, 5),
	( 6, 1),
	( 6, 2),
	( 6, 3),
	( 6, 4),
	( 7, 1),
	( 8, 2),
	( 8, 3),
	( 9, 1),
	( 9, 3),
	( 9, 4),
	( 9, 5),
	(10, 1),
	(10, 2),
	(10, 4),
	(11, 1),
	(11, 3),
	(11, 4),
	(11, 5),
	(12, 3),
	(12, 4),
	(13, 1),
	(13, 2),
	(13, 3),
	(13, 4),
	(14, 1),
	(14, 4),
	(15, 5),
	(16, 1),
	(16, 2),
	(16, 3),
	(16, 4),
	(16, 5),
	(17, 1),
	(17, 2),
	(18, 1),
	(19, 1),
	(19, 2),
	(19, 3),
	(20, 1),
	(20, 2),
	(21, 2),
	(21, 3),
	(21, 4),
	(21, 5),
	(22, 1),
	(22, 2),
	(22, 4),
	(23, 1),
	(23, 4),
	(24, 3),
	(24, 4),
	(24, 5),
	(25, 1),
	(26, 1),
	(26, 2),
	(26, 3),
	(26, 4),
	(26, 5),
	(27, 1),
	(27, 2),
	(27, 3),
	(28, 1),
	(28, 2),
	(28, 3),
	(28, 4),
	(29, 1),
	(29, 2),
	(30, 1);

INSERT INTO offer
	(car, offerer, message)
VALUES
	( 1, 7, 'Oferta 01'),
	( 1, 8, 'Oferta 02'),
	( 1, 9, 'Oferta 03'),
	( 2, 7, 'Oferta 04'),
	( 2, 8, 'Oferta 05'),
	( 3, 7, 'Oferta 06'),
	( 3, 8, 'Oferta 07'),
	( 4, 9, 'Oferta 08'),
	( 6, 7, 'Oferta 09'),
	( 6, 9, 'Oferta 10'),
	( 7, 7, 'Oferta 11'),
	( 7, 8, 'Oferta 12'),
	( 7, 9, 'Oferta 13'),
	( 8, 7, 'Oferta 14'),
	( 8, 8, 'Oferta 15'),
	( 9, 1, 'Oferta 16'),
	(10, 7, 'Oferta 17'),
	(10, 8, 'Oferta 18'),
	(11, 7, 'Oferta 19'),
	(11, 8, 'Oferta 20'),
	(11, 9, 'Oferta 21'),
	(12, 7, 'Oferta 22'),
	(13, 7, 'Oferta 23'),
	(13, 8, 'Oferta 24'),
	(14, 7, 'Oferta 25'),
	(14, 8, 'Oferta 26'),
	(14, 9, 'Oferta 27'),
	(15, 7, 'Oferta 28'),
	(15, 8, 'Oferta 29'),
	(16, 7, 'Oferta 30'),
	(16, 8, 'Oferta 31'),
	(16, 9, 'Oferta 32'),
	(17, 8, 'Oferta 33'),
	(17, 9, 'Oferta 34'),
	(18, 7, 'Oferta 35'),
	(19, 7, 'Oferta 36'),
	(19, 8, 'Oferta 37'),
	(19, 9, 'Oferta 38'),
	(20, 7, 'Oferta 39'),
	(20, 8, 'Oferta 40'),
	(21, 9, 'Oferta 41'),
	(22, 7, 'Oferta 42'),
	(22, 8, 'Oferta 43'),
	(22, 9, 'Oferta 44'),
	(23, 8, 'Oferta 45'),
	(23, 9, 'Oferta 46'),
	(24, 7, 'Oferta 47'),
	(24, 9, 'Oferta 48'),
	(25, 7, 'Oferta 49'),
	(26, 7, 'Oferta 50'),
	(26, 8, 'Oferta 51'),
	(27, 2, 'Oferta 52'),
	(27, 7, 'Oferta 53'),
	(27, 8, 'Oferta 54'),
	(27, 9, 'Oferta 55'),
	(28, 7, 'Oferta 56'),
	(29, 8, 'Oferta 57'),
	(29, 9, 'Oferta 58'),
	(30, 7, 'Oferta 59'),
	(30, 8, 'Oferta 60');
