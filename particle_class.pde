// Based on code by Daniel Shiffman
// Alex Vincent-Hill

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  float density;
  float momentum;
  float charge;
  float elasticity = 0.9;
  float radius;
  float[] RGBcolor = {255,255,255};
  float agingRate = 0;
  float lifespan;

  Particle() {
    position = new PVector(random(-450,450),random(-450,450),random(-450,450));
    velocity = new PVector(random(-10,10), random(-10,10), random (-10,10));
    acceleration = new PVector(0,0,0);
    lifespan = 100;
    mass = random(1,20);
    momentum = velocity.mag()*mass;
    density = mass/radius;
    radius = mass;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  //executes methods on particles
  void run() {
    bounceOffEdges();
    update();
    age();
    display();
  }

  //updates particles positions and velocities, zeroes acceleration
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
  }

  //bounces particles off the edges of the area
  void bounceOffEdges(){
    float simEdgeMag = 0.9*(simSize/2);
    if ((position.x > simEdgeMag) || (position.x < -simEdgeMag)) {
    velocity.x = elasticity*velocity.x * -1;
    }
    if ((position.y > simEdgeMag) || (position.y < -simEdgeMag)) {
      velocity.y = elasticity*velocity.y * -1;
    }
    if ((position.z > simEdgeMag) || (position.z < -simEdgeMag)) {
      velocity.z = elasticity*velocity.z * -1;
    }
  }

  //ages particle
  void age(){
    lifespan -= agingRate;
  }

  //displays points with particles properties
  void display() {
    pushMatrix();
    //colors particles with scaled velocity
    RGBcolor[1] = velocity.mag()*25;
    RGBcolor[2] = velocity.mag()*25;
    stroke(RGBcolor[0], RGBcolor[1], RGBcolor[2]);
    strokeWeight(radius);
    point(position.x, position.y, position.z);
    popMatrix();
  }
  
  boolean isDead() {
    if (lifespan<=0){
      return true;
    }
    else {
    return false;
    }
  }
}