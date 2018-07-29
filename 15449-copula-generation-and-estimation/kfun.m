function d = kfun(family,x,alpha)
%KFUN Goodness-of-fit test for Archimedean copulas.
%   D = KFUN(FAMILY,X,ALPHA) returns Mean Squared Error for empirical
%   and theoretical values on the main diagonal of bivariate copula.
% 
%   Written by Robert Kopocinski, Wroclaw University of Technology,
%   for Master Thesis: "Simulating dependent random variables using copulas.
%   Applications to Finance and Insurance".
%   Date: 2007/05/12
%
%   Reference:
%      [1]  Barbe, P. and Genest, C. and Ghoudi, K. and Remillard, B. (1996)
%           On Kendall's process, Journal of Multivariate Analysis, 58:197-229
%

[m n]=size(x);

w = 1/m:1/m:1; %grid

for i=1:m
    z(i) = sum((x(:,1)<x(i,1)).*(x(:,2)<x(i,2)))/(m-1);
end

for i=1:m
    t(i)=sum(z'<=w(i))/m;   %empirical copula on the main diagonal
end

switch family
    case 'clayton'
        y = w*(1+1/alpha)-1/alpha*w.^(alpha+1);
    case 'frank'
        y = w + (log((exp(-alpha*w)-1)./(exp(-alpha)-1))).*(exp(-alpha*w)-1)/alpha./exp(-alpha*w);
    case 'gumbel'
        y = w.*(1-1/alpha*log(w));
    otherwise
        error('Unrecognized copula family: ''%s''',family);
end

d = sum((t-y).^2)/m

plot(w,w-t,'k','LineWidth',2) %comparsion of u - K(u)
hold on
plot(w,w-y,'b:','LineWidth',1)
