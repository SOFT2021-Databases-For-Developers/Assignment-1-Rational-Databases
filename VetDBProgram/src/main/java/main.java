import Entity.Pet;
import java.util.List;

public class main {

    public static void main(String[] args) throws Exception {
        DatabaseFetcher db = new DatabaseFetcher();

        db.insertNewCat("JAVA CAT", 999, 12345678, 1);
        db.insertNewBird("JAVA BIRD", 999, 87654321, 100);
        db.insertNewDog("JAVA DOG", 999, 12345678, "C4");
        db.insertNewRabbit("JAVA RABBIT", 999, 87654321, 50);


        List<Pet> petList = db.getAllPets();
        for (Pet pet : petList) {
            System.out.println(pet);
        }
    }
}
