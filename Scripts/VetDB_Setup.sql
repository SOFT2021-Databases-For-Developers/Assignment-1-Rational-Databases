DROP SEQUENCE IF EXISTS petsequence;
DROP TABLE IF EXISTS Messages;
DROP TABLE IF EXISTS Pets_Caretakers;
DROP TABLE IF EXISTS DOG_DATA CASCADE;
DROP TABLE IF EXISTS CAT_DATA CASCADE;
DROP TABLE IF EXISTS RABBIT_DATA CASCADE;
DROP TABLE IF EXISTS BIRD_DATA CASCADE;
DROP TABLE IF EXISTS PET_DATA CASCADE;
DROP TABLE IF EXISTS Caretakers;
DROP TABLE IF EXISTS Vets CASCADE;
DROP TABLE IF EXISTS Addresses CASCADE;
DROP TABLE IF EXISTS Cities;
DROP TYPE IF EXISTS species;

CREATE SEQUENCE PetSequence;
CREATE TYPE species as enum (
	'CAT',
	'DOG'
);
CREATE TABLE IF NOT EXISTS Cities (
	city_code int PRIMARY KEY,
	name varchar(100) NOT NULL
);
CREATE TABLE IF NOT EXISTS Addresses (
	address_id SERIAL PRIMARY KEY,
	street varchar(100) NOT NULL,
	city_code int REFERENCES Cities NOT NULL
);
CREATE TABLE IF NOT EXISTS Vets (
	vet_cvr char(8) PRIMARY KEY,
	name varchar(80) NOT NULL,
	address_id INT REFERENCES Addresses NOT NULL
);
Create TABLE IF NOT EXISTS PET_DATA (
	id SERIAL PRIMARY KEY,
	name varchar(80) NOT NULL,
	age int NOT NULL,
	vet_cvr char(8) REFERENCES Vets NOT NULL
);
CREATE TABLE IF NOT EXISTS CAT_DATA (
	id SERIAL PRIMARY KEY REFERENCES PET_DATA,
	lifeCount int DEFAULT(9)
);
CREATE TABLE IF NOT EXISTS DOG_DATA (
	id SERIAL PRIMARY KEY REFERENCES PET_DATA,
	barkPitch char(2)
);
CREATE TABLE IF NOT EXISTS RABBIT_DATA (
	id SERIAL PRIMARY KEY REFERENCES PET_DATA,
	jumpPower int DEFAULT(10)
);
CREATE TABLE IF NOT EXISTS BIRD_DATA (
	id SERIAL PRIMARY KEY REFERENCES PET_DATA,
	wingSpan int
);
CREATE TABLE IF NOT EXISTS Caretakers (
	id SERIAL PRIMARY KEY,
	name varchar(80) NOT NULL,
	address_id INT REFERENCES Addresses NOT NULL
);
CREATE TABLE IF NOT EXISTS Pets_Caretakers (
	caretaker_id SERIAL REFERENCES Caretakers (id) ON DELETE CASCADE,
	pet_id SERIAL REFERENCES PET_DATA (id) ON DELETE CASCADE,
	CONSTRAINT pet_product_pkey PRIMARY KEY (caretaker_id, pet_id)
);
CREATE TABLE IF NOT EXISTS Messages (
	id int REFERENCES PET_DATA,
	vet_cvr char(8) REFERENCES VETS,
	reason text not null,
	message_time timestamp not null
);

/* === VIEWS === */
CREATE OR REPLACE VIEW CATS AS SELECT P.*, C.lifeCount FROM PET_DATA AS P JOIN CAT_DATA as C on P.id = C.id;
CREATE OR REPLACE VIEW DOGS AS SELECT P.*, D.barkPitch FROM PET_DATA AS P JOIN DOG_DATA as D on P.id = D.id;
CREATE OR REPLACE VIEW RABBITS AS SELECT P.*, R.jumpPower FROM PET_DATA AS P JOIN RABBIT_DATA as R on P.id = R.id;
CREATE OR REPLACE VIEW BIRDS AS SELECT P.*, B.wingSpan FROM PET_DATA AS P JOIN BIRD_DATA as B on P.id = B.id;

CREATE OR REPLACE VIEW PETS AS	SELECT P.*, C.lifeCount, D.barkPitch, R.jumpPower, B.wingSpan FROM PET_DATA as P 
	LEFT OUTER JOIN CAT_DATA as C on P.id = C.id
	LEFT OUTER JOIN DOG_DATA as D on P.id = D.id
	LEFT OUTER JOIN RABBIT_DATA as R on P.id = R.id
	LEFT OUTER JOIN BIRD_DATA as B on P.id = B.id;
	
	
