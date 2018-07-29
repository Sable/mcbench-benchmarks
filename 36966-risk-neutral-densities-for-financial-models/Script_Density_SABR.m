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



t = 0;              % current time
T = 1;              % maturity

F = 80:.25:120;       % possible forwards in T
A = 0.01:0.01:0.4;  % possible volatilities in T

f = 100;            % current spot asset
alpha = 0.2;        % current spot volatility

beta = 0.5;         % SABR CEV coeff
nu = 0.2;           % Vol of vol
rho = 0;         % Correlation

d_base = @(x,y) psabr(t,T,f,x,alpha,y,beta,nu,rho);   % approx density

xret = ((F-f)/f);   % possible relative changes

low = 0;            % limit integration low
up = 1;             % limit integration high

y_base = density1d(F,d_base,low,up);    % compute density
legend_base = 'Base';
title_plot = 'SABR Density';

y2_base = density2d(F,A,d_base);

%% Change alpha
d_low = @(x,y) psabr(t,T,f,x,alpha-0.1,y,beta,nu,rho); % low density
d_high = @(x,y) psabr(t,T,f,x,alpha+0.1,y,beta,nu,rho);% high density

y_low = density1d(F,d_low,low,up);
y_high = density1d(F,d_high,low,up);
legend_low = 'Changing \alpha low';
legend_high = 'Changing \alpha high';

createfigure_density(xret,y_base',y_low',y_high',title_plot,legend_base,legend_low,legend_high);

%% change beta
d_low = @(x,y) psabr(t,T,f,x,alpha,y,beta-.2,nu,rho); % low density
d_high = @(x,y) psabr(t,T,f,x,alpha,y,beta+.2,nu,rho);% high density

y_low = density1d(F,d_low,low,up);
y_high = density1d(F,d_high,low,up);
legend_low = 'Changing \beta low';
legend_high = 'Changing \beta high';

createfigure_density(xret,y_base',y_low',y_high',title_plot,legend_base,legend_low,legend_high);

y2_low = density2d(F,A,d_low);
y2_high = density2d(F,A,d_high);

create_density_2d(F',A,y2_low', y2_base', y2_high', legend_low, legend_base, legend_high, title_plot);

%% change nu
d_low = @(x,y) psabr(t,T,f,x,alpha,y,beta,nu-.1,rho); % low density
d_high = @(x,y) psabr(t,T,f,x,alpha,y,beta,nu+.1,rho);% high density

y_low = density1d(F,d_low,low,up);
y_high = density1d(F,d_high,low,up);
legend_low = 'Changing \nu low';
legend_high = 'Changing \nu high';

createfigure_density(xret,y_base',y_low',y_high',title_plot,legend_base,legend_low,legend_high);

%% change rho
d_low = @(x,y) psabr(t,T,f,x,alpha,y,beta,nu,rho-.6); % low density
d_high = @(x,y) psabr(t,T,f,x,alpha,y,beta,nu,rho+.6);% high density

y_low = density1d(F,d_low,low,up);
y_high = density1d(F,d_high,low,up);
legend_low = 'Changing \rho low';
legend_high = 'Changing \rho high';

createfigure_density(xret,y_base',y_low',y_high',title_plot,legend_base,legend_low,legend_high);