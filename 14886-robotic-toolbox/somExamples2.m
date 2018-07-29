%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%This example show the use of DH matrix and differential operator

clf
clear

%%Another 6 DOF manipulator
%% with 5 revolute joints and 1 prismatic joint

theta1=-30;
theta2=-25;
theta3=-50;
theta4=-45;
theta5=-20;
theta6=95;

%%link length
a2=1.4;
a3=1.0;
d2=0.2;
d3=0.4;

T01=DHmatrix(theta1,0,0,90);
T12=DHmatrix(theta2,d2,a2,0);
T23=DHmatrix(theta3,d3,a3,0);
T34=DHmatrix(theta4,0,0,90);
T45=DHmatrix(theta5,0,0,90);

Tuh=T01*T12*T23*T34*T45;
%%This example show the 
%%This shows how to use the plot system
plotT(T01);
pause(2);
plotT2(T01,T01*T12);
pause(2);
plotT2(T01*T12,T01*T12*T23);
pause(2);
plotT2(T01*T12*T23,T01*T12*T23*T34);
pause(2);
plotT2(T01*T12*T23*T34,T01*T12*T23*T34*T45);
pause(2);

%%We want a differential motion of
deltax=0.1;
deltay=0.02;
deltaz=0.3;
dx=0.25;
dy=0.05;
dz=0.01;

%%Question: which is the differential motion of the end effector?
dT=deltaDiff(Tuh,deltax,deltay,deltaz,dx,dy,dz)