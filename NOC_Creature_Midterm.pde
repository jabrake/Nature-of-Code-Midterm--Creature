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
boolean gameStarted;
int counter;
float strength = 60;
float size = 50;
float timeCounter, timePassed, timeCounter2, timePassed2, totalCounter;
PImage fly, frog;

void setup() {
  size(800, 800);

  //Initialize Classes and Minim Library
  creature = new Creature();
  foods = new ArrayList<Food>(); 
  minim = new Minim(this);

  noCursor();

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

  //Add 100 "Food" objects
  for (int i = 0; i < 100; i++) {
    foods.add(new Food(new PVector(random(width), random(height))));
  }
}

void draw() {
  gamePanel();
  gameStart();

  if (keyPressed) {
    if (key == ENTER || key == RETURN) {
      gameStarted = true;
    }
  }

  if (gameStarted) {
    runGame();
  }
}

void runGame() {
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
    size = 55;
    ribbit.rewind();
    ribbit.play();
    break;

  case 80:
    strength = 80;
    size = 60;
    ribbit.rewind();
    ribbit.play();
    break;

  case 70:
    strength = 90;
    size = 65;
    ribbit.rewind();
    ribbit.play();
    break;

  case 60:
    strength = 100;
    size = 70;
    ribbit.rewind();
    ribbit.play();
    break;

  case 50:
    strength = 110;
    size = 75;
    ribbit.rewind();
    ribbit.play();
    break;

  case 40:
    strength = 120;
    size = 80;
    ribbit.rewind();
    ribbit.play();
    break;

  case 30:
    strength = 130;
    size = 85;
    ribbit.rewind();
    ribbit.play();
    break;

  case 20:
    strength = 140;
    size = 90;
    ribbit.rewind();
    ribbit.play();
    break;

  case 10:
    strength = 150;
    size = 95;
    ribbit.rewind();
    ribbit.play();
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

  gamePanel();

  //Game Over Condition
  if (counter == 0) {
    gameOver();
    gameStarted = false;
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

//Game Start State
void gameStart() {

  ribbit.play();
  pushMatrix();
  noStroke();
  fill(139, 198, 255);
  rect(0, 40, width, height-40);
  popMatrix();
  fill(0);
  text("You are Hubert, a handicapped frog.", width/2-100, height/2-100);
  text("You were born without a tongue so you must walk and hop to feed yourself.", width/2-220, height/2-50);
  text("Use the arrow keys to move and the spacebar to jump.", width/2-150, height/2);
  text("Press Enter/Return to start eating!", width/2-100, height/2+50);

  if (keyPressed) {
    if (key == 'n') {
      println("pressed enter!");
      ribbit.rewind();
      ribbit.play();
      fill(139, 198, 255, 100);
    }
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
  text("FOOD COMA! You beat the game in " + totalCounter + " seconds!", width/2-140, height/2);
  buzz.pause();
  win.play();
  noLoop();
}

void gamePanel() {
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
}

