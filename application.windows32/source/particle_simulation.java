import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import peasy.*; 
import peasy.org.apache.commons.math.*; 
import peasy.org.apache.commons.math.geometry.*; 

import org.apache.commons.math3.ml.neuralnet.*; 
import org.apache.commons.math3.ml.neuralnet.twod.*; 
import org.apache.commons.math3.ml.neuralnet.twod.util.*; 
import org.apache.commons.math3.ml.neuralnet.oned.*; 
import org.apache.commons.math3.ml.neuralnet.sofm.*; 
import org.apache.commons.math3.ml.neuralnet.sofm.util.*; 
import org.apache.commons.math3.ml.clustering.*; 
import org.apache.commons.math3.ml.clustering.evaluation.*; 
import org.apache.commons.math3.ml.distance.*; 
import org.apache.commons.math3.analysis.*; 
import org.apache.commons.math3.analysis.differentiation.*; 
import org.apache.commons.math3.analysis.integration.*; 
import org.apache.commons.math3.analysis.integration.gauss.*; 
import org.apache.commons.math3.analysis.function.*; 
import org.apache.commons.math3.analysis.polynomials.*; 
import org.apache.commons.math3.analysis.solvers.*; 
import org.apache.commons.math3.analysis.interpolation.*; 
import org.apache.commons.math3.stat.interval.*; 
import org.apache.commons.math3.stat.ranking.*; 
import org.apache.commons.math3.stat.clustering.*; 
import org.apache.commons.math3.stat.*; 
import org.apache.commons.math3.stat.inference.*; 
import org.apache.commons.math3.stat.correlation.*; 
import org.apache.commons.math3.stat.descriptive.*; 
import org.apache.commons.math3.stat.descriptive.rank.*; 
import org.apache.commons.math3.stat.descriptive.summary.*; 
import org.apache.commons.math3.stat.descriptive.moment.*; 
import org.apache.commons.math3.stat.regression.*; 
import org.apache.commons.math3.linear.*; 
import org.apache.commons.math3.*; 
import org.apache.commons.math3.distribution.*; 
import org.apache.commons.math3.distribution.fitting.*; 
import org.apache.commons.math3.complex.*; 
import org.apache.commons.math3.ode.*; 
import org.apache.commons.math3.ode.nonstiff.*; 
import org.apache.commons.math3.ode.events.*; 
import org.apache.commons.math3.ode.sampling.*; 
import org.apache.commons.math3.random.*; 
import org.apache.commons.math3.primes.*; 
import org.apache.commons.math3.optim.*; 
import org.apache.commons.math3.optim.linear.*; 
import org.apache.commons.math3.optim.nonlinear.vector.*; 
import org.apache.commons.math3.optim.nonlinear.vector.jacobian.*; 
import org.apache.commons.math3.optim.nonlinear.scalar.*; 
import org.apache.commons.math3.optim.nonlinear.scalar.gradient.*; 
import org.apache.commons.math3.optim.nonlinear.scalar.noderiv.*; 
import org.apache.commons.math3.optim.univariate.*; 
import org.apache.commons.math3.exception.*; 
import org.apache.commons.math3.exception.util.*; 
import org.apache.commons.math3.fitting.leastsquares.*; 
import org.apache.commons.math3.fitting.*; 
import org.apache.commons.math3.dfp.*; 
import org.apache.commons.math3.fraction.*; 
import org.apache.commons.math3.special.*; 
import org.apache.commons.math3.geometry.*; 
import org.apache.commons.math3.geometry.hull.*; 
import org.apache.commons.math3.geometry.enclosing.*; 
import org.apache.commons.math3.geometry.spherical.twod.*; 
import org.apache.commons.math3.geometry.spherical.oned.*; 
import org.apache.commons.math3.geometry.euclidean.threed.*; 
import org.apache.commons.math3.geometry.euclidean.twod.*; 
import org.apache.commons.math3.geometry.euclidean.twod.hull.*; 
import org.apache.commons.math3.geometry.euclidean.oned.*; 
import org.apache.commons.math3.geometry.partitioning.*; 
import org.apache.commons.math3.geometry.partitioning.utilities.*; 
import org.apache.commons.math3.optimization.*; 
import org.apache.commons.math3.optimization.linear.*; 
import org.apache.commons.math3.optimization.direct.*; 
import org.apache.commons.math3.optimization.fitting.*; 
import org.apache.commons.math3.optimization.univariate.*; 
import org.apache.commons.math3.optimization.general.*; 
import org.apache.commons.math3.util.*; 
import org.apache.commons.math3.genetics.*; 
import org.apache.commons.math3.transform.*; 
import org.apache.commons.math3.filter.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class particle_simulation extends PApplet {

// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

//TBD: build a clock that uses seconds
//TBD: put on the web with processing.js

//imports libraries




//TBD: import apache math

//n is the number of particles in the simulation
int n = 100;

//simulation variables
float simSize = 1000;
float halfSimSize = simSize/2;
float volumeFudgeFactor = 0.9f;
float volume = pow(simSize*volumeFudgeFactor, 3);
float adjustedHalfSimSize = volumeFudgeFactor*halfSimSize;
boolean gravityToggle = false;
float gravitationalConstant = 1;
float idealGasConstant = 1;

//text formatting
int textSize = 40;

//adds PeasyCam object
PeasyCam cam;

//declares particle system
ParticleSystem ps;

public void setup() {
  //sets window size and rendering mode
  

  //sets color mode
  colorMode(HSB, 360, 100, 100);

  //initializes cam and orients view
  simCam(cam);

  //starts background black
  background(0);

  //initializes particle system
  ps = new ParticleSystem();
}

public void draw() {
  //writes title
  writeTitle();

  //wipes background black
  background(0);

  //displays text in simulation area
  writeTextToSim(textSize);
  
  //draws box
  drawSimBox(halfSimSize);

  //runs particle system
  ps.psrun();

  //user I/O
  userIO();
}
// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

//TBD: make gravity toggle

//gravity
float gravityMag = 1;
PVector gravity = new PVector (0, gravityMag, 0);
PVector antigravity = new PVector (0, -gravityMag, 0);

//wind
PVector wwind = new PVector (0, -1, 0);
PVector awind = new PVector (-1, -1, -1);
PVector swind = new PVector (0, 1, 0);
PVector dwind = new PVector (1, 1, 1);

//TBD: interparticle charge
//TBD: electric fields
//TBD: 3D gravitational fields
// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class Particle {
  int id;

  PVector position;
  PVector velocity;
  PVector acceleration;

  float mass;
  float radius;
  float density = 1;
  PVector momentum;
  float kineticEnergy;
  float gravitationalPotentialEnergy;

  float charge = 1;
  float bindingEnergy;

  //friction losses
  float elasticity = 0.95f;
  float coefficientSlidingFriction = 0.999f;
  float drag = 1;

  float agingRate = 0;
  float life = 100;
  
  boolean bouncesOffParticles = true;
  boolean bouncesOffWalls = true;
  boolean deletesOnWalls = false;
  boolean fissionable = false;
  
  //data smoothing
  int numSmoothingFrames = 25;
  DescriptiveStatistics avgKE;

  //Particle constructor
  Particle(int setID) {
    position = new PVector(random(-100, 100), random(-100, 100), random(-100, 100));
    velocity = new PVector(random(-10, 10), random(-10, 10), random (-10, 10));
    acceleration = new PVector(0, 0, 0);
    mass = random(1000, 100000);
    id = setID;
    avgKE = new DescriptiveStatistics(numSmoothingFrames);
  }

  public void applyForce(PVector force) {
    acceleration.add(force);
  }

  //executes methods on particles
  public void run() {
    age();
    
    if (bouncesOffWalls){
      bounceOffWalls();
    }
    
    if (deletesOnWalls){
      deleteOnWalls();
    }
    
    update();
    display();
  }

  //updates particles properties, zeroes acceleration, adds drag to velocity
  public void update() {
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
    avgKE.addValue(abs(0.5f*mass*velocity.magSq()));
    kineticEnergy = (float) avgKE.getMean();

    //updates GPE (mgh)
    gravitationalPotentialEnergy = mass * gravitationalConstant * ((halfSimSize)-position.y);

    //updates density and radius
    radius = (float)Math.cbrt((double)((3*mass*density)/(4*PI)));
  }

  //bounces particles off the walls of the area, constrains position to sim volume, adds coefficientSlidingFriction to sliding on boundary
  public void bounceOffWalls() {
    if ((position.x + radius >= adjustedHalfSimSize) || (position.x - radius <= -adjustedHalfSimSize)) {
      velocity.x = elasticity*velocity.x * -1;
      velocity.y = coefficientSlidingFriction*velocity.y;
      velocity.z = coefficientSlidingFriction*velocity.z;
    }
    if ((position.y + radius >= adjustedHalfSimSize) || (position.y - radius <= -adjustedHalfSimSize)) {
      velocity.y = elasticity*velocity.y * -1;
      velocity.x = coefficientSlidingFriction*velocity.x;
      velocity.z = coefficientSlidingFriction*velocity.z;
    }
    if ((position.z + radius >= adjustedHalfSimSize) || (position.z - radius <= -adjustedHalfSimSize)) {
      velocity.z = elasticity*velocity.z * -1;
      velocity.x = coefficientSlidingFriction*velocity.x;
      velocity.y = coefficientSlidingFriction*velocity.y;
    }
  }
  
  public void deleteOnWalls() {
    if (((position.x + radius >= adjustedHalfSimSize) || (position.x - radius <= -adjustedHalfSimSize)) || 
    ((position.y + radius >= adjustedHalfSimSize) || (position.y - radius <= -adjustedHalfSimSize)) ||
    ((position.z + radius >= adjustedHalfSimSize) || (position.z - radius <= -adjustedHalfSimSize)))
    
      life = 0;
  }

  //collision event specified in particle system
  public void collide(Particle otherParticle) {
  }

  //bounces particles
  public void bounce(Particle otherParticleB) {
    if (bouncesOffParticles && otherParticleB.bouncesOffParticles){
      //temp variables for collision math
      float bounceTotalMassAB = mass + otherParticleB.mass;
      float bounceTotalRadius = radius + otherParticleB.radius;
  
      //temp velocity vectors for collision math
      PVector initialVelocityA = velocity.copy();
      PVector initialVelocityB = otherParticleB.velocity.copy();
      PVector initialPositionA = position.copy();
      PVector initialPositionB = otherParticleB.position.copy();
  
      //makes sure particles aren't overlapping after collision
      PVector interparticleDistanceAB = PVector.sub(initialPositionB, initialPositionA);
      interparticleDistanceAB.setMag(bounceTotalRadius);
      otherParticleB.position = initialPositionA.copy().add(interparticleDistanceAB);
  
      //MIT solution to conserve KE and momentum (http://web.mit.edu/8.01t/www/materials/modules/chapter15.pdf)
      velocity = initialVelocityA.copy().mult((mass - otherParticleB.mass)/bounceTotalMassAB).copy().add(initialVelocityB.copy().mult((2 * otherParticleB.mass)/bounceTotalMassAB)).copy().mult(elasticity);
      otherParticleB.velocity = initialVelocityB.copy().mult((otherParticleB.mass - mass)/bounceTotalMassAB).copy().add(initialVelocityA.copy().mult((2 * mass)/bounceTotalMassAB)).copy().mult(elasticity);
    }
  }

  //ages particle by agingRate
  public void age() {
    life -= agingRate;
  }

  //displays particle
  public void display() {

    //lowers sphere detail
    sphereDetail(20);

    pushMatrix();

    //fills with hue and saturation preportional to kineticEnergy
    fillColorBy(kineticEnergy,log(pow(10, 5)),log(pow(10, 9)),log(pow(10, 7)),log(pow(10, 9)));
    
    //draws particle as a sphere
    noStroke();
    
    //constrains particles to bounds before render
    position.x = constrain(position.x, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius);
    position.y = constrain(position.y, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius);
    position.z = constrain(position.z, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius);
    translate(position.x, position.y, position.z);
    
    sphere(radius);

    popMatrix();
  }

  //makes particle isDead if life is <= 0
  public boolean isDead() {
    if (life<=0) {
      return true;
    } else {
      return false;
    }
  }
}
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
  
  public void collision(Particle otherParticle){
    if (otherParticle instanceof Neutron){
      fission((Neutron) otherParticle);
    }
  }
  
  //TBD: not printing fizz
  public void fission(Neutron neutron){
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
  public void addParticles(int n) {
    for (int i = 0; i < n; i++) {
      particleList.add(new Particle (particleList.size()));
    }
  }

  //removes one particle (given by index) from ArrayList particleList
  public void removeParticle(int i) {
    if (i >= 0 && i <= particleList.size()) {
      particleList.remove(i);
    }
  }

  //removes all particles from ArrayList particleList
  public void removeAllParticles() {
    for (int i = particleList.size()-1; i >= 0; i--) {
      particleList.remove(i);
    }
  }

  //updates particle system
  public void psrun() {

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

      //setting running average of temperatures and pressures
      temperature = calcTemperature();
      pressure = calcPressure();

    }
  }

  //applies forces to the particle system
  public void applyForce(PVector force) {
    for (Particle p : particleList) {
      p.applyForce(force);
    }
  }

  public float calcTemperature() {
    avgTemperature.addValue(sumKE/particleList.size());
    return (float) avgTemperature.getMean();
  }

  public float calcPressure() {
    avgPressure.addValue(((particleList.size()*idealGasConstant*temperature)/volume)*pow(10, 3));
    return (float) avgPressure.getMean();
  }
}
// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

