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



% Script chap::2::script
% Density NIG Model with Cox Ingersoll Ross stochastic clock
%
%   
%
T = 1;                                      % maturity
f0 = 100;                                  % spot value
r=0;
d=0;
a = 600;                            % spot value
N = 512;                            % number of grid points  
x = ( (0:N-1) - N/2 ) / a;          % range

%f = 90:.01:110;                            % range

alpha = 7;
beta = -3;                            % CEV exponent base scenario
delta = 1;
mu = 0;
lambda = 1;
kappa = 1;
eta = 0.5;

legend = 'Base';
title_plot = 'NIG-CIR Density';

func = @(x) cf_nigcir(x,T,0,r,d,alpha, beta, delta, lambda, kappa, eta);
y = fftdensity(func,a,N);
%% Changing lambda
lambda_low = .5;
lambda_high = 5;

func_low = @(x) cf_nigcir(x,T,0,r,d,alpha, beta, delta, lambda_low, kappa, eta);
y_low = fftdensity(func_low,a,N);
func_high = @(x) cf_nigcir(x,T,0,r,d,alpha, beta, delta, lambda_high, kappa, eta);
y_high = fftdensity(func_high,a,N);
legend_low = 'Changing \lambda low';
legend_high = 'Changing \lambda high';

createfigure_density(x,y,y_low,y_high,title_plot,legend,legend_low,legend_high);

%% Changing kappa
kappa_low = .5;
kappa_high = 5;

func_low = @(x) cf_nigcir(x,T,0,r,d,alpha, beta, delta, lambda, kappa_low, eta);
y_low = fftdensity(func_low,a,N);
func_high = @(x) cf_nigcir(x,T,0,r,d,alpha, beta, delta, lambda, kappa_high, eta);
y_high = fftdensity(func_high,a,N);
legend_low = 'Changing \kappa low';
legend_high = 'Changing \kappa high';

createfigure_density(x,y,y_low,y_high,title_plot,legend,legend_low,legend_high);

%% Changing eta
eta_low = 0.1;
eta_high = 1.5;

func_low = @(x) cf_nigcir(x,T,0,r,d,alpha, beta, delta, lambda, kappa, eta_low);
y_low = fftdensity(func_low,a,N);
func_high = @(x) cf_nigcir(x,T,0,r,d,alpha, beta, delta, lambda, kappa, eta_high);
y_high = fftdensity(func_high,a,N);
legend_low = 'Changing \eta low';
legend_high = 'Changing \eta high';

createfigure_density(x,y,y_low,y_high,title_plot,legend,legend_low,legend_high);
