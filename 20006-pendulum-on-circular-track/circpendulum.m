function circpendulum(t0,y0,w,r,l);
% CIRCPENDULUM - integrate the equations of motion for a pendulum
% travelling on a vertical circular track and simulate for given initial
% conditions.
%
% circpendulum(t0,y0,w,r,l) where t0 is the time array [tmin tmax], y0 is
% the initial conditions [theta_init, theta_dot_init], w is the angular
% velocity of the pendulum support (omega), r is the radius of the circular
% track, and l is the length of the pendulum arm.  All length units are in
% meters, time units in seconds, and angle units in radians.
% 
% Example    
%    circpendulum([0 30],[0,1],3,1,0.75)
% 
% Written by Dmitry Savransky 19 Jan 2007

%acceleration due to gravity
g = 9.81;

%integrate for theta,thetad
[t,Y] = ode45(@circpendulum_eq,t0,y0);
th = Y(:,1);
%calc phi:
ph = t*w;

%position of pivot in time:
rp = [r*sin(ph), -r*cos(ph)];

%position of mass:
rm = [r*sin(ph)+l*sin(th), -r*cos(ph)-l*cos(th)];

%find bounds:
xmin = min([rm(:,1)',rp(:,1)'])-r/10;
xmax = max([rm(:,1)',rp(:,1)'])+r/10;;
ymin = min([rm(:,2)',rp(:,2)'])-r/10;
ymax = max([rm(:,2)',rp(:,2)'])+r/10;

%drawing:
h = figure();

%step in time:
for i=1:length(t)

    %circle:
    a = [0:0.01:2*pi];
    xcirc = r*sin(a);
    ycirc = r*cos(a);

    %small circle:
    xscirc = r/20*sin(a);
    yscirc = r/20*cos(a);

    %draw the circle of the track (centered at origin):
    plot(xcirc,ycirc,'LineWidth',2);
    hold on;
    %draw two small circles at the support and pendulum mass locations:
    plot(xscirc+rp(i,1),yscirc+rp(i,2),'m','LineWidth',2)
    fill(xscirc+rm(i,1),yscirc+rm(i,2),'g')
    %draw line between support and pendulum mass:
    plot([rp(i,1),rm(i,1)],[rp(i,2),rm(i,2)],'r','LineWidth',2)

    %plot track so far:
    plot(rm(max([i-100,1]):i,1),rm(max([i-100,1]):i,2),'k--');

    %set axes to proper values:
    axis equal;
    grid on;
    axis([xmin xmax ymin ymax]);
    hold off;
    %pause for length of time step
    if i < length(t)
        pause(t(i+1)-t(i));
    end
end

    %integrator for equations of motion
    function dy = circpendulum_eq(t,y)

        %y = [th,thd]
        th = y(1);
        thd = y(2);

        dy = zeros(2,1);
        dy(1) = thd;
        dy(2) = -(r/l)*sin(th - w*t)*w^2 - (g/l)*sin(th);

    end
end
