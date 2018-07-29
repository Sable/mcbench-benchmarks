function [rHill,vHill] = CWHPropagator(rHillInit,vHillInit,omega,t)
%% Purpose:
% Take initial position and velocity coordinates in the Hill reference frame
% and propagate them using the Clohessy-Wiltshire Hill Linearize equation
% of motion.
%
%% Inputs:
%rHillInit                  [3 x 1]                 Hill Position vector
%                                                   (km) / (m)
%
%vHillInit                  [3 x 1]                 Hill Velocity vector of
%                                                   (km/s) / (m/s)
%
%omega                       double                 Orbital Angular Rate
%                                                   of the target
%                                                   (rad/s)
%                                                   Should be close to
%                                                   circular for linear propagation
%                                                   error to be low.
%
%t                          [1 x N]                 Propagation Time in
%                                                   seconds
%                                                   
%
%
%
%% Outputs:
%rHill                       [3 x N]                Propagated Hill
%                                                   Position vector (km) /
%                                                   (m/s)
%
%vHill                       [3 x N]                Propagated Hill
%                                                   Velocity vector (km/s)
%                                                   / (m/s)
%
%
% References:
%
% Programed by Darin C Koblick 11/30/2012
%% Begin Code Sequence
x0 = rHillInit(1,:); y0 = rHillInit(2,:); z0 = rHillInit(3,:);
x0dot = vHillInit(1,:); y0dot = vHillInit(2,:); z0dot = vHillInit(3,:);
rHill = [(x0dot./omega).*sin(omega.*t)-(3.*x0+2.*y0dot./omega).*cos(omega.*t)+(4.*x0+2.*y0dot./omega)
        (6.*x0+4.*y0dot./omega).*sin(omega.*t)+2.*(x0dot./omega).*cos(omega.*t)-(6.*omega.*x0+3.*y0dot).*t+(y0-2.*x0dot./omega)
        z0.*cos(omega.*t)+(z0dot./omega).*sin(omega.*t)];
vHill = [x0dot.*cos(omega.*t)+(3.*omega.*x0+2.*y0dot).*sin(omega.*t)
        (6.*omega.*x0 + 4.*y0dot).*cos(omega.*t) - 2.*x0dot.*sin(omega.*t)-(6.*omega.*x0 + 3.*y0dot)
        -z0.*omega.*sin(omega.*t)+z0dot.*cos(omega.*t)];
end