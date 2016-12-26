// Based on code by Daniel Shiffman
// Alex Vincent-Hill

class ParticleSystem {
  //system variables
  PVector origin;
  
  //TBD: make temperature a function of particle system
  float temperature;
  float pressure;
  
  //creates ArrayList of Particles
  ArrayList<Particle> particleList;
  
  //constructs particle system
  ParticleSystem(){
      //constructs particleList
      particleList = new ArrayList<Particle>();
  }

  //adds n particles to ArrayList particleList
  void addParticles(int n) {
      for (int i = 0; i < n; i++) {
        particleList.add(new Particle(i));
    }
  }
  
  //removes one particle (given by index) from ArrayList particleList
  void removeParticle(int i) {
    if (i >= 0 && i <= particleList.size()-1){
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
    //applies run method to every Particle in particleList
    for (int i = particleList.size()-1; i >= 0; i--) {
      Particle p = particleList.get(i);
      
      //sums all kinetic energies of particles in particleList
      temperature += p.kineticEnergy;

      //interacts particle p with otherParticle
      for (int j = particleList.size()-1; j >= 0; j--) {
        Particle otherParticle = particleList.get(j);
        
        float distBetweenParticles = p.position.dist(otherParticle.position);
        if (distBetweenParticles <= p.radius + otherParticle.radius &&
            p.lastCollideFrame + p.physicsCooldown <= frameCount){
            p.collide(otherParticle);
            p.bounce(otherParticle);
        }
      }
      
      //averages summed KEs to get system temperature
      temperature = round(temperature/particleList.size());
      
      //uses ideal gas law to calculate pressure
      pressure = round((particleList.size()*idealGasConstant*temperature)/volume);
      
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