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
//TBD: make units physical
//TBD: make transmorph a function
//TBD: make bouncing on walls create a temperary sprite particle
//TBD: graph pressure and temperature

//imports libraries




//n is the number of particles in the simulation
int numberStartingParticles = 100;
int addingParticleRate = numberStartingParticles/100;

//simulation variables
float simSize = 1000;
float halfSimSize = simSize/2;
float volumeFudgeFactor = 0.95f;
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
  
  //smooth(3);
  
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

public class Particle {
  int id;
  int numSmoothingFrames = 5;
  DescriptiveStatistics avgKE;
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector momentum;
  float mass;
  float radius;
  float density = 1;
  float kineticEnergy;
  float gravitationalPotentialEnergy;
  float charge = 0;
  float bindingEnergy;
  float elasticity = 0.99f;
  float coefficientSlidingFriction = 1;
  float drag = 1;
  float agingRate = 0;
  float life = 100;
  float hue;
  boolean bouncesOffParticles = true;
  boolean bouncesOffWalls = true;
  boolean deletesOnWalls = false;
  boolean subjectToForces = true;
  boolean fissionable = false;

  //Particle constructor
  Particle(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    position = initialPos.copy();
    velocity = initialVel.copy();
    acceleration = new PVector(0, 0, 0);
    mass = initialMass;
    id = setID;
    avgKE = new DescriptiveStatistics(numSmoothingFrames);
  }

  public void applyForceToParticle(PVector force) {
    if (this.subjectToForces) {
      acceleration.add(force);
    }
  }

  //executes methods on particles
  public void run() {
    //ages particle
    age();
    if (bouncesOffWalls) {
      bounceOffWalls();
    }
    if (deletesOnWalls) {
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
      ((position.z + radius >= adjustedHalfSimSize) || (position.z - radius <= -adjustedHalfSimSize))) {
      life = 0;
    }
  }

  //collision event specified in particle system
  public void collide(Particle otherParticle) {
  }

  //bounces particles
  public void bounce(Particle otherParticleB) {
    if (bouncesOffParticles && otherParticleB.bouncesOffParticles) {
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
      //MIT solution to conserve KE and momentum (http://web.mit.edu/8.01t/www/materials/modules/chapter15.pdf), TBD: confirm momentum is conserved in bounce
      velocity = initialVelocityA.copy().mult((mass - otherParticleB.mass)/bounceTotalMassAB).copy().add(initialVelocityB.copy().mult((2 * otherParticleB.mass)/bounceTotalMassAB)).copy().mult(elasticity);
      otherParticleB.velocity = initialVelocityB.copy().mult((otherParticleB.mass - mass)/bounceTotalMassAB).copy().add(initialVelocityA.copy().mult((2 * mass)/bounceTotalMassAB)).copy().mult(elasticity);
    }
  }

  //ages particle by agingRate each run cycle
  public void age() {
    life -= agingRate;
  }

  //displays particle
  public void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills with hue and saturation preportional to kineticEnergy
    fillColorBy(kineticEnergy, log(pow(10, 5)), log(pow(10, 9)), log(pow(10, 7)), log(pow(10, 9)));
    //draws particle as a sphere
    noStroke();
    //constrains particles to bounds before render
    position = new PVector (constrain(position.x, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.y, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.z, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius));
    translate(position.x, position.y, position.z);
    drawViewFrustrum(velocity.copy());
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
  
  //TBD: mathmatical description of vison and pointing for particles
  public void drawViewFrustrum(PVector p1) {
    pushMatrix();
    
    stroke(255);
    
    /*
    beginShape();
    PVector d = p1.mult(20);
    vertex(0, 0, 0);
    vertex(0, -100, -100);
    vertex(0, 0, 100);

    vertex(0, 0, 0);
    vertex(100, 100, -100);
    vertex(0, 0, 100);

    vertex(0, 0, 0);
    vertex(-100, 100, -100);
    vertex(0, 0, 100);

    vertex(0, 0, 0);
    vertex(-100, -100, -100);
    vertex(0, 0, 100);
    endShape();
    */
    
    line(0, 0, 0, p1.x*10, p1.y*10, p1.z*10);
    
    noStroke();
    
    popMatrix();
  }

