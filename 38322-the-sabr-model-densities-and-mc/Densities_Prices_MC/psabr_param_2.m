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


function [kl, cl, bl, al, ku, cu, bu, au] = psabr_param_2(a, b, r, n, ...
    f, k, t,mu,nu, kl, ku)
% calculates the parameters for the parametric density of the tails
% this can be used with the SABR density approximation by Kienitz
% the parameters are the ones which fit to second order at kl and ku
% calculate all values assuming standard decay parameters mu and nu
% need m as input for determining the cut off point of left tail

m = kl/f;

eps = 1e-004;                              % .1 bp                           

s = @(x) psabr(a, b, r, n, f, x, t);
index = find(s(k)>0,1,'first');

if isempty(index)
   kl = .25 *f;
else  
   kl = max(.25 * f,k(index)+(f-k(index))/m);% lower strike level (free parameter)  
end
s1 = s(kl-eps);                             % for calc of derivatives
s2 = s(kl);                                 % for calc of derivatives
s3 = s(kl+eps);                             % for calc of derivatives

V1 = log(s2);                               % log density

U2 = (s3-s1)/(2*eps);                       % derivative of the density
V2 = U2/s2;                                 % derivative of the log density

U3 = (s3-2*s2+s1)/eps^2;                    % second derivative of the density
V3 = U3/s2 - V2^2;                          % second derivative of the log density

% fix mu and solve 
%       V1 = mu log kl + a + b kl + c kl^2
%       V2 = mu / kl + b + 2c kl
%       V3 = - mu / kl^2 + 2c

cl = .5*(V3+mu/kl^2); 
bl = V2-mu/kl - 2*cl*kl; 
al = V1 - mu * log(kl) - bl*kl - cl*kl^2;

index = find(s(k(k>f))<0.0001,1,'first');

if isempty(index)
   ku = 25.5 * f;
   % ku = ku;
else  
   ku = k(index);  
end

s = @(x) psabr(a, b, r, n, f, x, t);        % sabr price (1) for calls
s1 = s(ku-eps);                             % for calc of derivatives
s2 = s(ku);                                 % for calc of derivatives
s3 = s(ku+eps);                             % for calc of derivatives

V1 = log(s2);                               % log call price

U2 = (s3-s1)/(2*eps);                       % derivative of the density
V2 = U2/s2;                                 % derivative of the log density                                   

U3 = (s3-2*s2+s1)/eps^2;                    % second derivative of the density
V3 = U3/s2 - (U2/s2)^2;                     % second derivative f the density

% fix nu and solve
%       V1 = -nu log ku + a + b/ku + c/ku^2
%       V2 = -nu / ku - b / ku^2 - 2c/ku^3    
%       V3 = nu / ku^2 + 2 b / ku^3 - 6 c / ku^4

cu = (-1.5*nu / ku + .5*V3 * ku - V2)*ku^3/5;  
bu = -ku^2*(V2 + nu/ku +2*cu/ku^3); 
au = V1 + nu * log(ku) - bu / ku - cu / ku^2; 
                                                            % output
end