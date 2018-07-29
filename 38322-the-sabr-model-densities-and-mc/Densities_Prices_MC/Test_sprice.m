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

% Illustration of density truncations for SABR model

clear; clc;

a = 0.25; b = 0.5; r = -.5; f = 0.08; t =1; n = 0.2;    % sabr parameters

x_val = 0.0001:0.0001:0.5;
m = 1.775;

tic;
[kl, mu, cl, bl, al, ku, nu, cu, bu, au] = ...
    psabr_param(a, b, r, n, f, x_val, t,m);    % calculate the parameters

y_val = sprice_5(a, b, r, n, f, x_val, t, ...
    kl, ku, mu, cl, bl,al, nu, cu,bu,au, 1);   % calculate the density
toc
figure; plot(x_val,y_val);