  //draws pointing vector line
  public void vectorLineTranslated(PVector p1) {
    pushMatrix();
    stroke(255);
    line(0, 0, 0, p1.x, p1.y, p1.z);
    noStroke();
    popMatrix();
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
      particleList.add(new Particle (
        particleList.size(), //ID
        new PVector(0, 0, 0), //position
        new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), //velocity
        100000
        )
        );
    }
  }

  public void addFissionableParticles(int n) {
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

  public void addReactants(int n) {
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
  public void addNeutron() {
    particleList.add(new Neutron (
      particleList.size(), 
      new PVector(-adjustedHalfSimSize, -adjustedHalfSimSize, -adjustedHalfSimSize), 
      new PVector(random(8, 12), random(8, 12), random(8, 12)), 
      1000
      )
      );
  }

  //adds a DrDevice particle to simulation
  public void addDrDevice() {
    particleList.add(new DrDevice (
      particleList.size(), 
      new PVector(-adjustedHalfSimSize, -adjustedHalfSimSize, -adjustedHalfSimSize), 
      new PVector(random(8, 12), random(8, 12), random(8, 12)), 
      10000
      )
      );
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
  public void applyForce(PVector force) {
    for (Particle p : particleList) {
      p.applyForceToParticle(force);
    }
  }

  //calculates smoothed metrics with apache DescriptiveStatistics
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

//writes title with fps count and restart instructions
public void writeTitle() {
  surface.setTitle("Particle simulation running at " + PApplet.parseInt(frameRate) + " FPS.");
}

//initializes cam and orients view
public void simCam(PeasyCam cam) {
  cam = new PeasyCam(this, 2500);
  cam.rotateX(PI/6);
  cam.rotateY(-PI/6);
  cam.rotateZ(PI/12);
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

public void writeTextToSim(int textSize) {
  float[] textPos = {-500, -500, -500};
  fill(0, 0, 100);
  textSize(textSize*2);
  text("particle_simulation of", textPos[0], textPos[1]-(textSize)*15, textPos[2]);
  text(ps.particleList.size() + " particles.", textPos[0], textPos[1]-(textSize)*13, textPos[2]);
  textSize(textSize);
  text("  by Alex Vincent-Hill and Roberto Nunez", textPos[0], textPos[1]-(textSize)*12, textPos[2]);

  text("Frame " + frameCount + " of simulation running at " + round(frameRate) + " FPS.", textPos[0], textPos[1]-(textSize)*10, textPos[2]);
  text("Simulation temperature currently " + round(ps.temperature/10000), textPos[0], textPos[1]-(textSize)*9, textPos[2]);
  text("Simulation pressure currently " + round(ps.pressure), textPos[0], textPos[1]-(textSize)*8, textPos[2]);

  text("Press \"r\" to restart with " + numberStartingParticles + " particles.", textPos[0], textPos[1]-(textSize)*6, textPos[2]);
  text("Hold \"c\" to add chemical reactants.", textPos[0], textPos[1]-(textSize)*5, textPos[2]);
  text("Hold \"q\" to add particles, and \"f\" to add fissionable particles.", textPos[0], textPos[1]-(textSize)*4, textPos[2]);
  text("Press \"n\" to inject a neutron and \"m\" to inject a MDD.", textPos[0], textPos[1]-(textSize)*3, textPos[2]);
  text("Press \"SPACE\" to toggle gravity.", textPos[0], textPos[1]-(textSize)*2, textPos[2]);
  text("Hold \"w,a,s,d\" to add wind forces.", textPos[0], textPos[1]-(textSize)*1, textPos[2]);
}

public void drawSimBox(float halfSimSize) {
  pushMatrix();

  //colors simulation box by temperature
  stroke(360, 0, 100);
  strokeColorBy(ps.temperature, 14, 17, 14, 17);

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
      ps.addParticles(numberStartingParticles);

      //resets camera view
      //simCam(cam);
    }
  }

  //adds n particles with "q" keypress
  if (keyPressed) {
    if (key == 'q') {
      //adds n particles to particle system
      ps.addParticles(addingParticleRate);
    }
  }

  //adds n fissionable particles with "f" keypress
  if (keyPressed) {
    if (key == 'f') {
      //adds n particles to particle system
      ps.addFissionableParticles(addingParticleRate);
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
  if (keyPressed) {
    if (key == 'c') {
      ps.addReactants(addingParticleRate);
    }
  }

  //removes gravity force with "SPACE" hold
  if (gravityToggle) {
    ps.applyForce(gravity);
  }
}

public void keyReleased() {
  if (key == 32) {
    gravityToggle = !gravityToggle;
  }
  //adds 1 neutron on "n" keypress
  if (key == 110) {
    ps.addNeutron();
  }
  //adds 1 DrDevice particle on "m" keypress
  if (key == 109) {
    ps.addDrDevice();
  }
}

//force vectors
//TBD: interparticle charge
//TBD: electric fields/charged particles attracting and repelling each other
//TBD: 3D gravitational fields

//gravity
float gravityMag = 1;
PVector gravity = new PVector (0, gravityMag, 0);
PVector antigravity = new PVector (0, -gravityMag, 0);

//wind
PVector wwind = new PVector (0, -1, 0);
PVector awind = new PVector (-1, -1, -1);
PVector swind = new PVector (0, 1, 0);
PVector dwind = new PVector (1, 1, 1);
// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class DrDevice extends Particle {
  boolean disrupting = false;

  //DrDevice constructor
  DrDevice(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    //class variables to change from Particle
    super(setID, initialPos, initialVel, initialMass);
    this.life = 50;
    this.agingRate = 1;
    this.radius = 20;
    this.hue = 100;

    //non-interacting
    this.deletesOnWalls = false;
    this.bouncesOffParticles = false;
    this.bouncesOffWalls = false;
    this.subjectToForces = false;
  }

  public void collide(Particle otherParticle) {
    //chance of disruption
    if (!(otherParticle instanceof DrDevice)) {
      disrupt(otherParticle, 1);
    }
  }

  //updates DrDevice particles properties, zeroes acceleration, adds drag to velocity
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

    //changes properties during MDD reaction
    if (this.disrupting) {
      this.hue -= this.agingRate*2;
      this.radius += this.agingRate*5;
    }
  }


  public void disrupt(Particle otherParticle, float chance) {

    if (Math.random() < chance) {
      disrupting = true;
      DrDevice newDrDevice = new DrDevice(ps.particleList.size(), otherParticle.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(0, 0, 0), this.mass);
      ps.particleList.add(newDrDevice);
      newDrDevice.disrupting = true;

      //deletes otherParticle
      //this.life = 0;
      otherParticle.life = 0;
    }
  }

  public void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills yellow
    fill(hue, 100, 100);
    //draws particle as a sphere
    noStroke();
    //constrains particles to bounds before render
    //position = new PVector (constrain(position.x, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.y, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.z, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius));
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}
// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class Explosion extends Particle {
  //Explosion constructor
  Explosion(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    super(setID, initialPos, initialVel, initialMass);
    //class variables to change from Particle
    this.deletesOnWalls = false;
    this.bouncesOffParticles = false;
    this.bouncesOffWalls = false;
    this.agingRate = 1;
    this.life = 5;
    this.mass = 100000;
    this.hue = 45;
  }

  public void applyForce(PVector force) {
    //can't apply external forces
  }

  //updates explosion properties, zeroes acceleration, adds drag to velocity
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
    //updates density and radius, expands scaled by life
    radius = life*(float)Math.cbrt((double)((3*mass*density)/(4*PI)));
    //becomes redder with age
    hue = 9*life;
  }

  public void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills yellow
    fill(hue, 100, 100);
    //draws particle as a sphere
    noStroke();
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}
// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class FissionableParticle extends Particle {
  //FissionableParticle constructor
  FissionableParticle(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    //class variables to change from Particle
    super(setID, initialPos, initialVel, initialMass);
    this.fissionable = true;
  }

  public void collide(Particle otherParticle) {
    //chance of fission
    if (otherParticle instanceof Neutron) {
      fission((Neutron) otherParticle, 1);
    }
  }

  //updates fissionable particles properties, zeroes acceleration, adds drag to velocity
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
    //fissile material decays with a small chance every run cycle
    fissionDecay(0.00001f);
  }

  //adds random decay (creating a neutron at current position, creating fission collision reaction)
  public void fissionDecay(float chance) {
    if (Math.random() < chance) {
      Neutron neutron1 = new Neutron(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), 1000);
      ps.particleList.add(neutron1);
    }
  }

  public void fission(Neutron neutron, float chance) {
    //TBD: make fission physical
    if (Math.random() < chance) {
      this.fissionable = false;
      Particle fissionProduct1 = new Particle(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), this.mass/2);
      ps.particleList.add(fissionProduct1);
      Particle fissionProduct2 = new Particle(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), this.mass/2);
      ps.particleList.add(fissionProduct2);
      Neutron neutron1 = new Neutron(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), 1000);
      ps.particleList.add(neutron1);
      Neutron neutron2 = new Neutron(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), 1000);
      ps.particleList.add(neutron2);
      Explosion explosion = new Explosion(ps.particleList.size(), this.position.add(0, 0, 0), new PVector(0, 0, 0), 10000);
      ps.particleList.add(explosion);
      //deletes both neutron and fissionable particle
      this.life = 0;
      neutron.life = 0;
    }
  }

  public void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills yellow
    fill(135, 100, 100);
    //draws particle as a sphere
    noStroke();
    //constrains particles to bounds before render
    position = new PVector (constrain(position.x, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.y, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.z, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius));
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}
// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class Neutron extends Particle {
  //Neutron constructor
  Neutron(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    super(setID, initialPos, initialVel, initialMass);
    //class variables to change from Particle
    this.deletesOnWalls = false;
    this.bouncesOffParticles = false;
    this.bouncesOffWalls = false;
    this.subjectToForces = false;
    this.agingRate = 1;
    this.life = 100;
    this.mass = 10000;
  }

  public void applyForce(PVector force) {
    //can't apply external forces
  }

  public void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills yellow
    fill(54, 100, 100);
    //draws particle as a sphere
    noStroke();
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}
// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class ProductC extends Particle {
  //Particle constructor
  ProductC(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    super(setID, initialPos, initialVel, initialMass);
  }

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
    decompose(0.001f);
  }

  public void decompose(float chance) {
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

  public void display() {
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
// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class ReactantA extends Particle {
  //Particle constructor
  ReactantA(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    super(setID, initialPos, initialVel, initialMass);
  }

  public void collide(Particle otherParticle) {
    //chance of fission
    if (otherParticle instanceof ReactantB) {
      react((ReactantB) otherParticle, .5f);
    }
  }

  //updates reactantA particles properties, zeroes acceleration, adds drag to velocity
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

  public void react(ReactantB reactantB, float chance) {
    if (Math.random() < chance) {

      Particle productC = new ProductC(ps.particleList.size(), this.position.add(new PVector(random(-1, 1), random(-1, 1), random (-1, 1))), new PVector(random(-10, 10), random(-10, 10), random (-10, 10)), this.mass + reactantB.mass);
      ps.particleList.add(productC);
      Explosion explosion = new Explosion(ps.particleList.size(), this.position.add(0, 0, 0), new PVector(0, 0, 0), 10000);
      ps.particleList.add(explosion);

      //deletes both particles
      this.life = 0;
      reactantB.life = 0;
    }
  }

  public void display() {
    //lowers sphere detail
    sphereDetail(20);
    pushMatrix();
    //fills blue
    fill(225, 100, 100);
    //draws particle as a sphere
    noStroke();
    //constrains particles to bounds before render
    position = new PVector (constrain(position.x, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.y, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius), constrain(position.z, -adjustedHalfSimSize + radius, adjustedHalfSimSize - radius));
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}
// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

class ReactantB extends Particle {
  //Particle constructor
  ReactantB(int setID, PVector initialPos, PVector initialVel, float initialMass) {
    super(setID, initialPos, initialVel, initialMass);
  }

  public void display() {
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
  public void settings() {  size(1000, 1000, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "particle_simulation" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
