// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class DrDevice extends Particle {
  boolean disrupting = false;

  //DrDevice constructor
  DrDevice(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    //class variables to change from Particle
    super(setID, initialPos, initialVel, initialMass);
    this.life = 50;
    this.agingRate = 1;
    this.radius = 20;
    this.hue = 100;

    //non-interacting
    this.deletesOnWalls = false;
    this.bouncesOffParticles = false;
    this.bouncesOffWalls = false;
    this.subjectToForces = false;
  }

  public void collide(Particle otherParticle) {
    //chance of disruption
    if (!(otherParticle instanceof DrDevice)) {
      disrupt(otherParticle, 1);
    }
  }

  //updates DrDevice particles properties, zeroes acceleration, adds drag to velocity
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

    //changes properties during MDD reaction
    if (this.disrupting) {
      this.hue -= this.agingRate*2;
      this.radius += this.agingRate*5;
    }
  }


  void disrupt(Particle otherParticle, float chance) {

    if (Math.random() < chance) {
      disrupting = true;
      DrDevice newDrDevice = new DrDevice(ps.particleList.size(), otherParticle.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(0, 0, 0), this.mass);
      ps.particleList.add(newDrDevice);
      newDrDevice.disrupting = true;

      //deletes otherParticle
      //this.life = 0;
      otherParticle.life = 0;
    }
  }

  void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills yellow
    fill(hue, 100, 100);
    //draws particle as a sphere
    noStroke();
    //constrains particles to bounds before render
    //position = new PVector (constrain(position.x, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.y, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.z, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius));
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}