import java.util.Iterator;

Creature creature;
ArrayList<Food> foods;

void setup() {
  size(600, 600);
  creature = new Creature();
  foods = new ArrayList<Food>();
}

void draw() {
  background(255);

  creature.run();
  foods.add(new Food(new PVector(random(width), random(height))));

  Iterator<Food> it = foods.iterator();
  while (it.hasNext ()) {
    Food f = it.next();
    f.run();
    f.applyRepeller(creature);
    if (f.isDead()) {
      it.remove();
    }
  }

  if (keyPressed) {
    if (key == CODED && keyCode == LEFT) {
      creature.turn(-0.05);
    } 

    else if (key == CODED && keyCode == RIGHT) {
      creature.turn(0.05);
    }

    if (key == ' ') {
      creature.jump();
    }
  }
}

