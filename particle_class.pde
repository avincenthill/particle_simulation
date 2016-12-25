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
  
  float charge = 1;
  float bindingEnergy;
  
  float elasticity = 0.7;
  float mu = 0.99;
  float drag = 0.99;
  
  float agingRate = 0;
  float lifespan;
  int collidedWith;
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
    lifespan = 100;
    mass = random(1000,150000);
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
    acceleration.mult(0);
    
    //updates momentum
    momentum = velocity.copy().mult(mass);
    
    //updates KE
    kineticEnergy = abs(0.5*mass*velocity.magSq());
    
    //updates density and radius
    radius = (float)Math.cbrt((double)((3*mass*density)/(4*PI)));
  }

  //bounces particles off the edges of the area, constrains position to sim volume, adds mu to sliding on boundary
  void bounceOffEdges(){
    if ((position.x + radius >= simEdgeMag) || (position.x - radius <= -simEdgeMag)) {
      velocity.x = elasticity*velocity.x * -1;
      velocity.y = mu*velocity.y;
      velocity.z = mu*velocity.z;
      position.x = constrain(position.x, -simEdgeMag + radius, simEdgeMag - radius);
    }
    if ((position.y + radius >= simEdgeMag) || (position.y - radius <= -simEdgeMag)) {
      velocity.y = elasticity*velocity.y * -1;
      velocity.x = mu*velocity.x;
      velocity.z = mu*velocity.z;
      position.y = constrain(position.y, -simEdgeMag + radius, simEdgeMag - radius);
    }
    if ((position.z + radius >= simEdgeMag) || (position.z - radius <= -simEdgeMag)) {
      velocity.z = elasticity*velocity.z * -1;
      velocity.x = mu*velocity.x;
      velocity.y = mu*velocity.y;
      position.z = constrain(position.z, -simEdgeMag + radius, simEdgeMag - radius);
    }
  }
  
  //collision event specified in particle system
  void collide(Particle otherParticle){
    //registers which particle bounced with which
    collidedWith = otherParticle.id;
    otherParticle.collidedWith = id;
    //registers collision in time
    lastCollideFrame = frameCount;
    otherParticle.lastCollideFrame = frameCount;
    
    //collision diognostics
    //TBD: fix why particles not colliding anymore
    //println("Bang!  @ " + frameCount);
  }
  
  //bounces particles
  void bounce(Particle otherParticle){
    //swaps particles velocities
    PVector tempVelocity = velocity;
    velocity = otherParticle.velocity.mult(elasticity);
    otherParticle.velocity = tempVelocity.mult(elasticity);
    
    PVector interparticleDistance = PVector.sub(otherParticle.position,position);
    interparticleDistance.setMag((radius + otherParticle.radius)/2 - 0.5);
    otherParticle.position.add(interparticleDistance);
    
  }

  //ages particle
  void age(){
    lifespan -= agingRate;
  }

  //displays particle
  void display() {
    
    //lowers sphere detail
    sphereDetail(20);
    
    pushMatrix();
       
    //fills with hue and saturation preportional to KE
    hValue = constrain(map(log(kineticEnergy), log(pow(10,5)), log(pow(10,9)), 270, 360), 225, 360);
    sValue = constrain(100 - map(log(kineticEnergy), log(pow(10,7)), log(pow(10,9)), 0, 100), 0, 100);
    fill(hValue, sValue, bValue);
    
    //draws particle as a sphere
    noStroke();
    translate(position.x, position.y, position.z);
    sphere(radius);

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