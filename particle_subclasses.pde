// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

//TBD: make sure fissioned mass is half fissionable - 2 neutron masses

class FissionableParticle extends Particle {
  //class variables to change from Particle
  float mass;
  float radius;
  boolean fissionable = true;

  //FissionableParticle constructor
  FissionableParticle(int setID) {
    super(setID);
  }
}

class Neutron extends Particle {
  //class variables to change from Particle
  float mass;
  float radius;
  boolean deletesOnWalls = true;

  //Neutron constructor
  Neutron(int setID) {
    super(setID);
  }
}

class DrDevice extends Particle {
  //class variables to change from Particle
  float mass;
  float radius;

  //DrDevice constructor
  DrDevice(int setID) {
    super(setID);
  }
}