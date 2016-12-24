// Based on code by Daniel Shiffman
// Alex Vincent-Hill

//imports libraries
import peasy.*;

//declares particle system
ParticleSystem ps;

//n is the number of particles in the simulation
int n = 1000;

//size of sim boundaries
float simSize = 1000;

//adds PeasyCam object
PeasyCam cam;

void setup() {
  size(1000, 1000, P3D);
  
  //initializes cam
  cam = new PeasyCam(this, 2500);
  
  background(0);

  //initializes particle system
  ps = new ParticleSystem();
  
  //adds n particles to particle system
  ps.addParticle(n);
}

void draw() {
  //writes title with fps count
  surface.setTitle("particle_sim " + int(frameRate) + " fps");
  //displays background
  background(0);
  
  //applies forces
  ps.applyForce(gravity);
  if (keyPressed) {
    if (key == 'w') {
      ps.applyForce(wind);
    }
  }
  
  //displays box at simulation boundary
  pushMatrix();
  stroke(255,255,255);
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
}