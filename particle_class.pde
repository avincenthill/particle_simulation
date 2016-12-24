// Based on code by Daniel Shiffman
// Alex Vincent-Hill

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  float density;
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

  Particle() {
    position = new PVector(random(-450,450),random(-450,450),random(-450,450));
    velocity = new PVector(random(-10,10), random(-10,10), random (-10,10));
    acceleration = new PVector(0,0,0);
    lifespan = 100;
    mass = random(20,50);
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
    kineticEnergy = 0.5*mass*pow(velocity.mag(),2);
    
    //updates density and radius
    density = mass/radius;
    radius = mass;
    
    println(kineticEnergy);
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
  
  void collide(Particle otherParticle){
  }
  
  //bounces particles
  void bounce(Particle otherParticle){
    //swaps particles velocities
    PVector tempVelocity = velocity;
    velocity = otherParticle.velocity.mult(elasticity);
    otherParticle.velocity = tempVelocity.mult(elasticity);
    
    PVector interparticleDistance = PVector.sub(otherParticle.position,position);
    interparticleDistance.setMag((radius + otherParticle.radius)/2);
    otherParticle.position.add(interparticleDistance);
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
    fill(map(kineticEnergy, 0, 20000, 180, 360), map(kineticEnergy, 0, 20000, 100, 0), 100);
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