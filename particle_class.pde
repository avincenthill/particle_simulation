// Based on code by Daniel Shiffman
// Alex Vincent-Hill

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  float density = 1;
  PVector momentum;
  float kineticEnergy;
  float charge;
  float elasticity = 0.9;
  float mu = 0.99;
  float drag = 0.999;
  float radius;
  float[] RGBcolor = {255,255,255};
  float agingRate = 0;
  float lifespan;
  int id;
  int collidedWith;
  int lastCollideFrame;
  int physicsCooldown = 2;
  float bindingEnergy;

  //Particle constructor
  Particle(int setID) {
    position = new PVector(random(-450,450),random(-450,450),random(-450,450));
    velocity = new PVector(random(-10,10), random(-10,10), random (-10,10));
    acceleration = new PVector(0,0,0);
    lifespan = 100;
    mass = random(100000,300000);
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
    kineticEnergy = abs(0.5*mass*pow(velocity.mag(),2));
    
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
    inelasticCollision(otherParticle);
  }
  
  //inelastic collision physics
  void inelasticCollision(Particle otherParticle){
    if (inelasticCollisionsToggle && otherParticle.momentum != null && this.momentum != null && this.radius <= 100 && otherParticle.radius <= 100) {
      otherParticle.lifespan = 0;
      this.mass = this.mass + otherParticle.mass;
      this.momentum.add(otherParticle.momentum);
      this.velocity = this.momentum.div(this.mass);
      collidedWith = otherParticle.id;
      otherParticle.collidedWith = id;
    }
  }
  
  //bounces particles
  void bounce(Particle otherParticle){
    if ((this.radius > 100 && otherParticle.radius > 100) || !inelasticCollisionsToggle) {
      //swaps particles velocities
      PVector tempVelocity = velocity;
      velocity = otherParticle.velocity.mult(elasticity);
      otherParticle.velocity = tempVelocity.mult(elasticity);
      
      PVector interparticleDistance = PVector.sub(otherParticle.position,position);
      interparticleDistance.setMag((radius + otherParticle.radius)/2 - 0.5);
      otherParticle.position.add(interparticleDistance);
      
      collidedWith = otherParticle.id;
      otherParticle.collidedWith = id;
      
      
      lastCollideFrame = frameCount;
      otherParticle.lastCollideFrame = frameCount;
    }
  }

  //ages particle
  void age(){
    lifespan -= agingRate;
  }

  //displays points with particles properties
  void display() {
    
    //lowers sphere detail
    sphereDetail(20);
    
    pushMatrix();
       
    //draws particle as a sphere
    fill(map(log(kineticEnergy), 5, 25, 225, 360), 100 - map(log(kineticEnergy), 5, 25, 0, 100), 100);
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