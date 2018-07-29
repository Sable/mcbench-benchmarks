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

function y = sprice_2(a, b, r, n, f, k, t,cp)
% sabr prices using an admissible region kl <= k <= ku where sabr is used
% for 0 <= k <= kl    
% we use a put pricing function f(x) = K^mu exp(a + bx + cx^2)
% for ku < k < +infty 
% we use a call pricing function f(x) = K^(-nu) exp(a + bx^(-1) + cx(-2)
eps = 1e-004;

%find index where density is positive
s = @(x) psabr(a, b, r, n, f, x, t);
index = find(s(k)<0,1,'last');

if isempty(index)
   kl = .25 *f;
else  
   kl = max(.25 * f,k(index+1));% lower strike level (free parameter)  
end

%kl = .5 * f;                               % lower strike level

s = @(x) sprice(a, b, r, n, f, x, t,-1);    % sabr price (-1) for puts

s1 = s(kl-eps);                             % for calc of derivatives
s2 = s(kl);                                 % for calc of derivatives
s3 = s(kl+eps);                             % for calc of derivatives

V1 = log(s2);                               % log put price

U2 = (s3-s1)/(2*eps);                           % derivative of the price
V2 = U2/s2;                                 % derivative of the log price

U3 = (s3-2*s2+s1)/eps^2;                    % second derivative of the price
V3 = U3/s2 - V2^2;                     % second derivative of the log price

% fix mu and solve 
%       V1 = mu log kl + a + b kl + c kl^2
%       V2 = mu / kl + b + 2c kl
%       V3 = - mu / kl^2 + 2c

mu = -V3*kl^2; bl = V2 - mu / kl; al = V1 - mu *log(kl) - bl * kl;


ku = 15 * f;                               % upper strike level
s = @(x) sprice(a, b, r, n, f, x, t,1);     % sabr price (1) for calls
s1 = s(ku-eps);                             % for calc of derivatives
s2 = s(ku);                                 % for calc of derivatives
s3 = s(ku+eps);                             % for calc of derivatives

V1 = log(s2);                               % log call price

U2 = (s3-s1)/(2*eps);                           % derivative of the price
V2 = U2/s2;                                 % derivative of the log price                                   

U3 = (s3-2*s2+s1)/eps^2;                    % second derivative of the price
V3 = U3/s2 - (U2/s2)^2;                     % second derivative f the price

% fix nu and solve
%       V1 = -nu log ku + a + b/ku + c/ku^2
%       V2 = -nu / ku - b / ku^2 - 2c/ku^3    
%       V3 = nu / ku^2 + 2 b / ku^3 - 6 c / ku^4

nu = 2; cu = (-1.5*nu / ku + .5*V3 * ku - V2)*ku^3/5;  
bu = -ku^2*(V2 + nu/ku +2*cu/ku^3); 
au = V1 + nu * log(ku) - bu / ku - cu / ku^2; 


% the sabr volatility for the admissible region kl <= k <= ku
sigma = svol(a,b,r,n,f,k((kl<=k)&(k<=ku)),t);

    d1= (log(f./k((kl<=k)&(k<=ku)))+(0.5*t*sigma.*sigma))./(sqrt(t)*sigma); % BS d1 with sabr vol
    d2= (log(f./k((kl<=k)&(k<=ku)))-(0.5*t*sigma.*sigma))./(sqrt(t)*sigma); % BS d2 with sabr vol

if cp==1
    yu = k(k>ku).^(-nu) .* exp(au+bu./k(k>ku)+cu./k(k>ku).^2);              % call price ku < k < +infty
    ym = f.*normcdf( d1,0,1)-k((kl<=k)&(k<=ku)).*normcdf( d2,0,1);          % admissible region kl <= k <= ku
    yl = k(k<kl).^mu .* exp(al + bl.*k(k<kl)) + f - k(k<kl); % call price using call-put parity 0<= k < kl
else
    yl = k(k<kl).^mu .* exp(al + bl .* k(k<kl));               % put price 0<= k < kl
    ym = k((kl<=k)&(k<=ku)).*normcdf(-d2,0,1)-f.*normcdf(-d1,0,1);          % admissible region kl <= k <= ku
    yu = k(k>ku).^(-nu) .* exp(au+bu./k(k>ku)+cu./k(k>ku).^2) - f + k(k>ku);% put prices using call-out parity ku < k < +infty
end

y = [yl ym yu];                                                             % output
end