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
  
  float elasticity = 0.95;
  float mu = 0.999;
  float drag = 1;
  
  float agingRate = 0;
  float life;
  int lastCollideFrame;
  int physicsCooldown = 2;
  
  float hValue;
  float sValue;
  float bValue = 100;
  
  //Particle constructor
  Particle(int setID) {
    position = new PVector(random(-450,450),random(-450,450),random(-450,450));
    velocity = new PVector(random(-10,10), random(-10,10), random (-10,10));
    acceleration = new PVector(0,0,0);
    life = 100;
    mass = random(1000,100000);
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
    acceleration.mult(.5);
    
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
  //TBD: conserve momentum, make physical
  void bounce(Particle otherParticle){
    //swaps particles velocities
    PVector tempVelocity = velocity;
    velocity = otherParticle.velocity;
    otherParticle.velocity = tempVelocity;
    
    ////swaps particles momentums
    //PVector tempMomentum = momentum;
    //velocity = otherParticle.momentum;
    //otherParticle.momentum = tempMomentum;
    
    PVector interparticleDistance = PVector.sub(otherParticle.position,position);
    interparticleDistance.setMag((radius + otherParticle.radius)/2 - 0.5);
    otherParticle.position.add(interparticleDistance);
    
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