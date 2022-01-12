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
