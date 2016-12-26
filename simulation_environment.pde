// Based on code by Daniel Shiffman
// Alex Vincent-Hill

//writes title with fps count and restart instructions
void writeTitle(){
  surface.setTitle("Particle simulation running at " + int(frameRate) + " FPS.");
}

void writeTextToSim(int textSize){
  fill(0,0,100);
  textSize(textSize*2);
  text("particle_simulation", -500, -500-(textSize)*11, -500);
  textSize(textSize);
  text("  by Alex Vincent-Hill", -500, -500-(textSize)*10, -500);
  text("Frame " + frameCount + " of simulation running at " + round(frameRate) + " FPS.", -500, -500-(textSize)*8, -500);
  text("Simulation temperature currently " + round(ps.temperature), -500, -500-(textSize)*7, -500);

  text("Hold \"q\" to add particles.", -500, -500-(textSize)*5, -500);
  text("Press \"r\" to restart with " + n + " particles.", -500, -500-(textSize)*4, -500);
  
  text("Hold \"SPACE\" to turn off gravity.", -500, -500-(textSize)*2, -500);
  text("Hold \"w,a,s,d\" to add wind forces.", -500, -500-(textSize)*1, -500);
}

//TBD: add passed variable to this function
void drawSimBox(float halfSimSize){
  pushMatrix();
  float boxHValue = constrain(map(constrain(log(ps.temperature),0,999999999), log(pow(10,1)), log(pow(10,6)), 270, 360), 225, 360);
  float boxSValue = constrain(100 - map(constrain(log(ps.temperature),0,999999999), log(pow(10,4)), log(pow(10,6)), 0, 100), 0, 100);
  float boxBValue = 100;
  stroke(boxHValue,boxSValue,boxBValue);
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

void userIO(){
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
  ps.applyForce(gravity);
  if (keyPressed) {
    if (key == ' ') {
      ps.applyForce(antigravity);
    }
  }
}

//initializes cam and orients view
void simCam(PeasyCam cam){
  cam = new PeasyCam(this, 2500);
  cam.rotateX(PI/6);
  cam.rotateY(-PI/6);
  cam.rotateZ(PI/12);
}