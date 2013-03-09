class Creature {

  PVector location;
  PVector velocity;
  PVector acceleration;

  float heading = 0;
  float size = 50;
  float damping = 0.900;
  float strength = 100;
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

  void jump() {
    float angle = heading - PI/2;
    PVector force = PVector.fromAngle(angle);
    applyForce(force);
  }

  void turn(float a) {
    heading += a;
  }

  void edges() {
    if ((location.x > width) || (location.x < 0)) velocity.x *= -1;
    if ((location.y > height) || (location.y < 0)) velocity.y *= -1;
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    pushMatrix();
    translate(location.x, location.y);
    rotate(heading);
    fill(175);
    ellipse(0, 0, size, size);
    ellipse(0, -30, size/2, size/2);
    popMatrix();
  }

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

