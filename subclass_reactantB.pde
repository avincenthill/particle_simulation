// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class ReactantB extends Particle {
  //Particle constructor
  ReactantB(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    super(setID, initialPos, initialVel, initialMass);
  }

  void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills red
    fill(360, 100, 100);
    //draws particle as a sphere
    noStroke();
    //constrains particles to bounds before render
    position = new PVector (constrain(position.x, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.y, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.z, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius));
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}