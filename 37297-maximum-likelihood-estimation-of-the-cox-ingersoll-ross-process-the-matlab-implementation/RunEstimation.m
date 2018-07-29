%%RUN ESTIMATION ROUTINE
% Kamil Kladivko for Technical Computing Prague 2007
% Date: October 2007 
% Date: October 2007 
% Questions? kladivko@gmail.com

clc
clear all
close all

load Pribor3M

Model.Data = Pribor3M;
Model.TimeStep = 1/250;      % recommended: 1/250 for daily data, 1/12 for monthly data, etc
Model.Disp = 'y';           % 'y' | 'n' (default: y)
Model.MatlabDisp = 'iter';  % 'off'|'iter'|'notify'|'final'  (default: off)
Model.Method = 'besseli';   % 'besseli' | 'ncx2pdf' (default: besseli)

Results = CIRestimation(Model);
