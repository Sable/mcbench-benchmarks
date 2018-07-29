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
% Density NIG Model
%
%   
%
t = 1;                                      % maturity
f0 = 100;                                  % spot value

x = 90:.01:110;                            % range
xret = log(x/100);
alpha = 5;
beta = 0;                            % CEV exponent base scenario
delta = 5;
mu = 0;
legend = 'Base';
title_plot = 'NIG Density';

y = pnig(x,f0,t,0,alpha, beta,delta);
%% Changing alpha
alpha_low = 1;
alpha_high = 10;

y_low = pnig(x,f0,t,0,alpha_low, beta,delta);
y_high = pnig(x,f0,t,0,alpha_high, beta,delta);
legend_low = 'Changing \alpha low';
legend_high = 'Changing \alpha high';

createfigure_density(xret,y,y_low,y_high,title_plot,legend,legend_low,legend_high);

%% Changing beta
beta_low = -3;
beta_high = 3;

y_low = pnig(x,f0,t,0,alpha, beta_low,delta);
y_high = pnig(x,f0,t,0,alpha, beta_high,delta);
legend_low = 'Changing \beta low';
legend_high = 'Changing \beta high';

createfigure_density(xret,y,y_low,y_high,title_plot,legend,legend_low,legend_high);


%% Changing delta
delta_low = 1;
delta_high = 10;

y_low = pnig(x,f0,t,0,alpha, beta,delta_low);
y_high = pnig(x,f0,t,0,alpha, beta,delta_high);
legend_low = 'Changing \delta low';
legend_high = 'Changing \delta high';

createfigure_density(xret,y,y_low,y_high,title_plot,legend,legend_low,legend_high);


