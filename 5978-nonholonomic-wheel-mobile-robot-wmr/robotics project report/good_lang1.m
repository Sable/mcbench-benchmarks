% ****************************************************************
% This is a function used for robotics project
% 
% MAE 505: Robotic Final Project.
% Created By: Gan Tao
% Date: 10 Dec 2003.
% ****************************************************************

function [X_dot] = good_lang1(t, q)

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


Xr_c=5;
Yr_c=0;
c   =0.5;
b   =0.75;
d   =1;
Kp  =2;
Kd  =5;


Xc          = q(1); % xc 
Yc          = q(2); % yc
fai         = q(3); % fai
theta_R     = q(4); % theta right
theta_L     = q(5); % theta left
theta_dot_R = q(6); % theta dot right
theta_dot_L = q(7); % theta dot left

% ****************** The path to trace:**************************************************************************

y_desire = t;       %line case i x=6; desired position
x_desire = 6;

xy_dot_desire = [0; 1]; %2x1 matrix         %line x=6 case i;   desired velocity

xy_2_dot_desire = [0; 0]; % 2x1 matrix

xy_desire =[x_desire y_desire]';


%****************** To get the new input V(y2_dot) **************************************************************

Xr = Xc+Xr_c*cos(fai)-Yr_c*sin(fai);
Yr = Yc+Xr_c*sin(fai)+Yr_c*cos(fai);

xy = [Xr;Yr];

S = [c*(b*cos(fai)-d*sin(fai)) c*(b*cos(fai)+d*sin(fai)); 
     c*(b*sin(fai)+d*cos(fai)) c*(b*sin(fai)-d*cos(fai));
     c                         -c                       ;
     1                         0                        ;
     0                         1                        ]; %5*2;
 
faifunction = [ c*(b*cos(fai)-d*sin(fai))+(-Xr_c*sin(fai)-Yr_c*cos(fai))*c,c*(b*cos(fai)+d*sin(fai))-(-Xr_c*sin(fai)-Yr_c*cos(fai))*c;
                c*(b*sin(fai)+d*cos(fai))+(Xr_c*cos(fai)-Yr_c*sin(fai))*c,c*(b*sin(fai)-d*cos(fai))-(Xr_c*cos(fai)-Yr_c*sin(fai))*c ]; %2*2;

%*** faifunction_dot = diff(faifunction,fai);*****
niu = [theta_dot_R;theta_dot_L];

faifunction_dot =[ c*(-b*sin(fai)-d*cos(fai))+(-Xr_c*cos(fai)+Yr_c*sin(fai))*c,c*(-b*sin(fai)+d*cos(fai))-(-Xr_c*cos(fai)+Yr_c*sin(fai))*c;
             c*(b*cos(fai)-d*sin(fai))+(-Xr_c*sin(fai)-Yr_c*cos(fai))*c,c*(b*cos(fai)+d*sin(fai))-(-Xr_c*sin(fai)-Yr_c*cos(fai))*c ]; %2*2;
               
xy_dot  = faifunction*niu;%2*1;

xy2_dot = xy_2_dot_desire+Kd*(xy_dot_desire - xy_dot)+Kp*(xy_desire - xy);%2*1;

%**************** Using V(xy2_dot) to get the U input ************************************************************

U = inv(faifunction)*(xy2_dot-faifunction_dot*niu); %2*1

%**************** Using U to get the X_dot ***********************************************************************

f1 = S*niu;%5*1;


X_dot = [f1(1);f1(2);f1(3);f1(4);f1(5); 0; 0] + [0 0;0 0;0 0;0 0;0 0;1 0;0 1]*[U(1);U(2)];
