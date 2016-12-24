// Based on code by Daniel Shiffman
// Alex Vincent-Hill

class ParticleSystem {
  PVector origin;
  
  //creates ArrayList of Particles
  ArrayList<Particle> particleList;
  
  //constructs particle system
  ParticleSystem(){
      //constructs particleList
      particleList = new ArrayList<Particle>();
  }

  //adds n particles to ArrayList particleList
  void addParticle(int n) {
      for (int i = 0; i < n; i++) {
        particleList.add(new Particle());
    }
  }
  
  //updates particle system
  void psrun() {
    //applies run method to every Particle in particleList
    for (int i = particleList.size()-1; i >= 0; i--) {
      Particle p = particleList.get(i);
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