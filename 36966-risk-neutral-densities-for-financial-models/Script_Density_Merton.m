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
% Density Merton Model
%
%   
%
t = 5;                                      % maturity
f0 = 100;                                  % spot value

x = 75:.01:125;                            % range

muj = 0;                    % mean of jumps
sigmaj = 0.5411;                  % volatility of jumps
lambda = 0.7016;                  % jump intensity
sigma = 0.2518;

legend = 'Base';
title_plot = 'Merton Density';
y = pmerton(x, f0, t, sigma,0, 0, muj, sigmaj,lambda);
%% Changing sigmaj
muj_low = -0.5;
muj_high = 0.5;

y_low = pmerton(x, f0, t, sigma,0, 0, muj_low, sigmaj,lambda);
y_high = pmerton(x, f0, t, sigma,0, 0, muj_high, sigmaj,lambda);
legend_low = 'Changing \mu_j low';
legend_high = 'Changing \mu_j high';

createfigure_density(x,y,y_low,y_high,title_plot,legend,legend_low,legend_high);


%% Changing sigmaj
sigmaj_low = 0.0;
sigmaj_high = 0.5;

y_low = pmerton(x, f0, t, sigma,0, 0, muj, sigmaj_low,lambda);
y_high = pmerton(x, f0, t, sigma,0, 0, muj, sigmaj_high,lambda);
legend_low = 'Changing \sigma_j low';
legend_high = 'Changing \sigma_j high';

createfigure_density(x,y,y_low,y_high,title_plot,legend,legend_low,legend_high);

%% Changing lambda
lambda_low = 0;
lambda_high = 1;

y_low = pmerton(x, f0, t, sigma,0, 0, muj, sigmaj,lambda_low);
y_high = pmerton(x, f0, t, sigma,0, 0, muj, sigmaj,lambda_high);
legend_low = 'Changing \lambda low';
legend_high = 'Changing \lambda high';

createfigure_density(x,y,y_low,y_high,title_plot,legend,legend_low,legend_high);
