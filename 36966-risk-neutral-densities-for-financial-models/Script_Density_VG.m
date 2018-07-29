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
% Density Variance Gamma Model
%
%   
%
t = 1;                                      % maturity
f0 = 100;                                  % spot value

x = 90:.01:110;                            % range
xret = log(x/100);

C_base = 3;
G_base = 3;                            % CEV exponent base scenario
M_base = 3;
r=0;

legend_base = 'Base';
title_plot = 'VG Density';
y_base = pvg(x, f0, t, r,C_base,G_base,M_base);

%% Changing alpha_base
C_low = 2;
C_high = 4;

y_low = pvg(x, f0, t, r,C_low,G_base,M_base);
y_high = pvg(x, f0, t, r,C_high,G_base,M_base);
legend_low = 'Changing C low';
legend_high = 'Changing C high';

createfigure_density(xret,y_base,y_low,y_high,title_plot,legend_base,legend_low,legend_high);

%% Changing beta_base
G_low = 1;
G_high = 5;

y_low = pvg(x, f0, t, r,C_base,G_low,M_base);
y_high = pvg(x, f0, t, r,C_base,G_high,M_base);
legend_low = 'Changing G low';
legend_high = 'Changing G high';

createfigure_density(xret,y_base,y_low,y_high,title_plot,legend_base,legend_low,legend_high);

%% Changing delta_base
M_low = 1;
M_high = 5;

y_low = pvg(x, f0, t, r,C_base,G_base,M_low);
y_high = pvg(x, f0, t, r,C_base,G_base,M_high);
legend_low = 'Changing M low';
legend_high = 'Changing M high';

createfigure_density(xret,y_base,y_low,y_high,title_plot,legend_base,legend_low,legend_high);


