// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

//writes title with fps count and restart instructions
void writeTitle() {
  surface.setTitle("Particle simulation running at " + int(frameRate) + " FPS.");
}

//initializes cam and orients view
void simCam(PeasyCam cam) {
  cam = new PeasyCam(this, 2500);
  cam.rotateX(PI/6);
  cam.rotateY(-PI/6);
  cam.rotateZ(PI/12);
}

//fills color by log(property) and user specified bounds of H and S
void fillColorBy(float property, float lowerLimitH, float upperLimitH, float lowerLimitS, float upperLimitS) {
  float HValue = constrain(map(log(property), lowerLimitH, upperLimitH, 270, 360), 225, 360);
  float SValue = constrain(100 - map(log(property), lowerLimitS, upperLimitS, 0, 100), 0, 100);
  float BValue = 100;
  fill(HValue, SValue, BValue);
}

//strokes color by log(property) and user specified bounds of H and S
void strokeColorBy(float property, float lowerLimitH, float upperLimitH, float lowerLimitS, float upperLimitS) {
  if (property > 0f) {
    float HValue = constrain(map(log(property), lowerLimitH, upperLimitH, 270, 360), 225, 360);
    float SValue = constrain(100 - map(log(property), lowerLimitS, upperLimitS, 0, 100), 0, 100);
    float BValue = 100;
    stroke(HValue, SValue, BValue);
  }
}

void writeTextToSim(int textSize) {
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

void drawSimBox(float halfSimSize) {
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

void userIO() {
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

void keyReleased() {
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