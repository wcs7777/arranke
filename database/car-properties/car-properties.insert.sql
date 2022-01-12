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
