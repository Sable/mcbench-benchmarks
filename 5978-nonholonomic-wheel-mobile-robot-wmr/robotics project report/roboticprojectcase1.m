%***************************************************************************************************************************
%MAE 505 ROBOTICS PROJECT
%COORDINATING LOCOMOTION AND MANIPULATION OF A MOBILE MANIPULATOR
%SIMULATION
%Created by Gan Tao
%Case (i) 
%x=6,y=t
%Dec 10 2003
%***************************************************************************************************************************

% Xc                ***X coordinate of center mass of the mobile platform
% Yc                ***Y coordinate of center mass of the mobile platform
% fai               ***heading angle of the platform measured from the X axis of the world coordinates
% theta_R           ***angular displacement of the right wheel
% theta_L           ***angular displacement of the left wheel
% theta_dot_R       ***angular velocity of the right wheel??
% theta_dot_L       ***
% Xr                ***X coordinate of world coordinates of the reference point
% Yr                ***Y coordinate of world coordinates of the reference point
% Xr_c              ***
% Yr_c              ***
% c                 ***c=(r/2*b)
% b                 ***the distance between the driving wheels and the axis of symmetry
% d                 ***the distance from Po(the intersection of the axis of symmetry with the driving wheel axis) to Pc(the center 
%                   ***of mass of the platform

clear all

L1 = 5;
L2 = 5;
c  = 0.5;

%******* initial state variables ************************************************************************

q_ini = [0 10 pi/2 0 0 0 0];


Xr_c  = 5;
Yr_c  = 0;
Xr_c1 = 5/1.4142;
Yr_c1 = 0;
gama  = pi/4;

%integral the x_dot to get x
opt=odeset('RelTol',1e-2);
[t, q] = ode45(@good_lang1, [0 60], q_ini, opt);

% ***** Plotting Result **********************************************************************************
path1 = t;
path2 = 6;                     % case i  x=6;

plot(path2,path1,'b-');
hold on
axis equal
axis([-5 65 -5 65])
grid on

path = size(t);
Na   = path(1,1);

for j = 1:1:Na, % change to M for sinewave, N for circle
R1   = 5/1.414;
R2   = 5/1.414;
Xc   = q(j,1);
Yc   = q(j,2);
fai  = q(j,3); 
robot_width = 1.5;
Xr   = Xc+Xr_c*cos(fai)-Yr_c*sin(fai);
Yr   = Yc+Xr_c*sin(fai)+Yr_c*cos(fai);
Xr1  = Xc+Xr_c1*cos(fai+gama)-Yr_c1*sin(fai+gama);
Yr1  = Yc+Xr_c1*sin(fai+gama)+Yr_c1*cos(fai+gama);
theta_r_dot = q(j,6);
theta_l_dot = q(j,7);
sinfai(j) = sin(fai);
cosfai(j) = cos(fai);
linearvelocity(j) = (theta_l_dot+theta_r_dot)*0.75/2;
theta_r_dotre(j)  = theta_r_dot;
theta_l_dotre(j)  = theta_l_dot;
theta_r(j) = q(j,4);
theta_l(j) = q(j,5);
Xcre(j)  = q(j,1);
Ycre(j)  = q(j,2);
faire(j) = fai;

[Robot] = Robotplot(Xc, Yc, fai, robot_width);

%********************* Create the 4 lines that draw the box of the mobile robot *************************************

Robot1x = [Robot(1,1) Robot(1,3)];
Robot1y = [Robot(1,2) Robot(1,4)];

Robot2x = [Robot(1,3) Robot(1,5)];
Robot2y = [Robot(1,4) Robot(1,6)];

Robot3x = [Robot(1,5) Robot(1,7)];
Robot3y = [Robot(1,6) Robot(1,8)];

Robot4x = [Robot(1,7) Robot(1,1)];
Robot4y = [Robot(1,8) Robot(1,2)];

Robotlinkx  = [Xr Xc];
Robotlinky  = [Yr Yc];

Robotlinkx1 = [Xr1 Xc];
Robotlinky1 = [Yr1 Yc];

Robotlinkx2 = [Xr1 Xr];
Robotlinky2 = [Yr1 Yr];


RobotBox(1,:) = [Robot1x Robot2x Robot3x Robot4x];
RobotBox(2,:) = [Robot1y Robot2y Robot3y Robot4y];

plot (Xc,Yc,'r-','LineWidth',1);

XrYr         = [Xr Yr];
XcYc         = [Xc Yc];
Xr1Yr1       = [Xr1 Yr1];
XrYrtoXcYc   = distance(XrYr,XcYc);
Xr1Yr1toXcYc = distance(Xr1Yr1,XcYc);
XrYrtoXr1Yr1 = distance(XrYr,Xr1Yr1);

MMcos = (-(XrYrtoXcYc*XrYrtoXcYc-Xr1Yr1toXcYc*Xr1Yr1toXcYc-XrYrtoXr1Yr1*XrYrtoXr1Yr1)/(2*XrYrtoXr1Yr1*Xr1Yr1toXcYc));
MM(j) = sqrt(1 - MMcos^2);

if j==1,
    
    h1 =plot(Robot1x, Robot1y,'b-','LineWidth',4);
    h2 =plot(Robot2x, Robot2y,'r-','LineWidth',1);
    h3 =plot(Robot3x, Robot3y,'b-','LineWidth',4);
    h4 =plot(Robot4x, Robot4y,'r-','LineWidth',1);
    h5 =plot(Robotlinkx, Robotlinky,'ro','LineWidth',1);
    h6 =plot(Robotlinkx1, Robotlinky1,'r-','LineWidth',1);
    h7 =plot(Robotlinkx2, Robotlinky2,'r-','LineWidth',1);

    set(h1,'EraseMode','xor');
    set(h2,'EraseMode','xor');
    set(h3,'EraseMode','xor');
    set(h4,'EraseMode','xor');
    set(h5,'EraseMode','xor');
else
    
    set(h1,'XData', Robot1x,'YData',Robot1y)
    set(h2,'XData', Robot2x,'YData',Robot2y)
    set(h3,'XData', Robot3x,'YData',Robot3y)
    set(h4,'XData', Robot4x,'YData',Robot4y)
    set(h5,'XData', Robotlinkx,'YData',Robotlinky)
    set(h6,'XData', Robotlinkx1,'YData',Robotlinky1)
    set(h7,'XData', Robotlinkx2,'YData',Robotlinky2)

    end
    pause(0.01)

 
    
end
      
