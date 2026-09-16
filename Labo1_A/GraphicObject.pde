abstract class GraphicObject {

  PVector position;
  PVector velocity;
  PVector acceleration;

  GraphicObject(float x, float y) {

    position = new PVector(x, y);

    velocity = new PVector(0, 0);

    acceleration = new PVector(0, 0);
  }

  void applyForce(PVector force) {

    acceleration.add(force);
  }
  
  abstract void display();
}
