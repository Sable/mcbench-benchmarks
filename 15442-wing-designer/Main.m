% Main function to run Wing Designer
% Keywords: airfoil, wing design, vortex lattice, NACA 4-digit 5-digit
% copyright 2007 by Phillip J. Root and John R Rogers 
%
% Wing Designer is used to predict aircraft cruising performance.
% One-time preprocessing is required to create or to update 
% NACAdata.txt  the airfoil data--see the AirfoilData folder.
% Aircraft  design parameters are taken from a graphical user interface.
% Range is computed and constitutes the largest component of a performance
% score.
%
% See Contents.m for a listing of files

clc
fprintf('Wing Designer ver 1.6\n')
clear all
close all

%Parse NACAdata.txt into airfoilstruct for use in determining profile drag
airfoilstruct = parseNACAairfoildata;
%Perform regression on airfoilstruct data at multiple Re
airfoildata = PerformRegression(airfoilstruct);

%Initialize GUI
InitializeGUI(airfoildata)