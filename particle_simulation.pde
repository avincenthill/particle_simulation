// Based on code by Daniel Shiffman
// Alex Vincent-Hill

//imports libraries
import peasy.*;

//declares particle system
ParticleSystem ps;

//n is the number of particles in the simulation
int n = 20;

//size of sim boundaries
float simSize = 1000;
float volumeFudgeFactor = 0.9;
float simVolume = pow(simSize*volumeFudgeFactor,3);
float simEdgeMag = volumeFudgeFactor*simSize/2;

//sim environment bools
boolean gravityToggle = true;
boolean inelasticCollisionsToggle = false;

//adds PeasyCam object
PeasyCam cam;

void setup() {
  size(1000, 1000, P3D);
  
  //color mode
  colorMode(HSB,360,100,100);
  
  //initializes cam
  cam = new PeasyCam(this, 2500);
  
  background(0);
  
  //initializes particle system
  ps = new ParticleSystem();
}

void draw() {
  //writes title with fps count and restart instructions
  surface.setTitle("Particle simulation running at " + int(frameRate) + " fps. Press \"r\" to restart.");
  //displays background
  background(0);
  
  //reinitializes n particles in particle system with "r" keypress
  if (keyPressed) {
    if (key == 'r') {
      //removes all particles
      ps.removeAllParticles();
      //adds n particles to particle system
      ps.addParticles(n);
    }
  }
  
  //adds n particles with "a" keypress
  if (keyPressed) {
    if (key == 'a') {
      //adds n particles to particle system
      ps.addParticles(n);
    }
  }
  
  //displays box at simulation boundary
  pushMatrix();
  stroke(0,0,100);
  strokeWeight(5);
  line(simSize/2, simSize/2, simSize/2, -simSize/2, simSize/2, simSize/2);
  line(-simSize/2, simSize/2, simSize/2, -simSize/2, -simSize/2, simSize/2);
  line(-simSize/2, -simSize/2, simSize/2, simSize/2, -simSize/2, simSize/2);
  line(simSize/2, -simSize/2, simSize/2, simSize/2, simSize/2, simSize/2);
  line(simSize/2, simSize/2, -simSize/2, -simSize/2, simSize/2, -simSize/2);
  line(-simSize/2, simSize/2, -simSize/2, -simSize/2, -simSize/2, -simSize/2);
  line(-simSize/2, -simSize/2, -simSize/2, simSize/2, -simSize/2, -simSize/2);
  line(simSize/2, -simSize/2, -simSize/2, simSize/2, simSize/2, -simSize/2);
  line(simSize/2, simSize/2, simSize/2, simSize/2, simSize/2, -simSize/2);
  line(-simSize/2, simSize/2, simSize/2, -simSize/2, simSize/2, -simSize/2);
  line(-simSize/2, -simSize/2, simSize/2, -simSize/2, -simSize/2, -simSize/2);
  line(simSize/2, -simSize/2, simSize/2, simSize/2, -simSize/2, -simSize/2);
  popMatrix();
  
  //runs particle system
  ps.psrun();
  
  //applies gravity
  
  if (gravityToggle) {
      ps.applyForce(gravity);
  }
  
  //applies upward wind force with "w" keypress
  if (keyPressed) {
    if (key == 'w') {
      ps.applyForce(upWind);
    }
  }
}

//user I/O

//removes gravity force with "g" keypress
void keyReleased() {
  if (key == ' ') {
    gravityToggle = !gravityToggle;
  }
   if (key == 'i') {
    inelasticCollisionsToggle = !inelasticCollisionsToggle;
  }
}