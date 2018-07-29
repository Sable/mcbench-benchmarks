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

% Calibrating kl, and ku for a sabr model for Kienitz extrapolation
% the prices are calculated from known sabr parameters

f = 0.03; t =1;                         % forward and time
a = 0.25; b = 0.5; r = -.5;  n = 0.2;   % sabr parameters
mu = 1.5; nu = 3;                       % tail decay

k = 0.001:0.0001:1;                         % strike range

call = sprice(a, b, r, n, f, k, t,1);   % call prices (standard sabr)
put = sprice(a, b, r, n, f, k, t,0);    % put prices (standard sabr)
put(1) = 0;
call(1) = f;                            % assures forward is matched

Nparam = 2;                             % number of calibrated params

% objective function
of = @(x) of_sabr(a, b, r, n, f, k, t, mu, nu, x(1), x(2), call, put);

x0 = [.25*f; 25.5*f];                   % starting values               

A = zeros(Nparam,Nparam); bc= zeros(Nparam,1);
Aeq = A; beq = bc;
lb = [.25*f; f];                        % lower bound
ub = [f; 30*f];                         % upper bound

y = fmincon(of,x0,A,bc,Aeq,beq,lb,ub);  % optimization

% verification of results
xval = 0:0.001:.25;                     % x-values
[cl, bl, al, cu, bu, au] = ...
    psabr_param_3(a, b, r, n, f, t,mu,nu,y(1),y(2));
yval = psabr_5(a, b, r, n, f, xval, t, y(1), y(2), ...
           mu, cl, bl,al, nu, cu,bu,au);% y-values calculated

plot(xval,yval);                        % plot the results
Factor = 1000000;                       % used for plotting

yval_call = sprice_5(a, b, r, n, f, xval, t, y(1), y(2), ...
    mu, cl, bl,al, nu, cu,bu,au, 1);    % SABR Call prices
figure; hold on; 
    plot(xval,Factor*yval_call,'r'); 
    plot(k,Factor*call,'g'); 
hold off;

yval_put = sprice_5(a, b, r, n, f, xval, t, y(1), y(2), ...
    mu, cl, bl,al, nu, cu,bu,au, 0);    % SABR Put prices
figure; hold on; 
    plot(xval,Factor*yval_put,'r'); 
    plot(k,Factor*put,'g'); 
hold off;

fval = sprice_5(a, b, r, n, f, 0, t, y(1), y(2), ...
    mu, cl, bl,al, nu, cu,bu,au, 1);    % calculate forward value
y                                       % calibrated values
f - fval                                % display difference to forward