/* === Create Stored Procedures === */
-- INSERT CAT PROCEDURE --
CREATE OR REPLACE PROCEDURE INSERT_CAT (
 	name VARCHAR(80),
 	age INTEGER,
	vet_cvr VARCHAR(8),
	lifeCount INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN  
  WITH NEW_CAT AS(
  	INSERT INTO PET_DATA(name, age, vet_cvr) VALUES (name, age, vet_cvr) RETURNING id
  )
  INSERT INTO CAT_DATA (id, lifeCount) SELECT id, lifeCount FROM NEW_CAT;  
END; $$;


-- INSERT DOG PROCEDURE --
CREATE OR REPLACE PROCEDURE INSERT_DOG (
 	name VARCHAR(80),
 	age INTEGER,
	vet_cvr VARCHAR(8),
	barkPitch CHAR(2)
)

LANGUAGE plpgsql
AS $$
BEGIN  
  WITH NEW_DOG AS(
  	INSERT INTO PET_DATA(name, age, vet_cvr) VALUES (name, age, vet_cvr) RETURNING id
  )
  INSERT INTO DOG_DATA (id, barkPitch) SELECT id, barkPitch FROM NEW_DOG;  
END; $$;


-- INSERT RABBIT PROCEDURE --
CREATE OR REPLACE PROCEDURE INSERT_RABBIT (
 	name VARCHAR(80),
 	age INTEGER,
	vet_cvr VARCHAR(8),
	jumpPower INTEGER
)

LANGUAGE plpgsql
AS $$
BEGIN  
  WITH NEW_RABBIT AS(
  	INSERT INTO PET_DATA(name, age, vet_cvr) VALUES (name, age, vet_cvr) RETURNING id
  )
  INSERT INTO RABBIT_DATA (id, jumpPower) SELECT id, jumpPower FROM NEW_RABBIT;  
END; $$;

-- INSERT BIRD PROCEDURE --
CREATE OR REPLACE PROCEDURE INSERT_BIRD (
 	name VARCHAR(80),
 	age INTEGER,
	vet_cvr VARCHAR(8),
	wingSpan INTEGER
)

LANGUAGE plpgsql
AS $$
BEGIN  
  WITH NEW_BIRD AS(
  	INSERT INTO PET_DATA(name, age, vet_cvr) VALUES (name, age, vet_cvr) RETURNING id
  )
  INSERT INTO BIRD_DATA (id, wingSpan) SELECT id, wingSpan FROM NEW_BIRD;  
END; $$;

-- UPDATE CAT LIFECOUNT --
CREATE OR REPLACE PROCEDURE UPDATE_CAT_LIFECOUNT (
 	catId INTEGER,
	newLifeCount INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN  
	UPDATE CAT_DATA SET lifeCount = newLifeCount where id = catId;
END; $$;


/* === Create Trigger Functions === */
CREATE OR REPLACE FUNCTION log_lifeCount()
	RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
	IF NEW.lifeCount < OLD.lifeCount THEN
		INSERT INTO Messages(id, vet_cvr, reason, message_time)
		VALUES(old.id, (SELECT vet_cvr from PET_DATA where PET_DATA.id = OLD.id), 'Cats life count decreased', now());
	END IF;
	RETURN NEW;
END;
$$;

CREATE TRIGGER life_count_changes
	BEFORE UPDATE
	ON CAT_DATA
	FOR EACH ROW
	EXECUTE PROCEDURE log_lifeCount();

/* === DATA INSERT === */
INSERT INTO Cities(city_code, name) VALUES ('1234', 'Hundested');
INSERT INTO Addresses(street, city_code) VALUES ('Street 123', 1234);
INSERT INTO Addresses(street, city_code) VALUES ('Street 456', 1234);
INSERT INTO Vets(vet_cvr, name, address_id) VALUES ('12345678', 'Dr. Ebsen', '1');
INSERT INTO Vets(vet_cvr, name, address_id) VALUES ('87654321', 'Dr. Hein', '2');

-- INSERT 5 CATS --
CALL INSERT_CAT('Adam', 7, '12345678', 5);
CALL INSERT_CAT('Bobby', 17, '87654321', 1);
CALL INSERT_CAT('Charlie', 12, '12345678', 3);
CALL INSERT_CAT('Dianne', 1, '87654321', 7);
CALL INSERT_CAT('Eric', 6, '12345678', 6);

-- INSERT 5 DOGS --
CALL INSERT_DOG('Fran', 1, '87654321', 'A1');
CALL INSERT_DOG('Gunther', 5, '12345678', 'C4');
CALL INSERT_DOG('Heidi', 8, '87654321', 'D2');
CALL INSERT_DOG('Jones', 12, '12345678', 'C2');
CALL INSERT_DOG('Kevin', 2, '87654321', 'G6');

-- INSERT 5 RABBITS --
CALL INSERT_RABBIT('Lone', 8, '12345678', 7);
CALL INSERT_RABBIT('Martin', 8, '87654321', 7);
CALL INSERT_RABBIT('Nick', 8, '12345678', 7);
CALL INSERT_RABBIT('Oliver', 8, '87654321', 7);
CALL INSERT_RABBIT('Peter', 8, '12345678', 7);

-- INSERT 5 BIRDS --
CALL INSERT_BIRD ('Quinn', 6, '87654321', 100);
CALL INSERT_BIRD ('Ralf', 20, '12345678', 69);
CALL INSERT_BIRD ('Steve', 16, '87654321', 50);
CALL INSERT_BIRD ('Tom', 2, '12345678', 84);
CALL INSERT_BIRD ('Ulrich', 6, '87654321', 100);

-- UPDATE CATS LIFECOUNT --
CALL UPDATE_CAT_LIFECOUNT(1,1);

-- INSERT 10 CARETAKERS --
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_1', '1');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_2', '2');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_3', '2');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_4', '2');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_5', '1');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_6', '2');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_7', '1');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_8', '2');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_9', '2');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_10', '1');

-- ADD PETS TO CARETAKERS --
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (1,1);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (1,2);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (1,3);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (2,4);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (2,5);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (2,6);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (3,7);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (3,8);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (4,9);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (4,10);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (5,11);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (5,12);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (6,13);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (7,14);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (7,15);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (8,16);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (9,17);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (9,18);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (10,19);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (10,20);