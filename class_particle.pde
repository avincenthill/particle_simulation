// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

public class Particle {
  int id;
  int numSmoothingFrames = 5;
  DescriptiveStatistics avgKE;
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector momentum;
  float mass;
  float radius;
  float density = 1;
  float kineticEnergy;
  float gravitationalPotentialEnergy;
  float charge = 0;
  float bindingEnergy;
  float elasticity = 0.99;
  float coefficientSlidingFriction = 1;
  float drag = 1;
  float agingRate = 0;
  float life = 100;
  float hue;
  boolean bouncesOffParticles = true;
  boolean bouncesOffWalls = true;
  boolean deletesOnWalls = false;
  boolean subjectToForces = true;
  boolean fissionable = false;

  //Particle constructor
  Particle(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    position = initialPos.copy();
    velocity = initialVel.copy();
    acceleration = new PVector(0, 0, 0);
    mass = initialMass;
    id = setID;
    avgKE = new DescriptiveStatistics(numSmoothingFrames);
  }

  void applyForceToParticle(PVector force) {
    if (this.subjectToForces) {
      acceleration.add(force);
    }
  }

  //executes methods on particles
  void run() {
    //ages particle
    age();
    if (bouncesOffWalls) {
      bounceOffWalls();
    }
    if (deletesOnWalls) {
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
    avgKE.addValue(abs(0.5*mass*velocity.magSq()));
    kineticEnergy = (float) avgKE.getMean();
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
    }
    if ((position.y + radius >= adjustedHalfSimSize) || (position.y - radius <= -adjustedHalfSimSize)) {
      velocity.y = elasticity*velocity.y * -1;
      velocity.x = coefficientSlidingFriction*velocity.x;
      velocity.z = coefficientSlidingFriction*velocity.z;
    }
    if ((position.z + radius >= adjustedHalfSimSize) || (position.z - radius <= -adjustedHalfSimSize)) {
      velocity.z = elasticity*velocity.z * -1;
      velocity.x = coefficientSlidingFriction*velocity.x;
      velocity.y = coefficientSlidingFriction*velocity.y;
    }
  }

  void deleteOnWalls() {
    if (((position.x + radius >= adjustedHalfSimSize) || (position.x - radius <= -adjustedHalfSimSize)) || 
      ((position.y + radius >= adjustedHalfSimSize) || (position.y - radius <= -adjustedHalfSimSize)) ||
      ((position.z + radius >= adjustedHalfSimSize) || (position.z - radius <= -adjustedHalfSimSize))) {
      life = 0;
    }
  }

  //collision event specified in particle system
  public void collide(Particle otherParticle) {
  }

  //bounces particles
  public void bounce(Particle otherParticleB) {
    if (bouncesOffParticles && otherParticleB.bouncesOffParticles) {
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
      otherParticleB.position = initialPositionA.copy().add(interparticleDistanceAB);
      //MIT solution to conserve KE and momentum (http://web.mit.edu/8.01t/www/materials/modules/chapter15.pdf), TBD: confirm momentum is conserved in bounce
      velocity = initialVelocityA.copy().mult((mass - otherParticleB.mass)/bounceTotalMassAB).copy().add(initialVelocityB.copy().mult((2 * otherParticleB.mass)/bounceTotalMassAB)).copy().mult(elasticity);
      otherParticleB.velocity = initialVelocityB.copy().mult((otherParticleB.mass - mass)/bounceTotalMassAB).copy().add(initialVelocityA.copy().mult((2 * mass)/bounceTotalMassAB)).copy().mult(elasticity);
    }
  }

  //ages particle by agingRate each run cycle
  void age() {
    life -= agingRate;
  }

  //displays particle
  void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills with hue and saturation preportional to kineticEnergy
    fillColorBy(kineticEnergy, log(pow(10, 5)), log(pow(10, 9)), log(pow(10, 7)), log(pow(10, 9)));
    //draws particle as a sphere
    noStroke();
    //constrains particles to bounds before render
    position = new PVector (constrain(position.x, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.y, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.z, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius));
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