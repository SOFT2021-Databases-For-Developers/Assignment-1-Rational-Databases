package Entity;

public class Cat extends Pet {
    private int lifeCount;

    public Cat(int id, String name, int age, int vet_cvr, int lifeCount) {
        super(id, name, age, vet_cvr);
        this.lifeCount = lifeCount;
    }

    public int getLifeCount() {
        return lifeCount;
    }

    public void setLifeCount(int lifeCount) {
        this.lifeCount = lifeCount;
    }

    @Override
    public String toString() {
        return "[CAT] Id: " + getId() + ", Name: " + getName() + ", Age: " + getAge() + ", Vet CVR: " + getVet_cvr() + ", Remaining Lives: " + getLifeCount();
    }
}
