class Food {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Food(PVector l) {
    location = l.get();
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(random(-0.05, 0.05), random(-0.05, 0.05));
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  void update() {
    location.add(velocity);
    velocity.add(acceleration);
    //lifespan -= 2.0;
  }

  void display() {
    stroke(0, lifespan);
    strokeWeight(2);
    fill(255, 0, 0, lifespan);
    ellipse(location.x, location.y, 12, 12);
  }

  void applyForce(PVector r) {
    for (Food f: foods) {
      f.applyForce(r);
    }
  }

  void applyRepeller(Creature creature) {
    for (Food f: foods) {
      PVector force = creature.repel(f);
      f.applyForce(force);
    }
  }

  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
}

