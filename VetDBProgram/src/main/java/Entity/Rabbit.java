package Entity;

public class Rabbit extends Pet {
    private int jumpPower;

    public Rabbit(int id, String name, int age, int vet_cvr, int jumpPower) {
        super(id, name, age, vet_cvr);
        this.jumpPower = jumpPower;
    }

    public int getJumpPower() {
        return jumpPower;
    }

    public void setJumpPower(int jumpPower) {
        this.jumpPower = jumpPower;
    }

    @Override
    public String toString() {
        return "[BIRD] Id: " + getId() + ", Name: " + getName() + ", Age: " + getAge() + ", Vet CVR: " + getVet_cvr() + ", Jump Power: " + getJumpPower();
    }
}
