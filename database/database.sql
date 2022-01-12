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
