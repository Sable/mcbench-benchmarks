%Newtonian Simulator to verify trajectory defined by Keplerian Trajectory
%generator
%This takes the derived exit velocity and angle, along with the required
%planetary positions and simulates the trajectory using the Newtonian
%Method. The core of this application is the same as the 'n-body' newtonian
%simulation
% A desireable result is to have the two different methods produce the 
%same trajectories - fortunately (with some hillclimbing) it does.
% The velocity derived by Keplerian methods works without alteration, but
% the angle required some optimisation (less than 1 degree) to achieve the
% same trajectory
% an angle of 60.8378 yields a uranus  closest approach of 0.255 AU
%Stephen Walker 2009(stephen.walker@student.uts.edu.au)
% 60.837808 --- SPOT ON!!!!
%39000 --- SPOT ON!!!!
clear;
clf
load solar_system_sun_2_uranus.mat;
%this is the starting state vectors from the 'n body'simulation. For the
%Keplerian simulation, the solar system consisted of non-elliptical
%planetary orbits. This is also the case with this simulation to be
%consistant. As such, this file contributes only the sun's state vector,
%and the masses of the planets.

load P_stagger.mat
%this is the required planetary alignment, as dictated by the first step
%-Keplerian simulation

M = 1.9891e30
G = 6.67e-11;
count = 1;
countr = 1;
l = 0;
v =1;
flag = 0;
%gravitational constant and other flags etc

day_count = 365 * 14; % 3650 * 8;
%This determines the run duration of the simulation

res = 1800;
delta_t = 120;
%delta_t is the resolution of step size between calculations.
%res is how frequently this data is written to the planetary plot.
%res shouldnt be smaller than delta_t - waste of resources for no benefit

scenario_runtime = day_count * 86400 /delta_t;
[total_planets,zzzzz] = size(planets_au);
%scenario executions determined by the delta_t and the number of days of
%runtime requested
AU=  149597870691;
AUk =149597870
radius = [ (6.955e8/AU) 1 5.2 9.582 20.083 30.1036];
%this is the circular radius of the planets to be modelled
KM = 1000;
 planets(1,1) = planets_au(1,1)* KM;
 planets(1,2) = planets_au(1,2)* KM;
 planets(1,7) = planets_au(1,7); 
 planets(1,4) = planets_au(1,4)* KM;
 planets(1,5) = planets_au(1,5)* KM;
    %loads te sun position and mass into the 'planets' state vector.
    
for p = 2 : total_planets;
    %The planets initial positions and velocities are set up, based on
    %P_stagger
    
    Planet_stagger = P_stagger(p-1) * pi / 180
    P_mag = radius(p) * AU;
    P_theta = Planet_stagger
  
    [planets(p,1),planets(p,2)] = pol2cart(P_theta,P_mag )
     
    vel_ideal =   sqrt(G*M / (radius(p)* AU) );
    [planets(p,4),planets(p,5)] = pol2cart(( P_theta + (pi/2)), vel_ideal)
%planet velocities are set to produce a non eccentric solar orbit
   
    planets(p,7) = planets_au(p,7); 
    % mass import
    
    
    
end
%Now the spacecraft state vector is added to the planets state vector.
total_planets = total_planets + 1
tp = total_planets; % 

[earth_p.theta,earth_p.mag] = cart2pol(planets(2,1),planets(2,2));
% 
% Angle 60.837808 works - the predicted value is within 1 degree of this
%Velocity 39000 works - this was exactly the predicted value.
voyager_v.mag  = input('input velocity in m/s (39000 works)  ');
voyager_v.new = input('input  velocity theta in  deg (60.837808 works) ');
voyager_v.new = voyager_v.new * pi / 180;

voyager_v.theta = voyager_v.new;

