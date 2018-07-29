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
% Density CEV Model

t = 10;                                      % maturity
f0 = 0.03;                                  % spot value

figname = 'Risk Neutral Density - CEV';

x = 0:0.001:2;                            % range

sigma_base = 0.2;                           % volatility base scenario
beta_base = 0.5;                            % CEV exponent base scenario

y_base = pcev(t,x,f0,sigma_base, beta_base);
legendname_base = 'Base';
%% Changing sigma_base
sigma_low = 0.15;
sigma_high = 0.25;

y_low = pcev(t,x,f0,sigma_low, beta_base);
y_high = pcev(t,x,f0,sigma_high, beta_base);

legendname_low = 'Changing \sigma low value';
legendname_high = 'Changing \sigma high value';

createfigure_density(x,y_base,y_low,y_high,...
    figname, legendname_base,legendname_low,legendname_high);

%% Changing beta_base
beta_low = 0.3;
beta_high = 0.7;

y_low = pcev(t,x,f0,sigma_base, beta_low);
y_high = pcev(t,x,f0,sigma_base, beta_high);

legendname_low = 'Changing \beta low value';
legendname_high = 'Changing \beta high value';

createfigure_density(x,y_base,y_low,y_high,...
    figname, legendname_base,legendname_low,legendname_high);
