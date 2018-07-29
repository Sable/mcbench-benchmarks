function corrtest(R)
%CORRTEST tests if R is correlation matrix.
%
%   Written by Robert Kopocinski, Wroclaw University of Technology,
%   for Master Thesis: "Simulating dependent random variables using copulas.
%   Applications to Finance and Insurance".
%   Date: 2007/05/12

[n m] = size(R);
if (m ~= n || n < 2)
   error('corrtest:BadCorrelation',...
         'The correlation matrix must be square');
end

if any(any(R ~= R'))
    error('corrtest:BadCorrelation','The correlation matrix must be symmetrical');
end    

s = diag(R);
if (any(s~=1))
    error('corrtest:BadCorrelation','The correlation matrix must have ones on the main diagonal');
end

p = eig(R);
if any(p <= 0)
   error('stats:mvnrnd:BadCorrelation',...
                    'The correlation matrix must be positive definite.');
end