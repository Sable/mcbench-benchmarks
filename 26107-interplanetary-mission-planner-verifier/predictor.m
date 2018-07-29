function [ craft_vel craft_theta a e EoverM GMsun] = predictor(craft_v,angle1, source_planet,target_planet )
%PREDICTOR - ellipse determination function
% the equations in this procedure is based on the 
%  This will determine the critical ellipse parametres - mainly a and e,
%  based on the trajectory characteristics of the craft.
% the procedure for determining a and e from craft trajectory is based on: 
%'Satellite Orbits and Gravitational Assist for Planets' (2008)-Larry Bogan
%http://www.bogan.ca/astrpages.html

%target planets are indexed , as below.
%1 = sun
%2 = earth
%3 = jupiter
%4 = saturn
%5 = uranus
%6 =neptune


mass = [1.9891e+30,5.9736e+24,1.8983e+27,5.68462313752e+26,8.6810e25,1.0243e26, 750];
m_sun = mass(1);
% planet masses 
m_craft = mass(7);
G = 6.67428e-11;
tp = target_planet;
sp = source_planet;
AU=149597870691;
radius = [ (6.955e8/AU) 1 5.2 9.582 20.083 30.1036];


%####################################################################
% Step 1  Determine GMsun 
% This determines GM with respect to the sun. This is necesscary as all of
% the tjrajectory ellipses are with respect to the sun as a focus.

GMsun_metres = m_sun * G; 

GMsun = GMsun_metres / AU;  % this GMsun in m/s)^2 - being converted to AU

GMsun = GMsun / 1e6; %to go from square metres to square kilometres
% Should be 887 AU/(km/s)^2

%####################################################################
%Step 2 Energy over mass relationship 




KE = (m_craft * craft_v^2)/2;

GPE = GMsun * m_craft / radius(sp);
E = (KE - GPE);
EoverM = (KE - GPE)/ m_craft;

% if KE - GPE is negative, it means the orbit is still elliptical around
% the sun - if not it is a hyperbolic orbit and it will leave the solar
% system.



%####################################################################
%Step 3 determine semimajor axis

a = -0.5 * GMsun / EoverM;


%####################################################################
%Step 4 - work out circular velocity, based on using the semi major axis as
%a radius. The radius is converted to metres from AU, and period is
%converted to seconds from years.

P = a^(3/2);

Vc = 2 * pi * a * AU   / P;

Vc3 = Vc / (365 * 86164);
Vcirc = Vc3 / 1000;


%####################################################################
% Step 5 from semimajor axis determine the period 
% using Kepeler's third law - already been done above

P = a^(3/2);

%####################################################################
%Step 6 work out the areal velocity - 


V_wrt_planet = craft_v * cosd(angle1); 

V_wrt_planet_AU = (V_wrt_planet / (AU / 1000)) * 86164 * 365;

A =  radius(sp) * V_wrt_planet_AU /2;

%A = area of ellipse / priod - areal velocity




%####################################################################
%Step 7 
% determines eccentricity from Areal Velocity and period of Ellipse 


KK = A * P / (pi * a^2);

e = sqrt(1 - KK^2);


%####################################################################
%Step 8 - from semimajor axis and eccentricity, we get apophelion 
%and periphelion 

r_a = a*(1 + e);
r_p = a*(1 - e);



%####################################################################
%Step 9 determine true anomoly - the angle between periphelion and the
%spacecraft

%1 = sun
%2 = earth
%3 = jupiter
%4 = saturn
%5 = uranus
%6 =neptune
%7 = our spacecraft

V_per = Vcirc * sqrt((1+e) /(1-e));
V_aps = Vcirc * sqrt((1-e) /(1+e));

GSI  = radius(tp) * (( mass(tp)/mass(1))^(2/5));
% 
craft_vel = sqrt( (2* EoverM) + (2 * GMsun ./ (radius(tp)- GSI)));

%its reduced by tp.
craft_theta = acosd((a*(1 - e^2)/(radius(tp)- GSI) - 1)/e);
end

