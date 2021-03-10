package Entity;

public class Pet {
    private int id;
    private String name;
    private int age;
    private int vet_cvr;

    public Pet(int id, String name, int age, int vet_cvr) {
        this.id = id;
        this.name = name;
        this.age = age;
        this.vet_cvr = vet_cvr;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public int getVet_cvr() {
        return vet_cvr;
    }

    public void setVet_cvr(int vet_cvr) {
        this.vet_cvr = vet_cvr;
    }

    @Override
    public String toString() {
        return "Pet{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", age=" + age +
                ", vet_cvr=" + vet_cvr +
                '}';
    }
}
