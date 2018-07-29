function [ w_vel w_theta ] = transition(vel_in, theta_in_d, planet, miss )
%transition function
%   this is the function to determine the trajectory as a craft exits a
%   planets Gravitational Sphere of Influence(GSI), based its trajectory as it
%   enters the GSI
% THE DISTANCE UNITS FOR THIS CODE IS AU. 1AU is the distance between the
% earth and the sun.
%Stephen Walker 2009(stephen.walker@student.uts.edu.au)
AU=149597870691;

radius = [ (6.955e8/AU) 1 5.2 9.582 20.083 30.1036];
planetv = [0 ,29.8872901273899,13.1010703616133,9.65512922576934,6.81559164993671,5.44724492369616;];
planetv = planetv * -1;
mass = [1.9891e+30,5.9736e+24,1.8983e+27,5.68462313752e+26,8.6810e25,1.0243e26, 750]; 
% sets initial velocities, orbit radius and mass of planets.
%this is a set of test values


G = 6.67428e-11;
GM_metres =  mass(planet) * G; 
GMp = GM_metres / AU; 
GMp = GMp / 1e6;

%%%% STEP 1 %%%%
% the velocity of the planet is removed, so that the vector represents
% the motion of the spacecraft with respect to the 'stationary' Jupiter

[vel_x1,vel_y] = pol2cartd(theta_in_d,vel_in); 

vel_x2 = vel_x1 - planetv(planet);

[theta_in2,vel_out] = cart2pol(vel_x2,vel_y);
theta_in2d = theta_in2 * 180 / pi;

%%%% STEP 2 %%%%
%The planets normalised velocities are used to work out the deflection
%angle 
% 
result = acotd((miss * (vel_out^2) )/ GMp );
 
theta_outd = theta_in2d + (2 * result);

%%%% STEP 3 %%%%
% With the new deflection angle, the exit velocity is available
% 

theta_out = theta_outd * pi /180;

 [vel_x_out,vel_y_out] = pol2cart(theta_out,vel_out);
% 
 vel_x_out2 = vel_x_out + planetv(planet);
%  
[theta_out2,vel_out2] = cart2pol(vel_x_out2,vel_y_out);

theta_out2d = theta_out2 * 180 / pi;

w_vel = vel_out2;
w_theta = theta_out2d;

end

