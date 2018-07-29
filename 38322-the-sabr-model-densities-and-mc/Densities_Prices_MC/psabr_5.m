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


function y = psabr_5(a, b, r, n, f, k, t, ...
    kl, ku, mu, cl, bl,al, nu, cu,bu,au)
% sabr prices using an admissible region kl <= k <= ku 
% for kl<k<ku apply standard sabr
% for 0 <= k <= kl    use  f(x) = K^mu exp(a + bx + cx^2)
% for ku < k < +infty use  f(x) = K^(-nu) exp(a + bx^(-1) + cx(-2)
% a big range (small kl and big ku) guarantee prices to be in line
% with the observed calls and puts
%
% this is the preferred version of the density for computations
% this version takes the parameters from a calibration                      

yl = real(k(k<kl).^mu .* exp(al + bl .* k(k<kl) + cl * k(k<kl).^2));
ym = real(psabr(a,b,r,n,f,k((kl<=k)&(k<=ku)),t));                
yu = real(k(k>ku).^(-nu) .* exp(au+bu./k(k>ku)+cu./k(k>ku).^2));   

y = [yl ym yu];                      % output
end
