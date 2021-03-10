package Entity;

public class Dog extends Pet {
    private String barkPitch;

    public Dog(int id, String name, int age, int vet_cvr, String barkPitch) {
        super(id, name, age, vet_cvr);
        this.barkPitch = barkPitch;
    }

    public String getBarkPitch() {
        return barkPitch;
    }

    public void setBarkPitch(String barkPitch) {
        this.barkPitch = barkPitch;
    }

    @Override
    public String toString() {
        return "[DOG] Id: " + getId() + ", Name: " + getName() + ", Age: " + getAge() + ", Vet CVR: " + getVet_cvr() + ", Bark Pitch: " + getBarkPitch();
    }
}
