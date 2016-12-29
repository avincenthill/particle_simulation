// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

//TBD: build a clock that uses seconds
//TBD: put on the web with processing.js
//TBD: make units physical

//imports libraries
import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

//TBD: import apache math

//n is the number of particles in the simulation
int n = 100;

//simulation variables
float simSize = 1000;
float halfSimSize = simSize/2;
float volumeFudgeFactor = 0.9;
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

void setup() {
  //sets window size and rendering mode
  size(1500, 1500, P3D);

  //sets color mode
  colorMode(HSB, 360, 100, 100);

  //initializes cam and orients view
  simCam(cam);

  //starts background black
  background(0);

  //initializes particle system
  ps = new ParticleSystem();
}

void draw() {
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