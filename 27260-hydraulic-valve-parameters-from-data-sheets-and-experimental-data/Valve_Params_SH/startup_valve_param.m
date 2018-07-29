% Startup script to set up path
% Copyright 2010 MathWorks, Inc.

Valve_Params_HomeDir = pwd;
addpath(Valve_Params_HomeDir);
addpath([Valve_Params_HomeDir '\Ex1_A_Max_Search']);
addpath([Valve_Params_HomeDir '\Ex2_Table_Area_vs_Disp']);
open('Valve_Params_Demo_Script.html');
