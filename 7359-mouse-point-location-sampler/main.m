%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Eldad Vizel & Avner Shemron
%%%% Written 4 April 2005
%%%% Technion IIT - Haifa, Israel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script open a figure
% Click any mouse button once inside the figure to 
% start tracking it. You will see both the tracked points,
% and the filtered signal, damping tremors and erratic motion.
% a Second mouse click will stop the tracking, and will present a
% specturm analysis of the acquired signal, prior to filtering.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all 
close all
global Nsamples;
global M;

%%% Plotting the shape to be followed
h=figure;
ezplot('x^2+y^2=10');
grid on
hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Setting the number of coefficients
Nsamples=5;

%%% Creating the Coefficients of the FIR filter
M = 0.2*ones(1,Nsamples);
set(h,'windowbuttondownfcn',{@track}); % Calling track function