[planets(tp,4),planets(tp,5)] = pol2cart(voyager_v.theta,voyager_v.mag);



 
%voy_earth_angle = input('input earth_position angle');
%The velocity of the spacecraft has bee set, the position is set with
%respect to Earth. This is effectively the point that the spacecraft engine
%has concluded firing - adding the velocity needed to start the mission.
voy_earth_angle = -103.9546
voy_earth_angle = voy_earth_angle * pi / 180;
voy_alt = 2.107619802984712e+08 ;%6371e3 + 400e3

[earth_vector_x,earth_vector_y] = pol2cart(voy_earth_angle,voy_alt);




planets(tp,1) = planets(2,1) + earth_vector_x;
planets(tp,2) = planets(2,2) + earth_vector_y;
% This enables the voyager start position to be set with respect to Earth


 planets(tp,7) = 750
% craft mass is set to 750kg

%The figure is set up outside the loops, then just ammended inside the
%loop.
figure(1)
clf
hold on


pos2.x=[];pos2.y=[];%pos2.z=[];
kk=0;
axis equal
axis ([ -5e12, 5e12,-5e12,5e12]);%,-1.5e12,1.5e12])
title ('Solar System')

kkk=lines(total_planets);
for a = 2 : total_planets
    track(a) = plot([1 1],[8 2],'color',kkk(a,:),'LineWidth',0.5,'LineStyle','-','Marker','.');
end
    track(1) = plot([1 1],[8 2],'color',kkk(1,:),'LineWidth',0.5,'LineStyle','-','Marker','o');

    %this is the commencement of the time iteration loop. It will run until
    %mission duration is reached.
    
for t = 1:scenario_runtime;
    tic
    %LOOP A start
    %LOOP A selects all elements to be modeled - one at a time.
    %Body 'a' is selected.
    for a = 1 : total_planets ;
        
     
        
        pos_a = [planets(a,1),planets(a,2)];%,planets(a,3)];
        vel_a = [planets(a,4),planets(a,5)];%,planets(a,6)];
        mass_a = planets(a,7);
        %initial positions , mass and velocity of planet/body a
        net_grav_a = [0,0];%,0];
        
        % LOOP B start
        %Loop B compares all of the planets/ bodies (except a)with planet/body a
        %the stepping is wierd (a+1) as it is only necessary to calculate
        %the grav vector from a to b. once calculated, it is easy to
        %reverse the calculated vector (multiply by -1) to get the b to a
        %vector. This halved the work of B loop and halved the execution
        %time
        
        for b = (a+1):total_planets; %the a+1 is in to create diagonal
            
            
            mass_b = planets(b,7);
            pos_b = [planets(b,1),planets(b,2)];%,planets(b,3)];
            %reads initial positions and mass of body b
            
            diff =  pos_b -pos_a;
            %with both pos values, a vector between a and b is determined
            pos_diff.mag = sqrt((diff(1)^2) + (diff(2)^2));% + (diff(3)^2));
            %the magnitude of this vector is calculated
            
            unit_diff = diff * (1 / pos_diff.mag);
            %The vector between a and b is turned into a unit vector
            pos_diff.grav = ((mass_a * mass_b * G) / (pos_diff.mag^2));
            %the gravity magnitude is calculated
            grav = unit_diff * pos_diff.grav;
            % the gravity magnitude is applied to the unit vector giving a
            % gravity vector between a and b
            
            
            grav_array.x(a,b) = grav(1)* -1;
            grav_array.y(a,b) = grav(2)* -1;
            %grav_array.z(a,b) = grav(3)* -1;
            %the gravity vector values are loaded into an array (virtually
            %3d, one array per axis - this only does HALF of the array
            grav_array.x(b,a) = grav(1);
            grav_array.y(b,a) = grav(2);
            %grav_array.z(b,a) = grav(3);
            % this does the other HALF of the array
            
            
            
            
        end;%loop_b_end
        
        
        net_grav_a(1) = sum(grav_array.x(:,a));
        net_grav_a(2) = sum(grav_array.y(:,a));
        %net_grav_a(3) = sum(grav_array.z(:,a));
        %the total gravitational force on body a
        
        mt = delta_t/mass_a;
        
        net_grav_a = net_grav_a * mt;
        
        if a == tp && rem(t,res) == 0 % v is indexed here and the velocity mag line calc
            [tt,gravity(v)] = cart2pol(net_grav_a(1),net_grav_a(2));%,net_grav_a(3));
        end
        %this turns the net grav value into an acceleration value, by removing mass,
        %and factoring in the delta_t
        new_vel_a = vel_a + net_grav_a;
        
        %the new velocity is the old velocity added to the delta_velocity
        new_pos_a = pos_a + (new_vel_a * delta_t);
        %new position is the old position plus the delta position.
        planets(a,1:2) = new_pos_a;
        %the planet position is written to planets
        azimuth(a) = atan2(new_pos_a(2),new_pos_a(1));
        %The angular position of the planets is recorded.
        planets(a,4:5) = new_vel_a;
        %The calculated position and velocity are written to  planets
        
        
        
    end
    
    
    
    %LOOP A END
    if rem(t,res) == 0
        [tt,velocity(v)] = cart2pol(planets(tp,4),planets(tp,5));
        v = v +1 ;
        %craft velocity is recorded, to be graphed at the end
    end
    if rem(t,res) == 0;
        % every "res" seconds the position values for all planets are
        % sampled
        [voyager_pos.theta,voyager_pos.mag] = cart2pol(planets(tp,1),planets(tp,2));%,planets(tp,3));
        if voyager_pos.mag > (25.5 * AU);
            break
        end
        
  % the distances between the craft and the three target planets is calculated 
  %in order to graph closest approach      
