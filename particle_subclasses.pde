// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

//TBD: make sure fissioned mass is half fissionable - 2 neutron masses

class FissionableParticle extends Particle{
  
  //FissionableParticle constructor
  FissionableParticle(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    //class variables to change from Particle
    super(setID, initialPos, initialVel, initialMass);
    this.fissionable = true;
  }
  
  public void collide(Particle otherParticle){
    if (otherParticle instanceof Neutron){
      fission((Neutron) otherParticle);
    }
}
  
  void fission(Neutron neutron){
    //TBD: make fission physics
    this.fissionable = false;
    Particle fissionProduct1 = new Particle(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)),this.mass/2);
    ps.particleList.add(fissionProduct1);
    Particle fissionProduct2 = new Particle(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)),this.mass/2);
    ps.particleList.add(fissionProduct2);
    Neutron neutron1 = new Neutron(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)),1000);
    ps.particleList.add(neutron1);
    Neutron neutron2 = new Neutron(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)),1000);
    ps.particleList.add(neutron2);
    Explosion explosion = new Explosion(ps.particleList.size(), this.position.add(0,0,0),new PVector(0,0,0),10000);
    ps.particleList.add(explosion);
    
    //deletes both neutron and fissionable particle
    this.life = 0;
    neutron.life = 0;
  }
  
  void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills yellow
    fill(135,100,100);
    //draws particle as a sphere
    noStroke();
    //constrains particles to bounds before render
    //TBD: make this a function of PVector
    position.x = constrain(position.x, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius);
    position.y = constrain(position.y, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius);
    position.z = constrain(position.z, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius);
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}

class Neutron extends Particle {
  
  //Neutron constructor
  Neutron(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    super(setID, initialPos, initialVel, initialMass);
    //class variables to change from Particle
    this.deletesOnWalls = false;
    this.bouncesOffParticles = false;
    this.bouncesOffWalls = false;
    this.agingRate = 1;
    this.life = 100;
    this.mass = 1000;
  }
  
  void applyForce(PVector force) {
    //can't apply external forces
  }
  
  void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills yellow
    fill(54,100,100);
    //draws particle as a sphere
    noStroke();
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}

class Explosion extends Particle {
  
  //Explosion constructor
  Explosion(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    super(setID, initialPos, initialVel, initialMass);
    //class variables to change from Particle
    this.deletesOnWalls = false;
    this.bouncesOffParticles = false;
    this.bouncesOffWalls = false;
    this.agingRate = 1;
    this.life = 3;
    this.mass = 100000;
  }
  
  void applyForce(PVector force) {
    //can't apply external forces
  }
  
  void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills yellow
    fill(360,100,100);
    //draws particle as a sphere
    noStroke();
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}