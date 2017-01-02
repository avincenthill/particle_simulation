// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class Neutron extends Particle {
  //Neutron constructor
  Neutron(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    super(setID, initialPos, initialVel, initialMass);
    //class variables to change from Particle
    this.deletesOnWalls = false;
    this.bouncesOffParticles = false;
    this.bouncesOffWalls = false;
    this.subjectToForces = false;
    this.agingRate = 1;
    this.life = 100;
    this.mass = 10000;
  }

  void applyForce(PVector force) {
    //can't apply external forces
  }

  void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills yellow
    fill(54, 100, 100);
    //draws particle as a sphere
    noStroke();
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}