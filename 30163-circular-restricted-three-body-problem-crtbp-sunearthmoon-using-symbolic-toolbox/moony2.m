% The constants required in the calculation

Me= 5.972E23;                % Mass of earth
Ms= 1.988E30;                % Mass of sun
Mm= 7.3459E22;               % Mass of Moon
R= 1.495E11;                 % Orbital radius of earth
r= 3.85E8;                   % Orbital radius of moon
G= 6.67E-11;                 % Gravitational Constant
TT=3.155E7;                  % orbital time of earth
w= sqrt(G*(Me+Ms)/R^3);      % Angular velocity
de= Ms*R/(Ms+Me);            % Distance between earth and centre of mass
ds= Me*R/(Ms+Me);            % Distance between sun and centre of mass
vv=sqrt(G*Me/r);             % average velocity of moon



% Defining tspan, initial condition.
tspan = linspace(0,TT,1E4);

z0 = [-(de+r); 0; 0; vv];
[t,z] = ode45(@moony, tspan, z0);


% Equation for coordinates of sun and earth
xsun= ds.*cos(w.*tspan);
ysun= ds.*sin(w.*tspan);
xea= -de.*cos(w.*tspan);
yea= -de.*sin(w.*tspan);

% Plotting of trajectory of sun and earth
fig = figure;
ax = axes;
plot(xsun,ysun,'yo');
hold on;
plot(xea,yea,'g-');
grid on;
set(ax,'color','black');
plot(z(:,1),z(:,3),'w-');
