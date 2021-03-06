// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class ProductC extends Particle {
  //Particle constructor
  ProductC(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    super(setID, initialPos, initialVel, initialMass);
  }

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
    decompose(0.001);
  }

  void decompose(float chance) {
    if (Math.random() < chance) {

      Particle reactantA = new ReactantA(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), this.mass/2);
      ps.particleList.add(reactantA);
      Particle reactantB = new ReactantB(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), this.mass/2);
      ps.particleList.add(reactantB);
      Explosion explosion = new Explosion(ps.particleList.size(), this.position.add(0, 0, 0), new PVector(0, 0, 0), 10000);
      ps.particleList.add(explosion);

      //deletes both particles
      this.life = 0;
    }
  }

  void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills yellow
    fill(45, 100, 100);
    //draws particle as a sphere
    noStroke();
    //constrains particles to bounds before render
    position = new PVector (constrain(position.x, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.y, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.z, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius));
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}
