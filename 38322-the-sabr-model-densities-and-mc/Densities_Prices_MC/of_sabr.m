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

% Calibrating kl, ku, mu and nu for a sabr model
% the prices are calculated from known sabr parameters

function y = of_sabr(a, b, r, n, f, k, t, mu, nu, kl, ku, call, put)
% objective function for SABR calibration
    [kl, cl, bl, al, ku, cu, bu, au] = ...
        psabr_param_2(a, b, r, n, f, k, t,mu,nu, kl, ku);
    
    callkl = interp1(k,call,kl);        % get value at kl
    putku = interp1(k,put,ku);          % get value at ku
    
    % using only call or put prices is enough
    % can use put left of atm and calls right!!!
    % that is put for [kl,f) and calls (f,ku]
    y = (sprice_5(a, b, r, n, f, kl, t, kl, ku, ...
        mu, cl, bl,al, nu, cu,bu,au, 1) ...
        - callkl)^2;           % call prics
    y = y + (sprice_5(a, b, r, n, f, 0, t, kl, ku, ...
        mu, cl, bl,al, nu, cu,bu,au, 0) ...
        - f)^2;                % atm price
    y = y + (sprice_5(a, b, r, n, f, ku, t, kl, ku, ...
        mu, cl, bl,al, nu, cu,bu,au, 0) ...
        - putku)^2;            % put prices