%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  BPSO and VPSO source codes version 1.0                           %
%                                                                   %
%  Developed in MATLAB R2011b(7.13)                                 %
%                                                                   %
%  Author and programmer: Seyedali Mirjalili                        %
%                                                                   %
%         e-Mail: ali.mirjalili@gmail.com                           %
%                 seyedali.mirjalili@griffithuni.edu.au             %
%                                                                   %
%       Homepage: http://www.alimirjalili.com                       %
%                                                                   %
%   Main paper: S. Mirjalili and A. Lewis, "S-shaped versus         %
%               V-shaped transfer functions for binary Particle     %
%               Swarm Optimization," Swarm and Evolutionary         %
%               Computation, vol. 9, pp. 1-14, 2013.                %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all 
close all
clc

CostFunction=@(x) MyCost(x); % Modify or replace Mycost.m according to your cost funciton

Max_iteration=500; % Maximum number of iterations
noP=30; % Number of particles
noV=100;

ConvergenceCurves=zeros(8,Max_iteration);

%BPSO with s-shaped family of transfer functions
[gBest1, gBestScore1 ,ConvergenceCurves(1,:)]=BPSO(noP,Max_iteration,1,CostFunction,noV);
[gBest2, gBestScore2 ,ConvergenceCurves(2,:)]=BPSO(noP,Max_iteration,2,CostFunction,noV);
[gBest3, gBestScore3 ,ConvergenceCurves(3,:)]=BPSO(noP,Max_iteration,3,CostFunction,noV);
[gBest4, gBestScore4 ,ConvergenceCurves(4,:)]=BPSO(noP,Max_iteration,4,CostFunction,noV);
%BPSO with v-shaped family of transfer functions
[gBest5, gBestScore5 ,ConvergenceCurves(5,:)]=BPSO(noP,Max_iteration,5,CostFunction,noV);
[gBest6, gBestScore6 ,ConvergenceCurves(6,:)]=BPSO(noP,Max_iteration,6,CostFunction,noV);
[gBest7, gBestScore7 ,ConvergenceCurves(7,:)]=BPSO(noP,Max_iteration,7,CostFunction,noV);
[gBest8, gBestScore8 ,ConvergenceCurves(8,:)]=BPSO(noP,Max_iteration,8,CostFunction,noV); % VPSO

DrawConvergenceCurves(ConvergenceCurves,Max_iteration);

save resuls

