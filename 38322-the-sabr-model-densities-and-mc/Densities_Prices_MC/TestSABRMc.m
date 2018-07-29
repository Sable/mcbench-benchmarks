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

% We test the performance of the inverse method using numerical 
% algorithms based on the Kienitz extrapolation methodology
% for generating MC densities and we compare against analytic values

% Generate random numbers from a SABR density using numerical inversion
% of the cumulated probability and the density truncation method

clear; clc;
NSim = 100000;          % number of simulations
U = rand(1,NSim);       % uniforms

% sabr parameters
t =1;
% a = 0.25; b = 0.5; r = -.5;  f = 0.03;  n = 0.2;
% b= 0.5; r=-0.1595; f=0.0495;  n=0.3843;  a=0.1339 * f^(1-b); 
b = 0.5;n=0.2;r=-0.2;f=0.03; a=0.9*f^(1-b);
% calibrate the parameters
[kl, mu, cl, bl, al, ku, nu, cu, bu, au] = ...
    psabr_param(a, b, r, n, f, 0.0001:0.0001:0.2, t,4);

% apply the calibrated density
d = @(x) psabr_5(a, b, r, n, f, x, t, ...
    kl, ku, mu, cl, bl, al, nu, cu, bu, au);

x_sabr = 0.001:0.0001:1;                % x_values for table
tic;
y_sabr = FSABR2_1(x_sabr,d);            % values for the table
US = FInvSABR4_2(U,x_sabr, y_sabr);     % inversion using table
toc

nbins = 150;
Nzero = sum(US==1);
Pzero = Nzero / NSim;
[n,xout] = hist(US,nbins);                % calc histogram
n(end) = 0;
pdensity = n/NSim*nbins; cdensity = cumsum(n) / NSim;

n(end) = 0;                             % remove artefact
figure;bar(n/nbins);                    % plot histogram
x = 0:.0001:1;                          % x values for plot
y = d(x);                               % calculate the density
Y = sum(y)*0.0001;
y(1) = 1-Y;
figure('Color', [1 1 1]);
hold on; plot([0 xout],[Pzero pdensity],'ro-'); plot(x,y); xlim([0,.2]); hold off; % plot sim against value
xlabel('Strike'); ylabel('Density p(x)'); 
x = [0 xout];                          % x values for plot
y = d(x); 

figure('Color', [1 1 1]);
hold on; plot(x,[Pzero pdensity],'ro-'); plot(x,y,'gx-'); xlim([0,.25]); hold off; % plot sim against value

figure('Color', [1 1 1]);
plot(x,([Pzero pdensity] - y)./y); xlim([0,.25]); hold off; % plot sim against value

