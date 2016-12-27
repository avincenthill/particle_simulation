// Based on code by Daniel Shiffman
// Alex Vincent-Hill

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
  float elasticity = 0.8;
  float mu = 0.999;
  float drag = 1;
  
  float agingRate = 0;
  float life;
  
  float hValue;
  float sValue;
  float bValue = 100;
  
  //Particle constructor
  Particle(int setID) {
    position = new PVector(random(-450,450),random(-450,450),random(-450,450));
    velocity = new PVector(random(-10,10), random(-10,10), random (-10,10));
    acceleration = new PVector(0,0,0);
    life = 100;
    mass = 50000;
    id = setID;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  //executes methods on particles
  void run() {
    age();
    bounceOffEdges();
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

  //bounces particles off the edges of the area, constrains position to sim volume, adds mu to sliding on boundary
  void bounceOffEdges(){
    if ((position.x + radius >= adjustedHalfSimSize) || (position.x - radius <= -adjustedHalfSimSize)) {
      velocity.x = elasticity*velocity.x * -1;
      velocity.y = mu*velocity.y;
      velocity.z = mu*velocity.z;
      position.x = constrain(position.x, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius);
    }
    if ((position.y + radius >= adjustedHalfSimSize) || (position.y - radius <= -adjustedHalfSimSize)) {
      velocity.y = elasticity*velocity.y * -1;
      velocity.x = mu*velocity.x;
      velocity.z = mu*velocity.z;
      position.y = constrain(position.y, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius);
    }
    if ((position.z + radius >= adjustedHalfSimSize) || (position.z - radius <= -adjustedHalfSimSize)) {
      velocity.z = elasticity*velocity.z * -1;
      velocity.x = mu*velocity.x;
      velocity.y = mu*velocity.y;
      position.z = constrain(position.z, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius);
    }
  }
  
  //collision event specified in particle system
  void collide(Particle otherParticle){
    //println("Bang! @ " + frameCount);
  }
  
  //bounces particles
  void bounce(Particle otherParticleB){
    //temp variables for collision math
    float bounceTotalMassAB = mass + otherParticleB.mass;
    float bounceReducedMassAB = (mass * otherParticleB.mass)/(mass + otherParticleB.mass);
    float bounceTotalRadius = radius + otherParticleB.radius;
    
    //temp velocity vectors for collision math
    PVector initialVelocityA = velocity.copy();
    PVector initialVelocityB = otherParticleB.velocity.copy();
    PVector initialPositionA = position.copy();
    PVector initialPositionB = otherParticleB.position.copy();
 //<>//
    //makes sure particles aren't overlapping after collision
    PVector interparticleDistanceAB = PVector.sub(initialPositionB, initialPositionA);
    interparticleDistanceAB.setMag(bounceTotalRadius);
    otherParticleB.position = initialPositionA.add(interparticleDistanceAB);
    PVector interparticleDistanceBA = PVector.sub(initialPositionA, initialPositionB);
    interparticleDistanceBA.setMag(bounceTotalRadius);
    position = initialPositionB.add(interparticleDistanceBA); //<>//
    
    //wikipedia solution to vector collisions (https://en.wikipedia.org/wiki/Elastic_collision)
    //float dotProductAB = initialVelocityA.sub(initialVelocityB).dot(interparticleDistanceAB);
    //float dotProductBA = initialVelocityB.sub(initialVelocityA).dot(interparticleDistanceBA);
    //float posDifMagSqAB = pow(initialPositionB.sub(initialPositionA).mag(),2);
    //float posDifMagSqBA = pow(initialPositionA.sub(initialPositionB).mag(),2);
    //float collMassScalarAB = (2*otherParticleB.mass)/bounceTotalMassAB;
    //float collMassScalarBA = (2*mass)/bounceTotalMassAB;
    //velocity = initialVelocityA.sub(interparticleDistanceAB.mult(collMassScalarAB*(dotProductAB/posDifMagSqAB)));
    //otherParticleB.velocity = initialVelocityB.sub(interparticleDistanceBA.mult(collMassScalarBA*(dotProductBA/posDifMagSqBA)));
    
    //MIT solution to conserve KE and momentum (http://web.mit.edu/8.01t/www/materials/modules/chapter15.pdf)
    //velocity = initialVelocityA.mult((mass - otherParticleB.mass)/bounceTotalMassAB).add(initialVelocityB.mult((2 * otherParticleB.mass)/bounceTotalMassAB)).mult(elasticity);
    //otherParticleB.velocity = initialVelocityB.mult((otherParticleB.mass - mass)/bounceTotalMassAB).add(initialVelocityA.mult((2 * mass)/bounceTotalMassAB)).mult(elasticity);

    //velocity swapping solution
    velocity = PVector.mult(initialVelocityB,elasticity);
    otherParticleB.velocity = PVector.mult(initialVelocityB,elasticity);
  }

  //ages particle by agingRate
  void age(){
    life -= agingRate;
  }

  //displays particle
  void display() {
    
    //lowers sphere detail
    sphereDetail(20);
    
    pushMatrix();
       
    //fills with hue and saturation preportional to kineticEnergy
    hValue = constrain(map(log(kineticEnergy), log(pow(10,4)), log(pow(10,8)), 270, 360), 225, 360);
    sValue = constrain(100 - map(log(kineticEnergy), log(pow(10,6)), log(pow(10,8)), 0, 100), 0, 100);
    fill(hValue, sValue, bValue);
    
    //draws particle as a sphere
    noStroke();
    translate(position.x, position.y, position.z);
    sphere(radius);

    popMatrix();
  }
  
  //makes particle isDead if life is <= 0
  boolean isDead() {
    if (life<=0){
      return true;
    }
    else {
    return false;
    }
  }
}