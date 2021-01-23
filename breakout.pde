import java.util.List;
import java.util.Arrays;

class Level {
  Paddle paddle = new Paddle();
  Ball ball = new Ball();
  List<Brick> bricks = new ArrayList();
  
  Level() {
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 5; j++) {
        bricks.add(new Brick(50 * i + 10, 30 * j + 10));
      }
    }
  }
}

class Rectangle {
  float x;
  float y;
  float w;
  float h;
}

class Brick extends Rectangle {
  Brick(float x, float y) {
    this.x = x;
    this.y = y;
    w = 40;
    h = 20;
  }
  
  void updateAndDraw() {
    fill(255, 51, 0);
    noStroke();
    rect(x, y, w, h);
  }
}

class Paddle extends Rectangle {
 
  Paddle() {
    x = 10;
    y = height - 20;
    w = 100;
    h = 10;
  }
  
  
  void updateAndDraw() {
    x = mouseX - (w / 2);
    x = max(x, 10);
    x = min(x, width - 10 - w);
    
    stroke(100);
    colorMode(HSB, 100);
    fill(x / width * 100, 100, 100);
    rect(x, y, w, h);
    colorMode(RGB, 255);
  }
}

class Ball {
  float x = width / 2;
  float y = height / 2;
  float r = 10;
  float speedX = 1.5;
  float speedY = 2;
  
  void updateAndDraw() {
    x += speedX;
    y += speedY;
    
    // Level collison
    if (x < r || x > width - r) {
      speedX *= -1;
    }
    if (y < r  || y > height - r) {
      speedY *= -1;
    }
    
    detectCollision(level.paddle);
    Brick destroyedBrick = null;
    for (Brick brick : level.bricks) {
      if (detectCollision(brick)) {
        destroyedBrick = brick;
        break;
      }
    }
    if (destroyedBrick != null) {
      level.bricks.remove(destroyedBrick);
    }
    
    fill(255);
    stroke(50);
    ellipseMode(RADIUS);
    ellipse(x, y, r, r);
  }
  
  boolean detectCollision(Rectangle rect) {
    // http://jeffreythompson.org/collision-detection/circle-rect.php
    
    // temporary variables to set edges for testing
    float testX = x;
    float testY = y;
  
    // which edge is closest?
    if (x < rect.x)             testX = rect.x;          // test left edge
    else if (x > rect.x+rect.w) testX = rect.x+rect.w;   // right edge
    if (y < rect.y)             testY = rect.y;          // top edge
    else if (y > rect.y+rect.h) testY = rect.y+rect.h;   // bottom edge
  
    // get distance from closest edges
    float distX = x - testX;
    float distY = y - testY;
    float distance = sqrt( (distX*distX) + (distY*distY) );
  
    // if the distance is less than the radius, collision!
    if (distance <= r) {
      if (distY >= distX) speedX *= -1;
      else speedY *= -1;
      return true;
    }
    return false;
  }
}

Level level;

void setup() {
  size(800, 600);
  smooth(8);
  level = new Level();
}

void draw() {
  background(255);
  
  level.paddle.updateAndDraw();
  level.ball.updateAndDraw();
  for (Brick brick : level.bricks) {
    brick.updateAndDraw();
  }
}
