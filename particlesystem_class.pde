// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class ParticleSystem {
  //system variables
  PVector origin = new PVector (0, 0, 0);

  float pressure;
  float temperature;
  float sumKE;
  int numSmoothingFrames = 10;
  //DescriptiveStatistics avgTemperature;
  //DescriptiveStatistics avgPressure;


  //creates ArrayList of Particles
  ArrayList<Particle> particleList;

  //constructs particle system
  ParticleSystem() {
    //constructs particleList
    particleList = new ArrayList<Particle>();
    //avgTemperature = new DescriptiveStatistics(numSmoothingFrames);
    //avgPressure = new DescriptiveStatistics(numSmoothingFrames);
  }

  //adds n particles to ArrayList particleList
  void addParticles(int n) {
    for (int i = 0; i < n; i++) {
      particleList.add(new FissionableParticle (particleList.size()));
      particleList.add(new Neutron (particleList.size()));
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

  //float calcTemperature() {
  //  avgTemperature.add(sumKE/particleList.size());
  //  println(avgTemperature.getAverage());
  //  return avgTemperature.getAverage();
  //}

  //float calcPressure(float numFrames){
  //float pressure = ((particleList.size()*idealGasConstant*temperature)/volume)*pow(10, 3);
  //}
}

////rolling average class from (http://stackoverflow.com/questions/3793400/is-there-a-function-in-java-to-get-moving-average)
//public class Rolling {

//    private int size;
//    private float total = 0f;
//    private int index = 0;
//    private float samples[];

//    public Rolling(int size) {
//        this.size = size;
//        samples = new float[size];
//        for (int i = 0; i < size; i++) samples[i] = 0f;
//    }

//    public void add(float x) {
//        total -= samples[index];
//        samples[index] = x;
//        println(samples);
//        total += x;
//        println(total);
//        if (++index == size) index = 0; // cheaper than modulus
//    }

//    public float getAverage() {
//        return (float)(total / size);
//    }   
//}