jupiter_diff.x = planets(tp,1) - planets(3,1);
jupiter_diff.y = planets(tp,2) - planets(3,2);
saturn_diff.x =  planets(tp,1) - planets(4,1);
saturn_diff.y =  planets(tp,2) - planets(4,2);
uranus_diff.x =  planets(tp,1) - planets(5,1);
uranus_diff.y =  planets(tp,2) - planets(5,2);


jupiter(count) = (hypot(jupiter_diff.x,jupiter_diff.y)) / AU;
saturn(count) = (hypot(saturn_diff.x,saturn_diff.y))/ AU;
uranus(count) = ( hypot(uranus_diff.x,uranus_diff.y))/ AU;
count = count + 1;
% The distances between the spacecraft and each of the planets is logged,
% to be graphed later. This will reveal the closest apprach to each planet.

        azimuth_tracker(countr,:) = azimuth;
        countr = countr +1;
        

        %setup unique colour for each modeled body
             kk=kk+1;  
        for k = 1:total_planets
           
 %the figure displaying the positions of all of the bodies
            %modelled is updated here
          disp (t);
          disp (gravity(end));
          disp (velocity(end));
            pos2.x(k,kk) = planets(k,1);            
            pos2.y(k,kk) = planets(k,2);
           
            set(track(k),'XData',pos2.x(k,1:1:end),'YData',pos2.y(k,1:1:end));
           
    
            
        end
%     
        drawnow
        %
    end
    timer = toc;
    % a timer is built in to asess iteration time. This was done with more
    % higher resolution / longer duration runs to determine runtime.
    
end %END OF IMPLEMENTATION LOOP
%time step is finished



%redundant code to determine runtime duration
% stop_time = clock;
% run_time = stop_time - start_time;
% save run_time_duration.mat run_time

save azimuth_tracker.mat azimuth_tracker
%azimuth angle relationships is saved. For other versions of the n-body
%code this is critical to determine possible mission windows, but this is
%not required for this application.

figure (333)
clf
plot (gravity)
%from the spacecraft's perspective, net gravitational force is graphed. 
%this gives large spikes as the craft passes by planets.

figure (4444)
clf
plot (velocity)
%craft velocity is plotted


figure (5555)
%the craft closest approaches to Jupiter, Saturn & Uranus are graphed.
hold on
plot(jupiter,'red')
plot(saturn,'blue')
plot(uranus,'green')
hold off

