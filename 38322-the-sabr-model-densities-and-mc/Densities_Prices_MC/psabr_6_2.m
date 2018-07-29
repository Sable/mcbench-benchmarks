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

function y = psabr_6_2(a, b, r, n, f, k, t,m, mu, nu, l, u)
% sabr prices using an admissible region kl <= k <= ku where sabr is used
% for 0 <= k <= kl    we use a put pricing function 
%           f(x) = x^mu exp(a + bx + cx^2)
% for ku < k < +infty we use a call pricing function 
%           f(x) = x^(-nu) exp(a + bx^(-1) + cx(-2)
% a big range (small kl and big ku) guarantee that the prices are in line
% with the observed calls and puts
%
% this is the preferred version of the density for computations
%

eps = 1e-004;                              % .1 bp                           

s = @(x) psabr_6(a, b, r, n, f, x, t,1);
index = find(s(k)>0,1,'first');

if (isempty(index) || index == 1)
   kl = l *f;
else  
   kl = max(l * f,k(index)+(f-k(index))/m);% lower strike level  
end
s1 = s(kl-eps);                          % for calc of derivatives
s2 = s(kl);                              % for calc of derivatives
s3 = s(kl+eps);                          % for calc of derivatives

V1 = log(s2);                            % log density

U2 = (s3-s1)/(2*eps);                    % derivative of density
V2 = U2/s2;                              % derivative of log density

U3 = (s3-2*s2+s1)/eps^2;                 % second derivative of density
V3 = U3/s2 - V2^2;                       % second derivative of log density

% fix mu and solve 
%       V1 = mu log kl + a + b kl + c kl^2
%       V2 = mu / kl + b + 2c kl
%       V3 = - mu / kl^2 + 2c

%mu = 1.5;                               % controls the left tails
cl = .5*(V3+mu/kl^2); 
bl = V2-mu/kl - 2*cl*kl; 
al = V1 - mu * log(kl) - bl*kl - cl*kl^2;

% upper strike level (the bigger the strike level the better fit the call
% prices to Hagan formula!)
ku = u * f;                                
s = @(x) psabr_6(a, b, r, n, f, x, t,1);        % sabr price (1) for calls
s1 = s(ku-eps);                             % for calc of derivatives
s2 = s(ku);                                 % for calc of derivatives
s3 = s(ku+eps);                             % for calc of derivatives

V1 = log(s2);                               % log call price

U2 = (s3-s1)/(2*eps);                       % derivative of  density
V2 = U2/s2;                                 % derivative of log density                                   

U3 = (s3-2*s2+s1)/eps^2;                    % second derivative of density
V3 = U3/s2 - (U2/s2)^2;                     % second derivative of density

% fix nu and solve
%       V1 = -nu log ku + a + b/ku + c/ku^2
%       V2 = -nu / ku - b / ku^2 - 2c/ku^3    
%       V3 = nu / ku^2 + 2 b / ku^3 - 6 c / ku^4

cu = (-1.5*nu / ku + .5*V3 * ku - V2)*ku^3/5;  
bu = -ku^2*(V2 + nu/ku +2*cu/ku^3); 
au = V1 + nu * log(ku) - bu / ku - cu / ku^2; 

    yl = real(k(k<kl).^mu .* exp(al + bl .* k(k<kl) + cl * k(k<kl).^2));
    ym = real(psabr_6(a,b,r,n,f,k((kl<=k)&(k<=ku)),t,1));                
    yu = real(k(k>ku).^(-nu) .* exp(au+bu./k(k>ku)+cu./k(k>ku).^2));  
    

y = [yl ym yu];                            % output
end