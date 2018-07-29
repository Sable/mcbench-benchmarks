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



% Script chap::3::script
% Density Variance Gamma model with Cox-Ingersoll-Ross stochastic clock
%
%   
%
T = 1;              % maturity
f0 = 100;           % spot value
r=0;                % risk less rate
d=0;                % dividend yield
% parameters for applying fourier transform to compute the density
a = 600;                            % parameter to compute density via fft
N = 1024;                           % number of grid points  
x = ( (0:N-1) - N/2 ) / a;          % range

C = 2;
G = 2;                            
M = 2;
Y = .75;

legend = 'Base';
title_plot = 'CGMY Density';

func = @(x) cf_cgmy(x,T,0,r,d, C, G, M, Y);
y = fftdensity(func,a,N);
%% Changing C
C_low = 1;
C_high = 3;

func_low = @(x) cf_cgmy(x,T,0,r,d, C_low,G,M,Y);
y_low = fftdensity(func_low,a,N);
func_high = @(x) cf_cgmy(x,T,0,r,d, C_high,G,M,Y);
y_high = fftdensity(func_high,a,N);
legend_low = 'Changing C low';
legend_high = 'Changing C high';

createfigure_density(x,y,y_low,y_high,title_plot,legend,legend_low,legend_high);

%% Changing G
G_low = 1.5;
G_high = 2.5;

func_low = @(x) cf_cgmy(x,T,0,r,d, C,G_low,M,Y);
y_low = fftdensity(func_low,a,N);
func_high = @(x) cf_cgmy(x,T,0,r,d, C,G_high,M,Y);
y_high = fftdensity(func_high,a,N);
legend_low = 'Changing G low';
legend_high = 'Changing G high';

createfigure_density(x,y,y_low,y_high,title_plot,legend,legend_low,legend_high);

%% Changing M
M_low = 1.5;
M_high = 2.5;

func_low = @(x) cf_cgmy(x,T,0,r,d, C,G,M_low,Y);
y_low = fftdensity(func_low,a,N);
func_high = @(x) cf_cgmy(x,T,0,r,d, C,G,M_high,Y);
y_high = fftdensity(func_high,a,N);
legend_low = 'Changing M low';
legend_high = 'Changing M high';

createfigure_density(x,y,y_low,y_high,title_plot,legend,legend_low,legend_high);

%% Changing Y
Y_low = -0.5;
Y_high = 1.2;

func_low = @(x) cf_cgmy(x,T,0,r,d, C,G,M,Y_low);
y_low = fftdensity(func_low,a,N);
func_high = @(x) cf_cgmy(x,T,0,r,d, C,G,M,Y_high);
y_high = fftdensity(func_high,a,N);
legend_low = 'Changing Y low';
legend_high = 'Changing Y high';

createfigure_density(x,y,y_low,y_high,title_plot,legend,legend_low,legend_high);