//TBD: graph pressure and temperature

//writes title with fps count and restart instructions
public void writeTitle() {
  surface.setTitle("Particle simulation running at " + PApplet.parseInt(frameRate) + " FPS.");
}

public void writeTextToSim(int textSize) {
  float[] textPos = {-500, -500, -500};
  fill(0, 0, 100);
  textSize(textSize*2);
  text("particle_simulation of", textPos[0], textPos[1]-(textSize)*14, textPos[2]);
  text(ps.particleList.size() + " particles.", textPos[0], textPos[1]-(textSize)*12, textPos[2]);
  textSize(textSize);
  text("  by Alex Vincent-Hill and Roberto Nunez", textPos[0], textPos[1]-(textSize)*11, textPos[2]);
  text("Frame " + frameCount + " of simulation running at " + round(frameRate) + " FPS.", textPos[0], textPos[1]-(textSize)*9, textPos[2]);
  text("Simulation temperature currently " + round(ps.temperature/10000), textPos[0], textPos[1]-(textSize)*8, textPos[2]);
  text("Simulation pressure currently " + round(ps.pressure), textPos[0], textPos[1]-(textSize)*7, textPos[2]);

  text("Hold \"q\" to add particles.", textPos[0], textPos[1]-(textSize)*5, textPos[2]);
  text("Press \"r\" to restart with " + n + " particles.", textPos[0], textPos[1]-(textSize)*4, textPos[2]);

  text("Hold \"SPACE\" to toggle gravity.", textPos[0], textPos[1]-(textSize)*2, textPos[2]);
  text("Hold \"w,a,s,d\" to add wind forces.", textPos[0], textPos[1]-(textSize)*1, textPos[2]);
}

