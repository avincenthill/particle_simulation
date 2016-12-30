// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class FissionableParticle extends Particle {
  //FissionableParticle constructor
  FissionableParticle(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    //class variables to change from Particle
    super(setID, initialPos, initialVel, initialMass);
    this.fissionable = true;
  }

  public void collide(Particle otherParticle) {
    //chance of fission
    if (otherParticle instanceof Neutron) {
      fission((Neutron) otherParticle, 1);
    }
  }

  //updates fissionable particles properties, zeroes acceleration, adds drag to velocity
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
    //fissile material decays with a small chance every run cycle
    fissionDecay(0.00001);
  }
  
  //adds random decay (creating a neutron at current position, creating fission collision reaction)
  void fissionDecay(float chance){
      if (Math.random() < chance) {
        Neutron neutron1 = new Neutron(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), 1000);
        ps.particleList.add(neutron1);
    }
  }

  void fission(Neutron neutron, float chance) {
    //TBD: make fission physical
    if (Math.random() < chance){
      this.fissionable = false;
      Particle fissionProduct1 = new Particle(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), this.mass/2);
      ps.particleList.add(fissionProduct1);
      Particle fissionProduct2 = new Particle(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), this.mass/2);
      ps.particleList.add(fissionProduct2);
      Neutron neutron1 = new Neutron(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), 1000);
      ps.particleList.add(neutron1);
      Neutron neutron2 = new Neutron(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), 1000);
      ps.particleList.add(neutron2);
      Explosion explosion = new Explosion(ps.particleList.size(), this.position.add(0, 0, 0), new PVector(0, 0, 0), 10000);
      ps.particleList.add(explosion);
      //deletes both neutron and fissionable particle
      this.life = 0;
      neutron.life = 0;
    }
  }

  void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills yellow
    fill(135, 100, 100);
    //draws particle as a sphere
    noStroke();
    //constrains particles to bounds before render
    position = new PVector (constrain(position.x, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.y, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.z, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius));
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}