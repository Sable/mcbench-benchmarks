% PURPOSE: demo of low_pass_interpolation()
%          Temporal disaggregation using low-pass filtering
%          Low-pass filter = Hodrick-Prescott
% ---------------------------------------------------------------------
% USAGE: low_pass_interpolation_d

% ---------------------------------------------------------------------

clear all; close all; clc;

% ---------------------------------------------------------------------
% Annual Index of Industrial Production (IIP). Spain. 1975-2007.

Z = [58.52
61.51
64.74
66.24
66.77
67.56
66.91
66.15
67.91
68.50
69.89
72.04
75.35
77.68
81.14
81.17
80.56
78.30
74.57
80.04
83.78
83.20
88.91
93.68
96.16
100.00
98.83
98.93
100.52
102.28
102.35
106.14
108.61 ];

% ---------------------------------------------------------------------
% Sample conversion
sc = 4;

% ---------------------------------------------------------------------
% Hodrick-Prescott parameter
lambda = 1600;

% ---------------------------------------------------------------------
% Denton parameters:
% Type of aggregation
ta = 2;   
% Minimizing the volatility of d-differenced series
d = 1;

% ---------------------------------------------------------------------
% Calling function
[z,w,x] = low_pass_interpolation(Z,ta,d,sc,lambda);

% ---------------------------------------------------------------------
% Plots

subplot(3,1,1);
plot(Z);
    title('LOW-FREQUENCY INPUT');
subplot(3,1,2);
stem(x,'r');
    title ('RAW INTERPOLATION (padding with zeros)');
subplot(3,1,3);
plot([z w]); 
    legend('final','intermediate',0); 
    title('LOW-PASS INTERPOLATION')