//fills color by log(property) and user specified bounds of H and S
public void fillColorBy(float property, float lowerLimitH, float upperLimitH, float lowerLimitS, float upperLimitS) {
  float HValue = constrain(map(log(property), lowerLimitH, upperLimitH, 270, 360), 225, 360);
  float SValue = constrain(100 - map(log(property), lowerLimitS, upperLimitS, 0, 100), 0, 100);
  float BValue = 100;
  fill(HValue, SValue, BValue);
}

//strokes color by log(property) and user specified bounds of H and S
public void strokeColorBy(float property, float lowerLimitH, float upperLimitH, float lowerLimitS, float upperLimitS) {
  if (property > 0f) {
    float HValue = constrain(map(log(property), lowerLimitH, upperLimitH, 270, 360), 225, 360);
    float SValue = constrain(100 - map(log(property), lowerLimitS, upperLimitS, 0, 100), 0, 100);
    float BValue = 100;
    stroke(HValue, SValue, BValue);
  }
}

public void drawSimBox(float halfSimSize) {
  pushMatrix();

  //colors simulation box by temperature
  stroke(360,0,100);
  strokeColorBy(ps.temperature,14,17,14,17);
 
  //draws simulation box
  strokeWeight(5);
  line(halfSimSize, halfSimSize, halfSimSize, -halfSimSize, halfSimSize, halfSimSize);
  line(-halfSimSize, halfSimSize, halfSimSize, -halfSimSize, -halfSimSize, halfSimSize);
  line(-halfSimSize, -halfSimSize, halfSimSize, halfSimSize, -halfSimSize, halfSimSize);
  line(halfSimSize, -halfSimSize, halfSimSize, halfSimSize, halfSimSize, halfSimSize);
  line(halfSimSize, halfSimSize, -halfSimSize, -halfSimSize, halfSimSize, -halfSimSize);
  line(-halfSimSize, halfSimSize, -halfSimSize, -halfSimSize, -halfSimSize, -halfSimSize);
  line(-halfSimSize, -halfSimSize, -halfSimSize, halfSimSize, -halfSimSize, -halfSimSize);
  line(halfSimSize, -halfSimSize, -halfSimSize, halfSimSize, halfSimSize, -halfSimSize);
  line(halfSimSize, halfSimSize, halfSimSize, halfSimSize, halfSimSize, -halfSimSize);
  line(-halfSimSize, halfSimSize, halfSimSize, -halfSimSize, halfSimSize, -halfSimSize);
  line(-halfSimSize, -halfSimSize, halfSimSize, -halfSimSize, -halfSimSize, -halfSimSize);
  line(halfSimSize, -halfSimSize, halfSimSize, halfSimSize, -halfSimSize, -halfSimSize);

  popMatrix();
}

