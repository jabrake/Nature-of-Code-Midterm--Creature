import java.util.Iterator;
import ddf.minim.*;

Minim minim;
AudioPlayer squeal;
AudioPlayer ribbit;
AudioPlayer jump;
AudioPlayer buzz;
AudioPlayer win;
Creature creature;
ArrayList<Food> foods;
boolean jumped;
boolean strengthUp;
boolean buzzPlayed;
int counter;
float strength = 60;
float timeCounter, timePassed, timeCounter2, timePassed2, totalCounter;
PImage fly, frog;

void setup() {
  size(800, 800);
  creature = new Creature();
  foods = new ArrayList<Food>(); 
  minim = new Minim(this);

  //Fly Counter
  counter = 100;

  //Image Files
  fly = loadImage("fly.png");
  frog = loadImage("frog.png");

  //Audio Files
  squeal = minim.loadFile("squeal.wav");
  ribbit = minim.loadFile("ribbit.wav");
  jump = minim.loadFile("jump.wav");
  buzz = minim.loadFile("buzz.wav");
  win = minim.loadFile("win.wav");

  for (int i = 0; i < 100; i++) {
    foods.add(new Food(new PVector(random(width), random(height))));
  }

  ribbit.play();
}

void draw() {
  background(139, 198, 255);

  //Time Counters
  timePassed = millis() - timeCounter;
  timePassed2 = millis() - timeCounter2;
  totalCounter = millis();

  //Buzz Sound Control
  if (!buzzPlayed) {
    buzz.play();
    timeCounter2 = millis();
    buzzPlayed = true;
  }
  if (timePassed2 > 18500) {
    buzz.rewind();
    buzzPlayed = false;
  }

  //Control Flow for Increased Repel Force
  switch(counter) {
  case 100:
    strength = 60;
    break;

  case 90:
    strength = 70;
    break;

  case 80:
    strength = 80;
    break;

  case 70:
    strength = 90;
    break;

  case 60:
    strength = 100;
    break;

  case 50:
    strength = 110;
    break;

  case 40:
    strength = 120;
    break;

  case 30:
    strength = 130;
    break;

  case 20:
    strength = 140;
    break;

  case 10:
    strength = 150;
    break;
  }

  //Run Frog
  creature.run();

  //Run Flies
  Iterator<Food> it = foods.iterator();
  while (it.hasNext ()) {
    Food f = it.next();
    f.run();
    PVector force = creature.repel(f);
    f.applyForce(force);
    f.die(creature);

    if (f.isDead()) {
      it.remove();
      counter --;
      squeal.play();
      squeal.rewind();
    }
  }

  //Game Controls
  if (keyPressed) {
    if (key == CODED && keyCode == LEFT) {
      creature.turn(-0.05);
    } 

    else if (key == CODED && keyCode == RIGHT) {
      creature.turn(0.05);
    }

    else if (key == CODED && keyCode == UP) {
      creature.crawl();
    }

    else if (key == CODED && keyCode == DOWN) {
      creature.backwards();
    }
  }

  //Game Panel
  pushMatrix();
  fill(0);
  rect(0, 0, width, 40);
  popMatrix();

  //Counter Panel
  pushMatrix();
  fill(255);
  rect(10, 5, 80, 30);
  popMatrix();

  //Counter Text
  pushMatrix();
  fill(0);
  text("Flies: " + counter, 20, 25);
  popMatrix();

  image(frog, width/2, 5, 30, 30);

  //Jump Panel 
  if (!jumped) {
    fill(0, 255, 0);
    rect(700, 5, 70, 30);
    pushMatrix();
    fill(0);
    text("JUMP", 720, 25);
    popMatrix();
  } 
  else {
    fill(255, 0, 0);
    rect(700, 5, 70, 30);
    pushMatrix();
    fill(0);
    text("JUMP", 720, 25);
    popMatrix();
  }

  //Game Over Condition
  if (counter == 90) {
    gameOver();
  }
}

//Jump Command
void keyPressed() {
  if (key == ' ' && !jumped) {
    jump.play();
    creature.jump();
    timeCounter = millis();
    jumped = true;
  }
}

//Jump Reset
void keyReleased() {
  if (timePassed > 5000) {
    jumped = false;
    jump.rewind();
  }
}

//Game Over State
void gameOver() {
  pushMatrix();
  noStroke();
  fill(139, 198, 255);
  rect(0, 40, width, height-40);
  popMatrix();
  fill(0);
  text("GAME OVER! You beat the game in " + totalCounter, width/2-140, height/2);
  buzz.pause();
  win.play();
  noLoop();
}

