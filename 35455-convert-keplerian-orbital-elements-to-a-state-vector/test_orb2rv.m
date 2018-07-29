%Start w/ a position and velocity vector of an eccentric inclined
pos = repmat([6524.834,6862.875,6448.296]',[1 100]);
vel = repmat([4.901327,5.533756,-1.976341]',[1 100]);
%Convert to keplerian orbital elements
[~,e,i,O,o,nu,~,~,~,p] =rv2orb(pos,vel);
[r,v] = orb2rv(p,e,i,O,o,nu);

%Start w/ a position and velocity vector of a circular orbit
pos = [6524.834,0,0]';
vel = [0,7.81599286557539,0]';
%Convert to keplerian orbital elements
[a,e,i,O,o,nu,truLon,argLat,lonPer,p] =rv2orb(pos,vel);
[r,v] = orb2rv(p,e,i,O,o,nu,truLon,argLat,lonPer);

%Start w/ a position and velocity vector of an inclined circular orbit
pos = [0,6524.834,0]';
vel = [0,0,7.81599286557539]';
%Convert to keplerian orbital elements
[a,e,i,O,o,nu,truLon,argLat,lonPer,p] =rv2orb(pos,vel);
[r,v] = orb2rv(p,e,i,O,o,nu,truLon,argLat,lonPer);

%Start w/ a position and velocity vector of a hyperbolic orbit
pos = [6524.834,0,0]';
vel = [0,30,0]';
%Convert to keplerian orbital elements
[a,e,i,O,o,nu,truLon,argLat,lonPer,p] =rv2orb(pos,vel);
[r,v] = orb2rv(p,e,i,O,o,nu,truLon,argLat,lonPer);

%Find a parabolic orbit from keplerian elements... then convert back to
%elements
[r,v] = orb2rv(10000,1.0,pi/2,0,0,0,0,0,0);
[a,e,i,O,o,nu,truLon,argLat,lonPer,p] =rv2orb(r,v);
