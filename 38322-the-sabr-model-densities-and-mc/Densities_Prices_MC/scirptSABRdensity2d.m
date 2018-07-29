% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code.

% Script for generating a 2d SABR density using the Wu expansion

% base scenario
clear; clc;
t=0; T=1; 
f = 0.03; 
alpha = 0.075; 
beta = 0.5;    
nu = 0.05; 
rho = 0;

% All expansions 0th to 2nd order of Wu
%sabrdensity = @(x,y) psabr30(t,T,f,x,alpha,y,beta,nu,rho);
% sabrdensity = @(x,y) psabr31(t,T,f,x,alpha,y,beta,nu,rho);
sabrdensity = @(x,y) psabr32(t,T,f,x,alpha,y,beta,nu,rho);

lcoeff = 1; ucoeff = 1;
lowerbound = f-lcoeff*f;
upperbound = f + ucoeff*f;

xvals = lowerbound:.001:upperbound;
yvals = 0.05:.001:.1;

zvals2d = density2d(xvals,yvals,sabrdensity);

% Density 2d
figure; surf(yvals,xvals,zvals2d);
