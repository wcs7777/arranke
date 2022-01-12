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
