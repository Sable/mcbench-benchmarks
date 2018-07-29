% This is the numerical solution of the system depicted in Fig. 15.6 (pp. 568) of
% Henley, E. J. and Seader, J. D., "Equilibrium-Stage Separation Operations
% in Chemical Engineering", 1981, John Wiley & Sons.
clear all; clc; format compact

load x0 % x0 = [x y L V T]
parameters_dist
N = 16; C = 5;
% States
% x  = 0.25*ones(N,C);
% y  = 0.25*ones(N,C);
% L  = 100*ones(N,1);
% V  = 100*ones(N,1);
% T  = 150*ones(N,1);
% x0 = [x y L V T];

% Manipulations
P(1)     = 238; % psia
P(2)     = P(1) + 2;
P(3:N-1) = P(2) + DP*(3-2:N-1-2);
P(N)     = P(N-1) + 0.4;
P        = P/14.5038; % bar

U(1:N)   = zeros(N,1); % kmole/h (from Aspen Plus simulation)
U(1)     = 2.268;
U(3)     = 1.361;

W(1:N)   = zeros(N,1); % kmole/h (from Aspen Plus simulation)
W(13)    = 16.783;

Q(1:N)   = zeros(N,1); % Btu/h
Q(1)     = 900274.3;
Q(3)     = 200000.0;
Q(N)     = -1566538.18;
Q        = Q/9.47831e-4/1e3; % kJ/h

u        = [P U W Q]';

% Disturbances
z      = zeros(N,C);
z(6,:) = [2.5 14.0 19.0 5.0 0.5]/sum([2.5 14.0 19.0 5.0 0.5]);
z(9,:) = [0.5 6.0 18.0 30.0 4.5]/sum([0.5 6.0 18.0 30.0 4.5]);

F      = zeros(N,1); % kmole/h (from Aspen Plus simulation)
F(6)   = 18.597;
F(9)   = 26.762;

PF     = zeros(N,1); % psia
PF(6)  = 300;
PF(9)  = 275;
PF     = PF/14.5038; % bar

TF     = zeros(N,1); % F
TF(6)  = 170;
TF(9)  = 230;
TF     = 1/1.8*(TF - 32); % C

HF     = zeros(N,1);
[HF(6),~,~,~] = feed_dist(F(6),z(6,:),TF(6),PF(6));
[HF(9),~,~,~] = feed_dist(F(9),z(9,:),TF(9),PF(9));

d      = [z F HF];

options = optimset('Display','iter','Diagnostics','on','Algorithm','interior-point');
r = fmincon('1',x0,[],[],[],[],[],[],@nonlcon_dist,options,u,d,N,C);

