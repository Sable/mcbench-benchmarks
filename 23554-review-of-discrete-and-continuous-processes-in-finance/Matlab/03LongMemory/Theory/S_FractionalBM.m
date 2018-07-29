% This script generates paths of fractional Brownian motion.  

% see A. Meucci (2009) 
% "Review of Discrete and Continuous Processes in Finance - Theory and Applications"
% available at ssrn.com

% Code by A. Meucci, April 2009
% Most recent version available at www.symmys.com > Teaching > MATLAB

clear; clc; close all

H=.8;         % Hurst coefficient H=d+1/2;
dt=1/252;     % time step
T=252;       % size of the sample 
N=20;            % number of independent paths

DW = ffgn(H,N,T);  % unit-time-interval increments

W_integers=cumsum(DW,2); % unit-time-interval process
W=W_integers*dt^H;      % generic-time-interval process: self-similarity property

plot([1:T]*dt,W)
title(['fBm with H=' num2str(H) '  (Bm: H=0.5)'])


