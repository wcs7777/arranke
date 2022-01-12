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
