%%%% WHEELED MOBILE ROBOT
% Course: Robotic Manipulation and Mobility
% Advisor: Dr. V. Krovi
%
% Homework Number: 6
%
% Names: Sourish Chakravarty
% 	Hrishi Lalit Shah
%%
clear all;
close all;
clc;

global r b d a mc mw Ic Iw Im L1 L2 % WMR paramters
global xe ye rx ry ell_an start_an w % Trajectory information
global Kp1 Kd1 Kp2 Kd2

d2r=pi/180;
COMPUTE=1;
%% SYSTEM PARAMETERS OF WMR
r= 0.15; % Radius of each wheel
b= 0.75; % Wheel Base
d= 0.30; % Forward distance of Center of mass from center of rear axle
a= 2.00;
mc= 30.00;
mw= 1.00;
Ic= 15.625;
Iw= 0.005;
Im= 0.0025;
L1 = 0.25; L2 =0.25; % Coord of Look Ahead point in WMR ref frame
%% TRAJECTORY (ELLIPSE) INFORMATION
xe=2; % x center of ellipse
ye=0; % y center of ellipse
rx=1.75;% Half-length of major axis
ry=1.25; % Half-length of minor axis
ell_an=45*d2r; % Angle subtended between major axis and horizontal
start_an= 0*d2r; % Initial phase at t=0
w=72*d2r;
%% INITIAL CONDITIONS
t=0;
dist=1; % Initial Disturbance
% Position of look ahead point
x_E0=xe+rx*cos(w*t + start_an)*cos(ell_an) + ry*sin(w*t + start_an)*(-sin(ell_an)); % Initial X on ellipse
y_E0=ye+rx*cos(w*t + start_an)*sin(ell_an) + ry*sin(w*t + start_an)*(cos(ell_an)); % Initial Y on ellipse

% xd_0= w*( -rx*sin(w*t + start_an)*cos(ell_an) + ry*cos(w*t + start_an)*(-sin(ell_an)) ); % Initial X-vel on ellipse 
% yd_0= w*( -rx*sin(w*t + start_an)*sin(ell_an) + ry*cos(w*t + start_an)*(cos(ell_an)) ); % Initial Y-vel on ellipse 
% v=sqrt(xd_0^2+yd_0^2);

phi_0 = 180*d2r;
v= 1; % Linear velocity of CM
om= -32*d2r; % Ang velocity of WMR about CM
th_R_0= 0*d2r;
th_L_0= 0*d2r;

TR_C2O = [cos(phi_0), -sin(phi_0);
    sin(phi_0), cos(phi_0)];     % Transformation from CM cood system to Absolute cood sys
X_C_0= [x_E0,y_E0]' - TR_C2O*[L1,L2]'; % Initial position of CM
x_0= X_C_0(1)+dist; % Initial x position of center of mass with disturbance
y_0= X_C_0(2)+dist; % Initial y position of center of mass with disturbance
c= r/(2*b);
S= [c*(b*cos(phi_0)-d*sin(phi_0)), c*(b*cos(phi_0)+d*sin(phi_0));
    c*(b*sin(phi_0) + d*cos(phi_0)),c*(b*sin(phi_0) - d*cos(phi_0));
    c,-c];
Nu= pinv(S)*([v*cos(phi_0), v*sin(phi_0), om]');
thd_R_0= Nu(1);
thd_L_0= Nu(2); % 

% SIMULATION PARAMETERS
n=360; % total number of points in simulation
sim_time=10; % total simulation time
dt=sim_time/n;
tspan=0:dt:sim_time;
% tspan=[0,10];
temp=COMPUTE;
SIMU=1;
switch(SIMU)
    case 1 % Simulation 1
        Kp1=5;  Kp2=Kp1; % Position Level Control Weights
        Kd1=10;   Kd2=Kd1; % Velocity Level Control Weights
        txt=['Kp',num2str(Kp1),'Kd',num2str(Kd1),'.mat'];
        if COMPUTE==1
            options= odeset('RelTol',1e-3,'AbsTol',[1e-3, 1e-3, 1e-3, 1e-3, 1e-3,1e-3, 1e-3]);
            X0=[x_0, y_0, phi_0, th_R_0, th_L_0, thd_R_0, thd_L_0];
            [t,Y]=ode45(@WMR_TRAJTRACK,tspan,X0,options,L1,L2); % Variable Time Step
%             Y=ode4(@WMR_TRAJTRACK,tspan,X0); t=tspan; % Fixed Time Step
        else
            load(txt); % Load the pre-existing file if no computation required
        end
        txt1=['Wheeled Mobile Robot Control;Kd1=',num2str(Kd1),'Kd2=',num2str(Kd2),'Kp1=',num2str(Kp1),'Kp2=',num2str(Kp2)];
        plotbot_WMR(t,Y,1,txt1); %Plot trajectory and errors
        if temp==1
            save(txt); % If computation is done, save to file for later use
        end
    otherwise
        disp('incorrect TRIG value');
end