%% Introduction to Genetic Algorithms
% Oren Rosen
% The MathWorks
% 11/7/2007
%
% This script is for a brief introduction to the MATLAB environment
% and to introduce the concept of Genetic Algorithms using Rastrigin's
% function.

%% Intro to MATLAB 1
x = 2;
y = 3;
z = ras([x,y])

%% Intro to MATLAB 2
x = -5:5

%% Define x and y vectors that sample the interval [-5,5]
x = -5:0.1:5;
y = -5:0.1:5;

%% Evaluate Rastrigin's function
% allcomb creates all combinations of elements in x,y
allcomb(x,y)

z = ras(allcomb(x,y));

%% Reshape resulting vector into a grid format
z = reshape(z,length(x),length(y));

%% Visualize the surface
surf(x,y,z);
contourf(x,y,z);

