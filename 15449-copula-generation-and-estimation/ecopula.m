function ecop = ecopula(x)
%ECOPULA Empirical copula based on sample X.
%   ECOP = ECOPULA(X) returns bivariate empirical copula. Extension to
%   n dimensional empirical copula is straightforward.
%
%   Written by Robert Kopocinski, Wroclaw University of Technology,
%   for Master Thesis: "Simulating dependent random variables using copulas.
%   Applications to Finance and Insurance".
%   Date: 2007/05/12
%
%   Reference:
%      [1]  Durrleman, V. and Nikeghbali, A. and Roncalli, T. (2000) Copulas approximation and
%           new families, Groupe de Recherche Operationnelle Credit Lyonnais

[m n] = size(x);

y = sort(x);

for i=1:m
    for j=1:m
        ecop(i,j) = sum( (x(:,1)<=y(i,1)).*(x(:,2)<=y(j,2)) )/m;
    end
end
