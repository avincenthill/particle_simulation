// Based on code by Daniel Shiffman //<>// //<>//
// Alex Vincent-Hill and Roberto Nunez

class Particle {
  int id;

  PVector position;
  PVector velocity;
  PVector acceleration;

  float mass;
  float radius;
  float density = 1;
  PVector momentum;
  float kineticEnergy;
  float gravitationalPotentialEnergy;

  float charge = 1;
  float bindingEnergy;

  //friction losses
  float elasticity = 0.95;
  float coefficientSlidingFriction = 0.999;
  float drag = 1;

  float agingRate = 0;
  float life = 100;
  
  boolean bouncesOffWalls = true;
  boolean deletesOnWalls = false;
  boolean fissionable = false;

  //Particle constructor
  Particle(int setID) {
    position = new PVector(0, 0, 0);
    velocity = new PVector(random(-10, 10), random(-10, 10), random (-10, 10));
    acceleration = new PVector(0, 0, 0);
    mass = random(1000, 100000);
    id = setID;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  //executes methods on particles
  void run() {
    age();
    
    if (bouncesOffWalls){
      bounceOffWalls();
    }
    
    if (deletesOnWalls){
      deleteOnWalls();
    }
    
    update();
    display();
  }

  //updates particles properties, zeroes acceleration, adds drag to velocity
  void update() {
    velocity.add(acceleration);
    velocity.mult(drag);
    position.add(velocity);

    //clears acceleration for next loop
    acceleration.mult(0);

    //updates momentum
    momentum = velocity.copy().mult(mass);

    //updates velocity?
    velocity = momentum.copy().mult(1/mass);

    //updates KE (1/2mv^2)
    kineticEnergy = abs(0.5*mass*velocity.magSq());

    //updates GPE (mgh)
    gravitationalPotentialEnergy = mass * gravitationalConstant * ((halfSimSize)-position.y);

    //updates density and radius
    radius = (float)Math.cbrt((double)((3*mass*density)/(4*PI)));
  }

  //bounces particles off the walls of the area, constrains position to sim volume, adds coefficientSlidingFriction to sliding on boundary
  void bounceOffWalls() {
    if ((position.x + radius >= adjustedHalfSimSize) || (position.x - radius <= -adjustedHalfSimSize)) {
      velocity.x = elasticity*velocity.x * -1;
      velocity.y = coefficientSlidingFriction*velocity.y;
      velocity.z = coefficientSlidingFriction*velocity.z;
      position.x = constrain(position.x, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius);
    }
    if ((position.y + radius >= adjustedHalfSimSize) || (position.y - radius <= -adjustedHalfSimSize)) {
      velocity.y = elasticity*velocity.y * -1;
      velocity.x = coefficientSlidingFriction*velocity.x;
      velocity.z = coefficientSlidingFriction*velocity.z;
      position.y = constrain(position.y, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius);
    }
    if ((position.z + radius >= adjustedHalfSimSize) || (position.z - radius <= -adjustedHalfSimSize)) {
      velocity.z = elasticity*velocity.z * -1;
      velocity.x = coefficientSlidingFriction*velocity.x;
      velocity.y = coefficientSlidingFriction*velocity.y;
      position.z = constrain(position.z, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius);
    }
  }
  
  void deleteOnWalls() {
    if (((position.x + radius >= adjustedHalfSimSize) || (position.x - radius <= -adjustedHalfSimSize)) || 
    ((position.y + radius >= adjustedHalfSimSize) || (position.y - radius <= -adjustedHalfSimSize)) ||
    ((position.z + radius >= adjustedHalfSimSize) || (position.z - radius <= -adjustedHalfSimSize)))
    
      life = 0;
  }

  //collision event specified in particle system
  void collide(Particle otherParticle) {
    //println("Bang! @ " + frameCount);
  }

  //bounces particles
  void bounce(Particle otherParticleB) {
    //temp variables for collision math
    float bounceTotalMassAB = mass + otherParticleB.mass;
    float bounceTotalRadius = radius + otherParticleB.radius;

    //temp velocity vectors for collision math
    PVector initialVelocityA = velocity.copy();
    PVector initialVelocityB = otherParticleB.velocity.copy();
    PVector initialPositionA = position.copy();
    PVector initialPositionB = otherParticleB.position.copy();

    //makes sure particles aren't overlapping after collision
    PVector interparticleDistanceAB = PVector.sub(initialPositionB, initialPositionA);
    interparticleDistanceAB.setMag(bounceTotalRadius);
    otherParticleB.position = initialPositionA.add(interparticleDistanceAB);

    //MIT solution to conserve KE and momentum (http://web.mit.edu/8.01t/www/materials/modules/chapter15.pdf)
    velocity = initialVelocityA.copy().mult((mass - otherParticleB.mass)/bounceTotalMassAB).copy().add(initialVelocityB.copy().mult((2 * otherParticleB.mass)/bounceTotalMassAB)).copy().mult(elasticity);
    otherParticleB.velocity = initialVelocityB.copy().mult((otherParticleB.mass - mass)/bounceTotalMassAB).copy().add(initialVelocityA.copy().mult((2 * mass)/bounceTotalMassAB)).copy().mult(elasticity);
  }

  //ages particle by agingRate
  void age() {
    life -= agingRate;
  }

  //displays particle
  void display() {

    //lowers sphere detail
    sphereDetail(20);

    pushMatrix();

    //fills with hue and saturation preportional to kineticEnergy
    fillColorBy(kineticEnergy,log(pow(10, 5)),log(pow(10, 9)),log(pow(10, 7)),log(pow(10, 9)));
    
    //draws particle as a sphere
    noStroke();
    translate(position.x, position.y, position.z);
    sphere(radius);

    popMatrix();
  }

  //makes particle isDead if life is <= 0
  boolean isDead() {
    if (life<=0) {
      return true;
    } else {
      return false;
    }
  }
}