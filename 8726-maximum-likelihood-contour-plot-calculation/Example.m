% Example to generate contour plot for objective functions based on the 
% maximum likelihood plot concept
% Communications toolbox needed: vec2mat  in fcnNormalize0_1

clc
clear all
close all
% base case coefficients
BCcoeff = [ -2 4 -6 8];
% set the sensitivity range in %: e.g 30% around base case value
settings.Range = 30;
% sensitivity grid resolution
settings.step =  1;
% contour plot setting
settings.CplotRange = [ 50:2:100];
% additional parameter vector = []
param =[];


% call function to calculate matrix Z
%function [out]=fcnSensitivityRun_3D(Objfun, BCcoeff, setts, param)

outStr = fcnSensitivityRun_3D('fcnObjfun', BCcoeff, settings, param)

% call function fcnMLPlot(in) to plot the results
% it was split in two functions because the calculation of matrix Z can
% take long time, e.g. for ODE systems and if you want to change the
% contour plot settings then you dont need to recalculate Z.

% for e.g. you can change the contour plots setting
% 
outStr.setts.CplotRange = [ 20:10:100];
fcnMLPlot(outStr)




