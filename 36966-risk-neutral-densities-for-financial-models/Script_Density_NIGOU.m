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
% Density NIG Model with Gamma Ornstein Uhlenbeck stochastic clock
%
%   
%
T = 5;                                      % maturity
f0 = 100;                                  % spot value
r=0;
d=0;
ad = 600;                            % spot value
N = 1024;                            % number of grid points  
x = ( (0:N-1) - N/2 ) / ad;          % range

%f = 90:.01:110;                            % range

alpha = 2;
beta = 0;                            % CEV exponent base scenario
delta = .3;
lambda = 3;
a = 1;
b = 1;

legend = 'Base';
title_plot = 'NIG-OU Density';

func = @(x)  cf_nigou(x,T,0,r,d,alpha, beta, delta, lambda,a,b);
y = fftdensity(func,ad,N);
%% Changing a
a_low = .5;
a_high = 2;

func_low = @(x) cf_nigou(x,T,0,r,d,alpha, beta, delta, lambda, a_low,b);
y_low = fftdensity(func_low,ad,N);
func_high = @(x) cf_nigou(x,T,0,r,d,alpha, beta, delta, lambda, a_high,b);
y_high = fftdensity(func_high,ad,N);
legend_low = 'Changing a low';
legend_high = 'Changing a high';

createfigure_density(x,y,y_low,y_high,title_plot,legend,legend_low,legend_high);

%% Changing b
b_low = .5;
b_high = 2;

func_low = @(x) cf_nigou(x,T,0,r,d,alpha, beta, delta, lambda, a,b_low);
y_low = fftdensity(func_low,ad,N);
func_high = @(x) cf_nigou(x,T,0,r,d,alpha, beta, delta, lambda, a,b_high);
y_high = fftdensity(func_high,ad,N);
legend_low = 'Changing b low';
legend_high = 'Changing b high';

createfigure_density(x,y,y_low,y_high,title_plot,legend,legend_low,legend_high);

%% Changing lambda
lambda_low = 1;
lambda_high = 20;

func_low = @(x) cf_nigou(x,T,0,r,d,alpha, beta, delta, lambda_low, a,b);
y_low = fftdensity(func_low,ad,N);
func_high = @(x) cf_nigou(x,T,0,r,d,alpha, beta, delta, lambda_high, a,b);
y_high = fftdensity(func_high,ad,N);
legend_low = 'Changing \lambda low';
legend_high = 'Changing \lambda high';

createfigure_density(x,y,y_low,y_high,title_plot,legend,legend_low,legend_high);

