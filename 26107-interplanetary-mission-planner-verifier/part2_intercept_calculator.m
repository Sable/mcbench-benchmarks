% This code takes the distance the craft travels on each ellipse(determined from step 1)
% as well as the time duration of each transition. This time value enables
% the modelling of each planet position - i.e., the planets trajectory is
% 'wound backwards' by the transition time, to determine the target
% planet's position before the transition started. If this is done
% successively for each target planet, it is possible to determine the
% position of each planet at the very start of the mission. This enables
% the prediction of future possibilities to run tis mission, I.E. when the
% derived planetary alignment next occurs.
%Stephen Walker 2009(stephen.walker@student.uts.edu.au)
clear
close all
load sum_.mat

% the planetary index key - mars is omitted.
%1 = sun
%2 = earth
%3 = jupiter
%4 = saturn
%5 = uranus
%6 = neptune

[zzz,count] = size(sum_.plan)
%determine the number of intercepts

count = count - 1
%although there are 'count' elements there are count -1 transition events -
%i.e jupiter - saturn

mass = [1.9891e+30,5.9736e+24,1.8983e+27,5.68462313752e+26,8.6810e25,1.0243e26, 750];
radius = [ 0.0046 1 5.2 9.582 20.083 30.1036];



G = 6.67428e-11;
AU=149597870691;

a = [0 1.0000001124 5.204267 9.58201720 19.22941195 30.10366151];
e = [0.00001 0.016710219 0.048775 0.055723219 0.044405586 0.011214269];

%this is the semimajor axis and ellipse of all the major bodies

P = a.^(3/2);
P_seconds = P *365 * 86164

% the sidereal period of each planet's orbit is calculated.  


P_stagger(1) = 0
for i = 1:count
  planet = sum_.plan(i)  

P_angle(i) = sum_.time(i) / P_seconds(planet + 1) * 360

% the planet + 1 is needed as the target of this is the 'destination'
% planet.
P_stagger(i+1) = P_stagger(i) + P_angle(i)

end
% planet stagger is saved both as degrees and radians.
% 'P_stagger.mat' is the stagger of all of the target planets with respect
% to Earth. Earth is assumed to be at azimuth = 0 to start with.

planet_stagger.rad = P_stagger * pi ./ 360
planet_stagger.d = P_stagger


save P_stagger.mat P_stagger