class Creature {

  PVector location;
  PVector velocity;
  PVector acceleration;

  //Variables for size, direction, slow down of acceleration
  float heading = 0;
  //float size = 50;
  float damping = 0.930;

  //Variables for repel force
  float r = 10;

  Creature() {
    location = new PVector(width/2, height/2);
    velocity = new PVector();
    acceleration = new PVector();
  }

  void run() {
    update();
    display();
    edges();
  }

  void update() {
    location.add(velocity);
    velocity.add(acceleration);
    velocity.mult(damping);
    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    PVector f = force.get();
    acceleration.add(f);
  }
  
  //Jump Force
  void jump() {
    float angle = heading - PI/2;
    PVector force = PVector.fromAngle(angle);
    force.mult(30.0);
    applyForce(force);
  }
  
  //Move Forward Force
  void crawl() {
    float angle = heading - PI/2;
    PVector force = PVector.fromAngle(angle);
    force.mult(0.5);
    applyForce(force);
  }
  
  //Move Backwards Force
  void backwards() {
    float angle = heading - PI/2;
    PVector force = PVector.fromAngle(angle);
    force.mult(-0.5);
    applyForce(force);
  }

  void turn(float a) {
    heading += a;
  }
  
  //Boundaries for Frog to stay on Screen
  void edges() {
    if (location.x > width) {
      velocity.x *= -1;
      location.x = width;
    }
    if (location.x < 0) {
      velocity.x *= -1; 
      location.x = 0;
    }
    if (location.y > height) {
      velocity.y *= -1;
      location.y = height;
    }
    if (location.y < 25) {
      velocity.y *= -1;
      location.y = 25;
    }
  }

  void display() {
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(location.x, location.y);
    rotate(heading);
    fill(10, 200, 30);
    ellipse(0, 0, size, size);
    ellipse(0, -30, size/2, size/2);
    fill(0);
    ellipse(-10, -35, size/6, size/6);
    ellipse(10, -35, size/6, size/6);
    popMatrix();
  }
  
  //Repeller Force
  PVector repel(Food f) {
    PVector dir = PVector.sub(location, f.location);
    float d = dir.mag();
    dir.normalize();
    d = constrain(d, 5, 100);
    float force = -1 * strength / (d * d);
    dir.mult(force);
    return dir;
  }
}

