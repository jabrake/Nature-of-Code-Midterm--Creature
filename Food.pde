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
    boundaries();
    edges();
  }

  void update() {
    location.add(velocity);
    velocity.add(acceleration);
    acceleration.mult(0);
    velocity.limit(25);
  }

  void display() {
    image(fly, location.x, location.y, 15, 15);
  }

  void applyForce(PVector r) {
    acceleration.add(r);
  }
  
  //Apply Repeller Force to all Flies
  void applyRepeller(Creature creature) {
    for (Food f: foods) {
      PVector force = creature.repel(f);
      f.applyForce(force);
    }
  }
  
  //Boundaries for Flies 
  void boundaries() {
    float d = 50;
    PVector force = new PVector(0, 0);

    if (location.x < d) {
      force.x = 1.5;
    } 
    else if (location.x > width -d) {
      force.x = -1.5;
    } 
    if (location.y < d) {
      force.y = 1.5;
    } 
    else if (location.y > height-d) {
      force.y = -1.5;
    } 

    force.normalize();
    force.mult(0.01);
    applyForce(force);
  }
  
  //More boundaries!
  void edges() {
    if (location.x > width+50) {
      velocity.x *= -1;
      location.x = width+50;
    }
    if (location.x < -50) {
      velocity.x *= -1; 
      location.x = -50;
    }
    if (location.y > height+50) {
      velocity.y *= -1;
      location.y = height+50;
    }
    if (location.y < -50) {
      velocity.y *= -1;
      location.y = -50;
    }
  }
  
  //Boolean to Detect if Flies have been eaten
  boolean isDead() {
    if (lifespan < 1.0) {
      return true;
    } 
    else {
      return false;
    }
  }
  
  //Collision Detection
  void die(Creature creature) {
    for (Food f: foods) {
      float distance = dist(location.x, location.y, creature.location.x, creature.location.y);
      if (distance < 20) {
        lifespan = 0.0;
      }
    }
  }
}

