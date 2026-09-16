Player player;
Enemy enemy;

boolean leftPressed = false;
boolean rightPressed = false;

void setup() {
  size(1000, 700);

  // Ennemi attaché au plafond
  enemy = new Enemy(width / 2, 70);

  // Distance activation / désactivation
  enemy.setDistance(330, 370);

  // Joueur en bas et dans la zone au départ
  player = new Player(width / 2 + 100, 500);
}


void draw() {
  background(255);

  // UPDATE
  player.update();
  enemy.update(player);

  // DISPLAY
  enemy.displayZone();
  enemy.display();
  player.display();

  fill(0);
  textAlign(CENTER);
  textSize(20);
  text("Labo1", width / 2, 30);
}

// CLAVIER
void keyPressed() {

  if (key == 'a' || key == 'A') {
    leftPressed = true;
  }

  if (key == 'd' || key == 'D') {
    rightPressed = true;
  }
}

void keyReleased() {

  if (key == 'a' || key == 'A') {
    leftPressed = false;
  }

  if (key == 'd' || key == 'D') {
    rightPressed = false;
  }
}
