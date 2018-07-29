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

function y = sprice_1(a, b, r, n, f, k, t, mu, nu, kl, ku, cp)
% sabr prices using an admissible region kl <= k <= ku where sabr is used
% for 0 <= k <= kl    
% we use a put pricing function f(x) = K^mu exp(a + bx + cx^2)
% for ku < k < +infty 
% we use a call pricing function f(x) = K^(-nu) exp(a + bx^(-1) + cx(-2)
%
% RBS paper (Kainth et al.)
%

eps = 0.00001;                              % calc fin diff grads

% lower tail

s = @(x) sprice(a, b, r, n, f, x, t,-1);    % sabr price (-1) for puts

s1 = s(kl-eps);                             % for calc of derivatives
s2 = s(kl);                                 % for calc of derivatives
s3 = s(kl+eps);                             % for calc of derivatives

V1 = log(s2);                               % log put price
U2 = (s3-s1)/(2*eps);                       % 1st deriv of the price
V2 = U2/s2;                                 % 1st deriv of the log price
U3 = (s3-2*s2+s1)/eps^2;                    % 2nd deriv of the price
V3 = U3/s2 - V2^2;                          % 2nd deriv of the log price

cl = .5*(V3+mu/kl^2); 
bl = V2-mu/kl - 2*cl*kl; 
al = V1 - mu * log(kl) - bl*kl - cl*kl^2;

% upper tail
s = @(x) sprice(a, b, r, n, f, x, t,1);     % sabr price (1) for calls
s1 = s(ku-eps);                             % for calc of derivatives
s2 = s(ku);                                 % for calc of derivatives
s3 = s(ku+eps);                             % for calc of derivatives

V1 = log(s2);                               % log call price
U2 = (s3-s1)/(2*eps);                       % 1st deriv of the price
V2 = U2/s2;                                 % 1st deriv of the log price                                   
U3 = (s3-2*s2+s1)/eps^2;                    % 2nd derivative of the price
V3 = U3/s2 - (U2/s2)^2;                     % 2nd deriv f the price

cu = (-1.5*nu / ku + .5*V3 * ku - V2)*ku^3/5;  
bu = -ku^2*(V2 + nu/ku +2*cu/ku^3); 
au = V1 + nu * log(ku) - bu / ku - cu / ku^2; 

% the sabr volatility for the admissible region kl <= k <= ku
sigma = svol_2(a,b,r,n,f,k((kl<=k)&(k<=ku)),t);

d1= (log(f./k((kl<=k)&(k<=ku)))+(0.5*t*sigma.*sigma))./(sqrt(t)*sigma); 
d2= (log(f./k((kl<=k)&(k<=ku)))-(0.5*t*sigma.*sigma))./(sqrt(t)*sigma);

if cp==1
    % call price ku < k < +infty
    yu = k(k>ku).^(-nu) .* exp(au+bu./k(k>ku)+cu./k(k>ku).^2);
    % admissible region kl <= k <= ku
    ym = f.*normcdf( d1,0,1)-k((kl<=k)&(k<=ku)).*normcdf( d2,0,1);
    % call price using call-put parity 0<= k < kl
    yl = k(k<kl).^mu .* exp(al + bl.*k(k<kl)+cl.*k(k<kl).^2) + f - k(k<kl); 
else
    % put price 0<= k < kl
    yl = k(k<kl).^mu .* exp(al + bl*k(k<kl) + cl*k(k<kl).^2);
    % admissible region kl <= k <= ku
    ym = k((kl<=k)&(k<=ku)).*normcdf(-d2,0,1)-f.*normcdf(-d1,0,1);
    % put prices using call-out parity ku < k < +infty
    yu = k(k>ku).^(-nu) .* exp(au+bu./k(k>ku)+cu./k(k>ku).^2) - f + k(k>ku);
end

y = [yl ym yu];                             % output
end