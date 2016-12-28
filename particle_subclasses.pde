// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

//TBD: make sure fissioned mass is half fissionable - 2 neutron masses

class FissionableParticle extends Particle {
  //FissionableParticle constructor
  FissionableParticle(int setID) {
    //class variables to change from Particle
    super(setID);
    this.fissionable = true;
  }
  
  void collision(Particle otherParticle){
    if (otherParticle instanceof Neutron){
      fission((Neutron) otherParticle);
    }
  }
  
  //TBD: not printing fizz
  void fission(Neutron neutron){
    //TBD: make fission physics
    println("fizz @ " + frameCount);
  }
}

class Neutron extends Particle {
  //Neutron constructor
  Neutron(int setID) {
    super(setID);
    //class variables to change from Particle
    this.deletesOnWalls = true;
    this.bouncesOffParticles = false;
    this.mass = 1000;
  }
}

class DrDevice extends Particle {
  //DrDevice constructor
  DrDevice(int setID) {
    super(setID);
    //class variables to change from Particle
  }
}