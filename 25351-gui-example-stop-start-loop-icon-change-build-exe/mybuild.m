%% starting
fclose all; close all; clear all;
clc; fprintf('starting %s\n',datestr(now)); pause(0.1); 


%% compiling
%mbuild -setup
mcc -ev mygui.m
s='C:\Program Files\MATLAB_Network_R2008a\toolbox\compiler\deploy\win32\MCRInstaller.exe';
copyfile(s,'.');


%% ending
fclose all; fprintf('ending %s\n',datestr(now)); 
