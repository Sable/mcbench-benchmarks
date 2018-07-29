
%%
% Auther : Gaul Swapnil Narhari,
% Developed @ IIT Kharagpur, India.
% In collaborationwith TaraNG, India.
%%
% for optimization see 'pso.m' file for fitness function defination see 'simple_fitness.m'
%%
clc;
clear all;
ObjectiveFunction = @simple_fitness;
nvars = 3;    % Number of variables
LB = [0 0 0];   % Lower bound
UB = [3 5 10];  % Upper bound
Popln=20;
Genrtn=50;
WByn=1;
[x,fvalue] = pso(ObjectiveFunction,'NumVar',nvars,'LowerBound',LB,'UpperBound',UB,'Population',Popln,'Genrations',Genrtn,'IncludeWB',WByn);
disp(x);
disp(fvalue);