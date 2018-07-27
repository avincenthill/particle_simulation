// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class ParticleSystem {
  //system variables
  PVector origin = new PVector (0, 0, 0);
  float pressure = 0;
  float temperature = 0f;
  float sumKE;
  int numSmoothingFrames = 100;
  DescriptiveStatistics avgTemperature;
  DescriptiveStatistics avgPressure;
  //creates ArrayList of Particles
  ArrayList<Particle> particleList;
  //constructs particle system
  ParticleSystem() {
    //constructs particleList
    particleList = new ArrayList<Particle>();
    avgTemperature = new DescriptiveStatistics(numSmoothingFrames);
    avgPressure = new DescriptiveStatistics(numSmoothingFrames);
  }

  //adds n particles to ArrayList particleList
  void addParticles(int n) {
    for (int i = 0; i < n; i++) {
      particleList.add(new Particle (
        particleList.size(), //ID
        new PVector(0, 0, 0), //position
        new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), //velocity
        100000
        )
        );
    }
  }

  void addFissionableParticles(int n) {
    for (int i = 0; i < n; i++) {
      particleList.add(new FissionableParticle (
        particleList.size(), //ID
        new PVector(0, 0, 0), //position
        new PVector(random(-1, 1), random(-1, 1), random (-1, 1)), //velocity
        100000
        )
        );
    }
  }

  void addReactants(int n) {
    for (int i = 0; i < n; i++) {
      particleList.add(new ReactantA (
        particleList.size(), //ID
        new PVector(-adjustedHalfSimSize, -adjustedHalfSimSize, -adjustedHalfSimSize), //position
        new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), //velocity
        100000
        )
        );
    }
    for (int j = 0; j < n; j++) {
      particleList.add(new ReactantB (
        particleList.size(), //ID
        new PVector(adjustedHalfSimSize, adjustedHalfSimSize, adjustedHalfSimSize), //position
        new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), //velocity
        100000
        )
        );
    }
  }

  //adds a neutron to simulation
  void addNeutron() {
    particleList.add(new Neutron (
      particleList.size(), 
      new PVector(-adjustedHalfSimSize, -adjustedHalfSimSize, -adjustedHalfSimSize), 
      new PVector(random(8, 12), random(8, 12), random(8, 12)), 
      1000
      )
      );
  }

  //adds a DrDevice particle to simulation
  void addDrDevice() {
    particleList.add(new DrDevice (
      particleList.size(), 
      new PVector(-adjustedHalfSimSize, -adjustedHalfSimSize, -adjustedHalfSimSize), 
      new PVector(random(8, 12), random(8, 12), random(8, 12)), 
      10000
      )
      );
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
        if (distBetweenParticles <= (p.radius + otherParticle.radius) &&
          p.id != otherParticle.id
          ) {
          p.collide(otherParticle);
          p.bounce(otherParticle);
        }
      }
      //runs particles
      p.run();
      //removes dead particles
      if (p.isDead()) {
        particleList.remove(i);
      }
      //setting running average of temperatures and pressures
      temperature = calcTemperature();
      pressure = calcPressure();
    }
  }

  //applies forces to the particle system
  void applyForce(PVector force) {
    for (Particle p : particleList) {
      p.applyForceToParticle(force);
    }
  }

  //calculates smoothed metrics with apache DescriptiveStatistics
  float calcTemperature() {
    avgTemperature.addValue(sumKE/particleList.size());
    return (float) avgTemperature.getMean();
  }
  float calcPressure() {
    avgPressure.addValue(((particleList.size()*idealGasConstant*temperature)/volume)*pow(10, 3));
    return (float) avgPressure.getMean();
  }
}
