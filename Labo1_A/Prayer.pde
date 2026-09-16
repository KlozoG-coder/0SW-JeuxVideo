class Player extends GraphicObject {

  float speed = 5;
  float size = 50;

  Player(float x, float y) {

    super(x, y);
  }
  
  void update() {

    // A = gauche
    if (leftPressed) {
      position.x -= speed;
    }
    // D = droite
    if (rightPressed) {
      position.x += speed;
    }
    position.x = constrain(position.x, size / 2, width - size / 2);
  }

  void display() {
    
    rectMode(CENTER);

    stroke(0);
    strokeWeight(2);

    fill(255, 0, 0);

    rect(position.x, position.y, size, size);
  }
}
