ArrayList<Star> galaxy; 
double shipSpeed = 1; 
int numOfStars = 3000;
int numOfUFOs = 100;

void setup() {
  size(960, 640);
  background(0);
  noStroke();
  galaxy = new ArrayList<Star>();
  for (int i = 0; i < numOfStars; i++) {
    Star currentStar = new Star(); 
    galaxy.add(currentStar);
  }
  for (int i = 0; i < numOfUFOs; i++) {
    Alien currentAlien = new Alien(); 
    galaxy.add(currentAlien);
  }
}

void draw() {
  background(0);
  fill(255);
  // text("ship speed: " + shipSpeed, width/2-35, 20);  
  for (Star star : galaxy) {
    star.show();
    star.move();
  }

  for (int i = galaxy.size() - 1; i >= 0; i--) {
    if (!galaxy.get(i).onScreen()) {
      if (galaxy.get(i) instanceof Alien) {
        galaxy.remove(i);
        galaxy.add(new Alien(1000));
      } else {
        galaxy.remove(i);
        galaxy.add(new Star(1000));
      }
    }
  }
}

void keyPressed() {
  if (key == 'w') {
    for (Star star : galaxy) {
      star.vDistFromPath += 0.3;
    }
  }
  if (key == 'a') {
    for (Star star : galaxy) {
      star.hDistFromPath += 0.3;
    }
  }
  if (key == 's') {
    for (Star star : galaxy) {
      star.vDistFromPath -= 0.3;
    }
  }
  if (key == 'd') {
    for (Star star : galaxy) {
      star.hDistFromPath -= 0.3;
    }
  }
  if (keyCode == UP) {
    shipSpeed += 0.01;
  }
  if (keyCode == DOWN) {
    shipSpeed -= 0.01;
  }
  if (keyCode == RIGHT) {
    shipSpeed += 1;
  }
  if (keyCode == LEFT) {
    shipSpeed -= 1;
  }
}

class Star {
  double x, y, speed, diameter;
  double hDistFromPath, vDistFromPath, distFromShip, projectionConstant;
  float a;

  Star() {
    vDistFromPath = (Math.random()-0.5)*1000;
    hDistFromPath = (Math.random()-0.5)*1000;
    distFromShip = Math.random()*1000;
    updateVariables();
  }
  
  Star(double distFromShip_) {
    this();
    distFromShip = distFromShip_ * (1 + (Math.random() - 0.5) * 0.1);
    updateVariables();
  }
  
  void move() {
    if (distFromShip > 0) {
      distFromShip -= shipSpeed;
    }
    updateVariables();
  }

  void updateVariables() {
    a = (float)(256 - map((float)distFromShip, 0, 1000, 0, 256));
    diameter = 1000 / (dist(0, 0, 0, (float)hDistFromPath, (float)vDistFromPath, (float)distFromShip) + 1);
    projectionConstant = 1 / (sqrt((float)(hDistFromPath * hDistFromPath + vDistFromPath * vDistFromPath + distFromShip * distFromShip)));
    x = width * hDistFromPath * projectionConstant + width/2;
    y = height * vDistFromPath * projectionConstant + height/2;
  }
  
  void show() {
    fill(255, 255, 255, a);
    ellipse((float)x, (float)y, (float)diameter, (float)diameter);
  }
  

  
  boolean onScreen() {
    if (-1 * diameter/2 < x && x < width + diameter/2 && -1 * diameter/2 < y && y < height + diameter/2 && distFromShip >= 0) {
      return true;
    } else {
      return false;
    }
  }
}

class Alien extends Star {
  double wiggleSpeed;
  Alien() {
    wiggleSpeed = 1;
  }
  
  Alien(double distFromShip_) {
    distFromShip = distFromShip_ * (1 + (Math.random() - 0.5) * 0.1);
    wiggleSpeed = 1;
  }
  
  void move() {
    if (distFromShip > 0) {
      distFromShip -= shipSpeed;
    }
    updateVariables();
    
    distFromShip += (Math.random() - 0.5) * wiggleSpeed;
    hDistFromPath += (Math.random() - 0.5) * wiggleSpeed;
    vDistFromPath += (Math.random() - 0.5) * wiggleSpeed;
  }
  
  void show() {
    fill(0, 150 + 20*sin((float)distFromShip / 5), 0); 
    ellipse((float)x, (float)y, (float)diameter/2, (float)diameter);
    fill(120, 120, 120);
    ellipse((float)x, (float)(y + diameter/4), (float)diameter, (float)diameter/2);
    fill(0, 150 + 20*sin((float)distFromShip / 5), 0);
    ellipse((float)x, (float)y, (float)diameter/2, (float)diameter/4);
  }
}
