% Demo of ras()
% Usage: ras_d

clear all; close all; clc;

%-------------------------------------------------------------------------
% BENCHMARK
%-------------------------------------------------------------------------

% IO matrix
F0= [50	100	0
     30	50	20
     20	50	30  ];
 
% Total output vector
x0 = [200 300 200];

%-------------------------------------------------------------------------
% UPDATE
%-------------------------------------------------------------------------

% Total output by row
u = [160 ; 150 ; 120];

% Total intermediante output by column
v = [100 250 80];

% Total output
x1 = [200 400 300];

% Graphics
opG = 1;

% Calling ras() function
F1 = ras(F0,x0,x1,v,u,opG);


