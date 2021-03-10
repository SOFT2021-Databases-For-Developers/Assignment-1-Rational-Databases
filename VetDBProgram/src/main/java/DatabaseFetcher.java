import Entity.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

public class DatabaseFetcher {
    Properties props;
    private String url = "jdbc:postgresql://localhost/VetDB";

    public DatabaseFetcher() {
        this.props = new Properties();
        props.setProperty("user", "admin");
        props.setProperty("password", "admin");
    }

    public List<Pet> getAllPets() throws SQLException {
        List<Pet> pets = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(url, props)) {
            String query = "SELECT * from Pets";
            PreparedStatement statement = conn.prepareStatement(query);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    int id = result.getInt(1);
                    String name = result.getString(2);
                    int age = result.getInt(3);
                    int vet_cvr = result.getInt(4);
                    int lifeCount = result.getInt(5);
                    String barkPitch = result.getString(6);
                    int jumpPower = result.getInt(7);
                    int wingSpan = result.getInt(8);

                    if (jumpPower != 0) {
                        Rabbit rabbit = new Rabbit(id, name, age, vet_cvr, jumpPower);
                        pets.add(rabbit);
                    }
                    if (wingSpan != 0) {
                        Bird bird = new Bird(id, name, age, vet_cvr, wingSpan);
                        pets.add(bird);
                    }
                    if (lifeCount != 0) {
                        Cat cat = new Cat(id, name, age, vet_cvr, lifeCount);
                        pets.add(cat);
                    }
                    if (barkPitch != null) {
                        Dog dog = new Dog(id, name, age, vet_cvr, barkPitch);
                        pets.add(dog);
                    }
                }
            }
        }
        return pets;
    }

    public void insertNewCat(String name, int age, int vet_cvr, int lifeCount) throws SQLException{
        try (Connection conn = DriverManager.getConnection(url, props)) {
            String query = String.format("CALL INSERT_CAT('%s', %s, '%s', %s);", name, age, vet_cvr, lifeCount);
            PreparedStatement statement = conn.prepareStatement(query);
            statement.execute();
        }
    }

    public void insertNewDog(String name, int age, int vet_cvr, String barkPitch) throws SQLException{
        try (Connection conn = DriverManager.getConnection(url, props)) {
            String query = String.format("CALL INSERT_DOG('%s', %s, '%s', '%s');", name, age, vet_cvr, barkPitch);
            PreparedStatement statement = conn.prepareStatement(query);
            statement.execute();
        }
    }

    public void insertNewBird(String name, int age, int vet_cvr, int wingSpan) throws SQLException{
        try (Connection conn = DriverManager.getConnection(url, props)) {
            String query = String.format("CALL INSERT_BIRD('%s', %s, '%s', %s);", name, age, vet_cvr, wingSpan);
            PreparedStatement statement = conn.prepareStatement(query);
            statement.execute();
        }
    }

    public void insertNewRabbit(String name, int age, int vet_cvr, int jumpPower) throws SQLException{
        try (Connection conn = DriverManager.getConnection(url, props)) {
            String query = String.format("CALL INSERT_RABBIT('%s', %s, '%s', %s);", name, age, vet_cvr, jumpPower);
            PreparedStatement statement = conn.prepareStatement(query);
            statement.execute();
        }
    }
}
