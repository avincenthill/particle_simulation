// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class ParticleSystem {
  //system variables
  PVector origin = new PVector (0, 0, 0);

  //TBD: make these lambda functions
  float temperature;
  float sumKE;
  float pressure;

  //creates ArrayList of Particles
  ArrayList<Particle> particleList;

  //constructs particle system
  ParticleSystem() {
    //constructs particleList
    particleList = new ArrayList<Particle>();
  }

  //adds n particles to ArrayList particleList
  void addParticles(int n) {
    for (int i = 0; i < n; i++) {
      particleList.add(new Particle(particleList.size()));
    }
  }

  //removes one particle (given by index) from ArrayList particleList
  void removeParticle(int i) {
    if (i >= 0 && i <= particleList.size()) {
      particleList.remove(i);
    }
  }

  //removes all particles from ArrayList particleList
  void removeAllParticles() {
    for (int i = particleList.size()-1; i >= 0; i--) {
      particleList.remove(i);
    }
  }

  //updates particle system
  void psrun() {

    //zero sumKEs
    sumKE = 0;

    //applies run method to every Particle in particleList
    for (int i = particleList.size()-1; i >= 0; i--) {
      Particle p = particleList.get(i);

      //sums all kinetic energies of particles in particleList
      sumKE += p.kineticEnergy;

      //interacts particle p with otherParticle
      for (int j = particleList.size()-1; j >= 0; j--) {
        Particle otherParticle = particleList.get(j);

        float distBetweenParticles = p.position.dist(otherParticle.position);
        if (distBetweenParticles <= p.radius + otherParticle.radius &&
          p.id != otherParticle.id
          ) {
          p.collide(otherParticle);
          p.bounce(otherParticle);
        }
      }

      //averages summed KEs to get system temperature
      temperature = sumKE/particleList.size();

      //uses ideal gas law to calculate pressure
      pressure = ((particleList.size()*idealGasConstant*temperature)/volume)*pow(10, 3);
      
      //TBD: smoothes pressure and temperature (and KE in Particle loop?)

      //runs particles
      p.run();

      //removes dead particles
      if (p.isDead()) {
        particleList.remove(i);
      }
    }
  }

  //applies forces to the particle system
  void applyForce(PVector force) {
    for (Particle p : particleList) {
      p.applyForce(force);
    }
  }
}