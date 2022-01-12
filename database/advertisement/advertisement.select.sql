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
