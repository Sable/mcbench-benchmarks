
%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%This example show the use of DH parameters, omogeneous transformations
%%jacobian,static force analysis and plot functions.

%%An example of a 6 degree of freedom robot: 6 revolute joints
%% Solve a DH problem for forward kinematics
%%Joint variables
clf
theta1=-30;
theta2=-25;
theta3=-50;
theta4=-45;
theta5=-20;
theta6=95;

%%link length
a3=2.5;
a4=2.1;
a5=1.8;

%%First way to calculate the forward kinematics
T01=DHmatrix(theta1,0,0,0);
T12=DHmatrix(0,0,0,-90);
T23=DHmatrix(theta2,0,a3,0);
T34=DHmatrix(theta3,0,a4,0);
T45=DHmatrix(theta4,0,a5,0);
T56=RotZ(theta5)*RotX(theta6);

Tuh1=T01*T12*T23*T34*T45*T56;


%%A second fast way to calculate it
T01=RotZ(theta1);
T12=RotX(-90);
T23=RotZ(theta2)*Tras(a3,0,0);
T34=RotZ(theta3)*Tras(a4,0,0);
T45=RotZ(theta4)*Tras(a5,0,0);
T56=RotZ(theta5)*RotX(theta6);

% %%This shows how to use the plot system
% plotT(T01);
% pause(2);
% plotT(T01*T12);
% pause(2);
% plotT2(T01*T12,T01*T12*T23);
% pause(2);
% plotT2(T01*T12*T23,T01*T12*T23*T34);
% pause(2);
% plotT2(T01*T12*T23*T34,T01*T12*T23*T34*T45);
% pause(2);
% plotT2(T01*T12*T23*T34*T45,T01*T12*T23*T34*T45*T56);

Tuh2=T01*T12*T23*T34*T45*T56;

%%now calculate the jacobian
J6=jacobianT6([T01,T12,T23,T34,T45,T56],['R','R','R','R','R','R']);


F=[2.1;3.2;4.5;10.1;0.5;0.07];
T=staticForce(J6,F);
