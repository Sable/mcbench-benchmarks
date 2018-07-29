
clc
clear all
close all

% This is the main file which runs the diferential equation defined in the 
% other m file in our case its name is "dxdt".
% Options can be set as shown in the code and other options can be explored
% by typing "help odeset" in the command window.
% There are many solvers of ODE, I have used ode45, there are ode23 and others.

options = odeset('InitialStep',.01,'MaxStep',0.1);

% The output variables are "t1 & x1", the function parameters are 
% 1. file name that consists your differntial equation.....( "dxdt")
% 2. time span [tinitial, tfinal].....([0,50])
% 3. Initial conditions, depends on no. of states, e.g for two states
% x0=[0,0].....([0.1,0.1])
% 4. options as set earliar.

[t1,x1]=ode45('dxdt',[0,50],[0.1,0.1],options);
% The extracted date can be plotted as follows
[r c]=size(x1);
X1=x1(1:r,1);
X2=x1(1:r,2);
plot(X1,X2)


