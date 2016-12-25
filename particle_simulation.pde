// Based on code by Daniel Shiffman
// Alex Vincent-Hill

//imports libraries
import peasy.*;

//declares particle system
ParticleSystem ps;

//n is the number of particles in the simulation
int n = 10;

//simulation dimensions
float simSize = 1000;
float volumeFudgeFactor = 0.95;
float simVolume = pow(simSize*volumeFudgeFactor,3);
float simEdgeMag = volumeFudgeFactor*simSize/2;

//simulation global variables
boolean gravityToggle = true;


//simulation text formatting
int textSize = 40;
String gravityToggleText;

//adds PeasyCam object
PeasyCam cam;

void setup() {
  size(1000, 1000, P3D);
  
  //color mode
  colorMode(HSB,360,100,100);
  
  //initializes cam and orients view
  cam = new PeasyCam(this, 2500);
  cam.rotateX(PI/6);
  cam.rotateY(-PI/6);
  cam.rotateZ(PI/12);
  
  background(0);
  
  //initializes particle system
  ps = new ParticleSystem();
}

void draw() {
  //writes title with fps count and restart instructions
  surface.setTitle("Particle simulation running at " + int(frameRate) + " FPS.");
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
      ps.addParticles(n/10);
    }
  }
  
  //displays text above simulation area
  fill(0,0,100);
  
  textSize(textSize*2);
  text("particle_simulation", -500, -500-(textSize)*10, -500);
  
  textSize(textSize);
  text("  by Alex Vincent-Hill", -500, -500-(textSize)*9, -500);
  
  text("Frame " + frameCount + " of simulation running at " + round(frameRate) + " FPS.", -500, -500-(textSize)*7, -500);
  text("Simulation temperature currently " + round(ps.temperature), -500, -500-(textSize)*6, -500);
  
  text("Press \"SPACE\" to turn " + gravityToggleText + " gravity.", -500, -500-(textSize)*4, -500);
  text("Press \"r\" to restart with " + n + " particles.", -500, -500-(textSize)*3, -500);
  text("Hold \"a\" to add particles.", -500, -500-(textSize)*2, -500);
  text("Hold \"w\" and \"s\"  to add wind forces.", -500, -500-(textSize)*1, -500);
  
  
  //displays box at simulation boundary
  pushMatrix();

  float boxHValue = constrain(map(log(ps.temperature), log(pow(10,1)), log(pow(10,7)), 270, 360), 225, 360);
  float boxSValue = constrain(100 - map(log(ps.temperature), log(pow(10,5)), log(pow(10,7)), 0, 100), 0, 100);
  float boxBValue = 100;
  stroke(boxHValue,boxSValue,boxBValue);
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
  
  //draw() diognostics
  //println(frameCount);
  
//user I/O
  //applies gravity
  if (gravityToggle) {
      ps.applyForce(gravity);
      gravityToggleText = "off";
  }
  else{
    gravityToggleText = "on";
  }
  
  //applies wind force with "w" keypress
  if (keyPressed) {
    if (key == 'w') {
      ps.applyForce(upwind);
    }
  }
  if (keyPressed) {
    if (key == 's') {
      ps.applyForce(downwind);
    }
  }
}

void keyReleased() {
  if (key == ' ') {
    //toggles gravity force with "g" keypress
    gravityToggle = !gravityToggle;
  }
}