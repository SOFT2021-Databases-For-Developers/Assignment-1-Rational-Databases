package Entity;

public class Bird extends Pet {
    private int wingSpan;

    public Bird(int id, String name, int age, int vet_cvr, int wingSpan) {
        super(id, name, age, vet_cvr);
        this.wingSpan = wingSpan;
    }

    public int getWingSpan() {
        return wingSpan;
    }

    public void setWingSpan(int wingSpan) {
        this.wingSpan = wingSpan;
    }

    @Override
    public String toString() {
        return "[BIRD] Id: " + getId() + ", Name: " + getName() + ", Age: " + getAge() + ", Vet CVR: " + getVet_cvr() + ", Wing Span: " + getWingSpan();
    }
}
