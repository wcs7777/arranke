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
