// Based on code by Daniel Shiffman
// Alex Vincent-Hill

//gravity
float gravityMag = .5;
PVector gravity = new PVector (0,gravityMag,0);

//wind
PVector wwind = new PVector (0,-1,0);
PVector awind = new PVector (-1,-1,-1);
PVector swind = new PVector (0,1,0);
PVector dwind = new PVector (1,1,1);