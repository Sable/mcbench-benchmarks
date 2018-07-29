% Main code to generate transition candidate. 
%this calls functions predictor.m and transition.m 
%Stephen Walker 2009(stephen.walker@student.uts.edu.au)

%predictor.m determines the characteristics of an ellipse to model the trajectory based on the
%velocity and angle (with respect to the ellipse focus - the sun) at the start point 

% transition.m takes the angle and velocity of the craft (from the ellipse defined by predictor.m) at the point that
% it intersects EITHER the planets orbit, OR the planet's gravitational
% sphere of influence ( The intent is to compare the difference between the
% two & see if it makes a difference.

clear
close all



G = 6.67428e-11;


AU=149597870691;

% the planets are assumed to have perfectly circular orbits. This is not a
% true assumption, but it will enable the modelling of a coarse
% trajectory from earth orbit. Once determined, this will enable
% verification of the orbit through 'hillclimbing' using the Newtonian modeller.

radius = [ (6.955e8/AU) 1 5.2 9.582 20.083 30.1036];
% this is our obit radii for our our circular orbits (as stated, planet orbits are all elliptical). 
mass = [1.9891e+30,5.9736e+24,1.8983e+27,5.68462313752e+26,8.6810e25,1.0243e26, 750];
% planet masses - uncluding 750kg for our spacecraft
m_sun = mass(1)
m_craft = mass(7)
%planet masses
%THETA = linspace(360,0,1000);
THETA = linspace(0,360,1000);
% set a range of points to form the ellipse
figure(5)
hold on

XXXX= radius(1) * cosd(THETA);
YYYY= radius(1) * sind(THETA);
plot(XXXX,YYYY,'y.')
% plot the sun, but realistically its just a yellow dot as the radius is very small.


for ii = 2:5
%This plots the assumed 'circular'orbits, (in blue) as well as the gravitational 
%sphere of influence (in light green).   
GSI  = radius(ii) * (( mass(ii)/m_sun)^(2/5));
XXXX= radius(ii) * cosd(THETA);
YYYY= radius(ii) * sind(THETA);
plot(XXXX,YYYY);
% blue orbit plotted above

XXXX= (radius(ii)-GSI) * cosd(THETA);
YYYY= (radius(ii)-GSI) * sind(THETA);
plot(XXXX,YYYY,'green');
XXXX= (radius(ii)+GSI) * cosd(THETA);
YYYY= (radius(ii)+GSI) * sind(THETA);
plot(XXXX,YYYY,'green');
axis equal;
% upper and lower bounds of the GSI for each planet plotted in light greeen
end

% Planets and objects are indexed - as below:
%1 = sun
%2 = earth
%3 = jupiter
%4 = saturn
%5 = uranus
%6 =neptune
%7 = spacecraft :this only applies to mass, as there is no 

colours=lines(8);


% sets initial positions of the spacecraft. This is how it leaves earth orbit. 
craft_vel(1) = 39;
craft_theta(1) = 30.8;

% the miss distances is how far the spacecraft is away from each planet as
% it passes it. Thios is critical as it determines 
%miss = [ 0.07 0.03 0.02]
%plan = [2 3 4 5 6]
miss = [ 0.05 0.03  ]

plan = [2 3 4 5 ]
delta_SUM = 0;
flag = 0;



[zzzz,index] = size(miss)

%%%%START LOOP

for i = 1:(index+1)
source_planet = plan(i);
target_planet = plan(i+1);

%predictor.m is called. It derives an ellipse from the starting angle and
%theta. The source_planet and target_planet enable define positions and masses
%of the origin and destination planets 


[ craft_vel(i+1) craft_theta(i+1) a e EoverM GMsun] = predictor(craft_vel(i),craft_theta(i)+ delta_SUM, source_planet,target_planet ); 


%this works out the 'arc' of the ellipse that the spacecraft follows
%between  the planets - r_intercept.inner being the intercept point of the 
%origin planet r_intercept.and outer being the point it leaves this ellipse. 

r_intercept.inner(i) = acosd(((a *(1 -e^2)/ radius(source_planet))-1)/e); 
r_intercept.outer(i) = acosd(((a *(1 -e^2)/ radius(target_planet))-1)/e); 
if flag == 1
delta(i) = (r_intercept.inner(i)- r_intercept.outer(i-1));
delta_SUM = delta_SUM + delta(i);

end
flag = 1;
%plots r values for all THETA values. 
%The r,THETA combo enables us to plot the ellipse

r =  a *(1 -e^2)./(1 + (e * cosd(THETA )));


[xx,yy] = pol2cartd((THETA + delta_SUM ),r);

plot(-xx,yy,'color',colours(source_planet,:));
% not sure why, the axes had to be reversed. 
%set(gca,'XDir','reverse')

% a second range of theta values is created, to define a range of values
% between the spacecraft intercept points with the ellipse



theta2 = linspace(r_intercept.inner(i),r_intercept.outer(i),50000) ;
%disp(theta2)%
%the linspace element count is set high to provide half decent resolution
%for the distance calculation
arr =  a *(1 -e^2)./(1 + (e * cosd(theta2)));
[xx,yy] = pol2cartd((theta2 - delta_SUM ),arr);
%messed up - the axes are all flipped out....
plot(-xx,-yy,'r.'); 



transit.x(:,i) = xx;
transit.y(:,i) = yy;
transit.vel(:,i) = sqrt( (2* EoverM) + (2 * GMsun ./ (arr)));

[qq,countr] = size(xx);

for j = 2:countr
difference_x = transit.x(j,i) - transit.x(j-1,i);
difference_y = transit.y(j,i) - transit.y(j-1,i) ; 
length(j-1)  = hypot(difference_x,difference_y) * (AU / 1000);
time(j-1) = length(j-1) /transit.vel(j-1,i);

%this converts the length value to km, to better suit the velocity values.
end


sum_.time(i) = sum(time);
sum_.length(i)= sum(length);

%this gives us a distance plot (transit.x and y in AU)and our velocity at each point on this curve.
%using position and velocity details enable the calculation of a transition
%time. This is critical, to work out the time to transit between planets.
%This time value, used in conjunction with the orbit velocity of the
%planets in question to determine 'IF' the planets will ever be aligned to
%take advantage of the planned trajectory. This time value will have a
%small error, as it is assumed the behaviour of the craft as it passes
%through the gravitational sphere of influence of the target planets is an
%'instant' change in velocity and angle. This is notaccurate, but the error
%will be over a small segment of the transition. The accuracy of the
%Keplerian orbit estimation will be verified by simulating it using the
%newtonian n-body simulator.



if i < index+1 % this prevents a transition attempt on the last iteration
    % This uses transition.m - this enables the 
 [ craft_vel2 craft_theta2] = transition(craft_vel(i+1),craft_theta(i+1), target_planet, miss(i) ) ;
 tester2.theta_in(i) = craft_theta(i+1);
 tester2.theta_out(i) = craft_theta2;
 tester2.vel_in(i) = craft_vel(i+1);
 tester2.vel_out(i) = craft_vel2;
 

 
 
 
 
 craft_vel(i+1) = craft_vel2;
 
 
 craft_theta(i+1)= craft_theta2;
 
end

end
 
sum_.plan =plan;
save sum_.mat sum_ 






% source_planet = plan(2);