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


function y = sprice_1_1(a, b, r, n, f, k, t,cp)
% Price Extrapolation
s = @(x) sprice(a, b, r, n, f, x, t,-1);
eps = 0.00001;

kl = 0.5 * f;
s1 = log(s(kl-eps)); s2 = log(s(kl)); s3 = log(s(kl+eps));
V1 = s2; V2 = (s2-s1)/eps; V3 = (s3-2*s2+s1)/eps^2;

mu = 2; cl = .5*mu/kl^2+0.5*V3; bl = V2-mu/kl - 2*cl*kl; al = V1+mu*log(kl)-b*kl-cl*kl^2;

s = @(x) sprice(a, b, r, n, f, x, t,1);
ku = 20.5 * f; 
s1 = log(s(ku-eps)); s2 = log(s(ku)); s3 = log(s(ku+eps));
V1 = s2; V2 = (s3-s2)/eps; V3 = (s3-2*s2+s1)/eps^2;

nu = 1; 
cu = (-1.5*nu / ku + .5*V3 * ku - V2)*ku^3/5;  bu = ku^2*(+nu/ku+2*cu/ku^3+V2); au = V1 + nu * log(ku) - bu / ku - cu / ku^2; 

sigma = svol_2(a,b,r,n,f,k,t);

if cp==1
    if (k > ku) 
        y = k.^(-nu) .* exp(au+bu./k+cu./k.^2);
    elseif ((kl <= k) && (k <= ku))
        d1= (log(f./k)+(0.5*t*sigma.*sigma))./(sqrt(t)*sigma);
        d2= (log(f./k)-(0.5*t*sigma.*sigma))./(sqrt(t)*sigma);
        y = f.*normcdf( d1,0,1)-k.*normcdf( d2,0,1);
    else
        y = k.^mu .* exp(al + bl.*k+cl.*k.^2)+f-k;
    end
else
    if(k<kl) 
        y = k.^mu .* exp(al + bl*k + cl*k.^2);
    elseif ((kl <= k) && (k <= ku))
        d1= (log(f./k)+(0.5*t*sigma.*sigma))./(sqrt(t)*sigma);
        d2= (log(f./k)-(0.5*t*sigma.*sigma))./(sqrt(t)*sigma);
        y = k.*normcdf(-d2,0,1)-f.*normcdf(-d1,0,1);
    else
        y = k.^(-nu) .* exp(au+bu./k+cu./k.^2)-k+f;
    end
end
end