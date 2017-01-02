// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class Explosion extends Particle {
  //Explosion constructor
  Explosion(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    super(setID, initialPos, initialVel, initialMass);
    //class variables to change from Particle
    this.deletesOnWalls = false;
    this.bouncesOffParticles = false;
    this.bouncesOffWalls = false;
    this.agingRate = 1;
    this.life = 5;
    this.mass = 100000;
    this.hue = 45;
  }

  void applyForce(PVector force) {
    //can't apply external forces
  }

  //updates explosion properties, zeroes acceleration, adds drag to velocity
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
    //updates density and radius, expands scaled by life
    radius = life*(float)Math.cbrt((double)((3*mass*density)/(4*PI)));
    //becomes redder with age
    hue = 9*life;
  }

  void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills yellow
    fill(hue, 100, 100);
    //draws particle as a sphere
    noStroke();
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}