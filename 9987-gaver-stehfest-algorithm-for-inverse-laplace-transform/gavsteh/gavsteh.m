%
%  ilt=gavsteh(funname,t,L)
%
%    funname       The name of the function to be transformed.
%    t             The transform argument (usually a snapshot of time).
%    ilt             The value of the inverse transform 
%    L              number of coefficient ---> depends on computer word length used
%                   (examples: L=8, 10, 12, 14, 16, so on..)
%
%  Wahyu Srigutomo
%  Physics Department, Bandung Institute of Tech., Indonesia, 2006
%  Numerical Inverse Laplace Transform using Gaver-Stehfest method
%
%Refferences:
% 1. Villinger, H., 1985, Solving cylindrical geothermal problems using
%   Gaver-Stehfest inverse Laplace transform, Geophysics, vol. 50 no. 10 p.
%   1581-1587
% 2. Stehfest, H., 1970, Algorithm 368: Numerical inversion of Laplace transform,
%    Communication of the ACM, vol. 13 no. 1 p. 47-49
%
% Simple (and yet rush) examples included in functions fun1 and fun2 with
% their comparisons to the exact value (use testgs.m to run the examples)
function ilt=gavsteh(funname,t,L)
nn2 = L/2;
nn21= nn2+1;

for n = 1:L
    z = 0.0;
	for k = floor( ( n + 1 ) / 2 ):min(n,nn2)
        z = z + ((k^nn2)*factorial(2*k))/ ...
            (factorial(nn2-k)*factorial(k)*factorial(k-1)* ...
            factorial(n-k)*factorial(2*k - n));
    end
    v(n)=(-1)^(n+nn2)*z;
end

sum = 0.0;
ln2_on_t = log(2.0) / t;
for n = 1:L
    p = n * ln2_on_t;
    sum = sum + v(n) * feval(funname,p);
end 
	ilt = sum * ln2_on_t;
    
