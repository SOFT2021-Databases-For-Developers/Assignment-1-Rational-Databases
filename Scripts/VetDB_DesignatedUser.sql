-- It is not possible for PostgreSQL to create a user who can only see view, so we limit it to only being able to select and view certain tables --
CREATE ROLE designateduser WITH LOGIN PASSWORD '1234'; -- Create a new role called DESIGNATED_USER with the password 1234
REVOKE ALL ON ALL TABLES IN SCHEMA PUBLIC FROM designateduser; -- Revoke all of CONSUMER's privileges ON all tables

-- Grant privilege to the user --
GRANT SELECT ON "pet_data" TO designateduser;
GRANT SELECT ON "cat_data" TO designateduser;
GRANT SELECT ON "dog_data" TO designateduser;
GRANT SELECT ON "rabbit_data" TO designateduser;
GRANT SELECT ON "bird_data" TO designateduser;

GRANT SELECT ON "pets" TO designateduser;
GRANT SELECT ON "birds" TO designateduser;
GRANT SELECT ON "dogs" TO designateduser;
GRANT SELECT ON "rabbits" TO designateduser;
GRANT SELECT ON "cats" TO designateduser;

GRANT ALL ON PROCEDURE insert_cat TO designateduser;
GRANT ALL ON PROCEDURE insert_dog TO designateduser;
GRANT ALL ON PROCEDURE insert_rabbit TO designateduser;
GRANT ALL ON PROCEDURE insert_bird TO designateduser;
GRANT ALL ON PROCEDURE update_cat_lifecount TO designateduser;
