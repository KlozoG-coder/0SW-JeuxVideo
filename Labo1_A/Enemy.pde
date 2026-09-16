class Enemy extends GraphicObject {

  // Point d'attache au plafond
  PVector anchor;

  // Position de repos
  PVector restPosition;

  // Ressort
  float restLength = 170;
  float maxLength = 300;
  
  float k = 0.02;

  // Distances
  float activationDistance;
  float deactivationDistance;

  boolean active = false;

  float size = 70;

  Enemy(float x, float y) {
    // Position initiale de l'ennemi
    super(x, y + 170);

    // Point d'attache
    anchor = new PVector(x, y);

    // Position de repos
    restPosition = new PVector(x, y + restLength);
  }
  
  // DISTANCE
  void setDistance(float activation, float deactivation) {

    activationDistance = activation;

    deactivationDistance = deactivation;
  }
  
  // FORCE ÉLASTIQUE
  void applyElasticForce() {

    PVector force = PVector.sub(position, anchor);
    
    float length = force.mag();
    
    if (length > 0) {

      float stretch = length - restLength;

      force.normalize();

      // Loi de Hooke (F = -k * x)
      force.mult(-k * stretch);
      
      applyForce(force);
    }
  }
  
  // ATTRACTION VERS LE JOUEUR
  void attract(Player player) {

    PVector force = PVector.sub(player.position, position);
    
    if (force.mag() > 0) {

      force.normalize();

      force.mult(1.3);

      applyForce(force);
    }
  }

  // RETOUR AU REPOS
  void returnToRest() {

    PVector force = PVector.sub(restPosition, position);

    force.mult(0.03);

    applyForce(force);
  }
  
  // LONGUEUR MAXIMALE
  void constrainLength() {

    PVector direction = PVector.sub(position, anchor);

    float distance = direction.mag();
    
    if (distance > maxLength) {

      direction.normalize();

      direction.mult(maxLength);

      position = PVector.add(anchor, direction);

      velocity.mult(0.5);
    }
  }

  // UPDATE
  void update(Player player) {

    // Distance entre le joueur et la position de repos
    float distance = PVector.dist(player.position, restPosition);
    
    // ACTIVATION
    if (!active && distance < activationDistance) {

      active = true;
    }
    
    // DÉSACTIVATION
    if (active &&
        distance > deactivationDistance) {

      active = false;
    }
    
    // FORCE ÉLASTIQUE
    applyElasticForce();

    // ACTIF / REPOS

    if (active) {

      // Attaque le joueur
      attract(player);

    } else {

      // Retourne au repos
      returnToRest();
    }
    
    velocity.add(acceleration);
    
    // Amortissement
    if (active) {
      velocity.mult(0.96);

    } else {

      velocity.mult(0.90);
    }
    
    position.add(velocity);

    // Remise à zéro des forces
    acceleration.mult(0);
    
    // Longueur maximale
    constrainLength();

    // IMMOBILE AU REPOS
    if (!active) {

      float d = PVector.dist(position, restPosition);

      if (d < 2 && velocity.mag() < 0.2) {

        position.set(restPosition);

        velocity.set(0, 0);

        acceleration.set(0, 0);
      }
    }
  }
  
  // CERCLE
  void displayZone() {

    noFill();

    stroke(100);
    strokeWeight(1);

    ellipse(restPosition.x, restPosition.y, deactivationDistance * 2, deactivationDistance * 2);
  }
  
  void display() {

    // Élastique
    stroke(0);
    strokeWeight(2);

    line(anchor.x, anchor.y, position.x, position.y);
    
    // Point d'attache
    fill(150);

    ellipse( anchor.x, anchor.y, 16, 16);
    
    // Ennemi
    stroke(0);
    strokeWeight(2);
    
    if (active) {
      // Affecté par le joueur
      fill(150);

    } else {

      // Au repos = VERT
      fill(0, 255, 0);
    }
    ellipse(position.x, position.y, size, size);
  }
}
