function b = bernsteincop(x,g)
%BERNSTEINCOP Bernstrein Empirical copula based on sample X.
%   B = BERNSTEINCOP(X,G) returns bivariate bernstein empirical copula
%   for GxG points grid. Extension to n dimensional bernstein empirical
%   copula is straightforward.
%
%   Written by Robert Kopocinski, Wroclaw University of Technology,
%   for Master Thesis: "Simulating dependent random variables using copulas.
%   Applications to Finance and Insurance".
%   Date: 2007/05/12
%
%   Reference:
%      [1]  Durrleman, V. and Nikeghbali, A. and Roncalli, T. (2000) Copulas approximation and
%           new families, Groupe de Recherche Operationnelle Credit Lyonnais

c = ecopula(x);

[m n] = size(c);

b=zeros(g);

for i=1:g
    for j=1:g
        b(i,j)=sum(sum( bernstein(i/g,1:m,m)'*(bernstein(j/g,1:m,m)).*c ));
    end
end

%------------------------------------------------------------
function y = bernstein(u,i,n)
% BERNSTEIN calculates values of Bernstein polynomials.

y = factorial(n)./factorial(i)./factorial(n-i).*u.^i.*(1-u).^(n-i);