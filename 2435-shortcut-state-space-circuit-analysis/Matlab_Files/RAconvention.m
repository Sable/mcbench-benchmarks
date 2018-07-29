% M-File showing that the RA method of creating the A & B arrays
% gives the same results using the conventional method.
% File:  c:\M_files\short_updates\Matlab_Files\RAconvention.m
% 02/16/07
% See Word file UsingGarray1.doc for background explanations.
clear;clc; 
% unit suffixes
u=1e-6;K=1e3;m=1e-3;u=1e-6;p=1e-12;
% component values
R1=5*K;R2=1*K;R3=10*K;
C1=0.1*u;C2=400*p;
Ein=1; % Unity input for (normalized) transfer function
%
% Form W, Q, S, and P arrays: 
%
W=[1+R3/R1 1+R3/R1;R2 0];Q=[0 -1/R1;-1 1];S=[Ein/R1;0];P=diag([C1 C2]);
%
% Get A & B arrays using RA method:
%
C=inv(W*P);A=C*Q;B=C*S;
% Display A & B in Command window:
disp('RA Method')
disp(' ')
A
B
disp(' ')
% Using conventional method:
%
disp('Conventional method')
disp(' ')
A=[-1/(R2*C1) 1/(R2*C1);1/(R2*C2) (1/(R1+R3)+1/R2)/C2]
B=[0;(1/(R1+R3))/C2]
%

