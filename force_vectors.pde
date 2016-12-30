// Based on code by Daniel Shiffman
// Alex Vincent-Hill and Roberto Nunez

//TBD: interparticle charge
//TBD: electric fields
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