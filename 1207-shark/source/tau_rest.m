function tr=tau_rest(veh,p)

% tr=tau_rest(veh,p); calculates restoring forces from 
% vehicle variables and generalized position p

% Hydrostatic force and moment
FB_e=-veh.vol*veh.rho*veh.g_e;
FB_b=rpy2R_eb(p(4:6))*FB_e;
MB_b=vp(veh.B_b,FB_b);
tb=[FB_b;MB_b];

% Gravitational force and moment
FG_e=veh.m*veh.g_e;
FG_b=rpy2R_eb(p(4:6))*FG_e;
MG_b=vp(veh.G_b,FG_b);
tg=[FG_b;MG_b];

tr=tb+tg;