public void userIO() {
  //reinitializes n particles in particle system with "r" keypress
  if (keyPressed) {
    if (key == 'r') {
      //removes all particles
      ps.removeAllParticles();

      //adds n particles to particle system
      ps.addParticles(n);

      //resets camera view
      simCam(cam);
    }
  }

  //adds n particles with "a" keypress
  if (keyPressed) {
    if (key == 'q') {
      //adds n particles to particle system
      ps.addParticles(n/10);
    }
  }

  //applies wind force with "w,a,s,d" keypress
  if (keyPressed) {
    if (key == 'w') {
      ps.applyForce(wwind);
    }
  }
  if (keyPressed) {
    if (key == 'a') {
      ps.applyForce(awind);
    }
  }
  if (keyPressed) {
    if (key == 's') {
      ps.applyForce(swind);
    }
  }
  if (keyPressed) {
    if (key == 'd') {
      ps.applyForce(dwind);
    }
  }

  //removes gravity force with "SPACE" hold
  if (gravityToggle){
      ps.applyForce(gravity);
  }
}

public void keyReleased(){
  if (key == 32){
    gravityToggle = !gravityToggle;
  }
}

//initializes cam and orients view
public void simCam(PeasyCam cam) {
  cam = new PeasyCam(this, 2500);
  cam.rotateX(PI/6);
  cam.rotateY(-PI/6);
  cam.rotateZ(PI/12);
}
  public void settings() {  size(1500, 1500, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#000000", "--stop-color=#cccccc", "particle_simulation" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
