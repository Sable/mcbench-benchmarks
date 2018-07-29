function [mu,h, k, n] = garchkcore(parameters, data, ar, ma, x, p, q, y, m, z, v, T, garchtype)
%{
-----------------------------------------------------------------------
 PURPOSE:
 Estimation of conditional mean, variance and kurtosis
-----------------------------------------------------------------------
 USAGE:
 [mu,h, k, n] = garchkcore(parameters, data, ar, ma, x, p, q, y, m, z, v, T, garchtype)

 INPUTS:
 parameters:	vector of parameters
 data:         (T x 1) vector of data
 ar:        positive scalar integer representing the order of AR
 am:        positive scalar integer representing the order of MA
 x:         (T x N) vector of factors for the mean process
 p:         positive scalar integer representing the order of ARCH
 q:         positive scalar integer representing the order of GARCH
 y:         (T x N) vector of factors for the volatility process, must be positive!
 garchtype: GARCH model

 OUTPUTS:
 mu:           conditional mean
 h:            conditional variance
 k:            conditional kurtosis
 n:            degress of freedom
-----------------------------------------------------------------------
 Author:
 Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
 Date:     11/2011
-----------------------------------------------------------------------
%}
% Verifying that the vector of parameters is a column vector
[r,c] = size(parameters);
if c>r
    parameters = parameters';
    [r,c] = size(parameters);
end

% Initial parameters
mu = [];
h = [];
k = [];
n = [];

mu(1:m,1) = parameters(1);
h(1:m,1) = var(data); 
k(1:m,1) = kurtosis(data)-3;
n(1:m,1) = 4;

% Dimension of factors
if isscalar(x)
    xy=zeros(size(data,1),1);    
else
    xy=x;
end

if isscalar(y)
    yy=zeros(size(data,1),1);    
else
    yy=y;
end

switch garchtype
    case 1 % GARCH
        for t = (m+1):T; 
            mu(t,1) = parameters(1:1+z)'*[1; data(t-(1:ar)); data(t-(1:ma))-mu(t-(1:ma),1); xy(t,:)*ones((isscalar(x) < 1))];
            h(t,1) = parameters(2+z:2+z+p+q+v)'*[1; (data(t-(1:p)) - mu(t-(1:p),1)).^2; h(t-(1:q)); yy(t,:)*ones((isscalar(y) < 1))];
            k(t,1) = parameters(3+z+p+q+v:3+z+2*p+2*q+v)'*[1; ((data(t-(1:p)) - mu(t-(1:p),1)).^4)./h(t-(1:p)).^2; k(t-(1:q))+3];
            n(t,1) = (2.*(2*k(t,1)-3))./(k(t,1)-3);
            %l(t,1) = ((h(t,1).*(n(t,1)-2))./n(t,1)).^0.5;
        end
    case 2 % GJR
        for t = (m+1):T
            mu(t,1) = parameters(1:1+z)'*[1; data(t-(1:ar)); data(t-(1:ma))-mu(t-(1:ma),1); xy(t,:)*ones((isscalar(x) < 1))];
            h(t,1) = parameters(2+z:2+z+2*p+q+v)'*[1; (data(t-(1:p)) - mu(t-(1:p))).^2; h(t-(1:q)); yy(t,:)*ones((isscalar(y) < 1)) ;((data(t-(1:p)) - mu(t-(1:p)))<0).*((data(t-(1:p)) - mu(t-(1:p))).^2)];
            k(t,1) = parameters(3+z+2*p+q+v:3+z+3*p+2*q+v)'*[1; ((data(t-(1:p)) - mu(t-(1:p),1)).^4)./h(t-(1:p)).^2; k(t-(1:q))+3];
            n(t,1) = (2.*(2*k(t,1)-3))./(k(t,1)-3);
        end
    case 3 % AGARCH
        asym=parameters(3+z+p+q:2+z+2*p+q+v);
        for t = (m+1):T; 
            mu(t,1) = parameters(1:1+z)'*[1; data(t-(1:ar)); data(t-(1:ma))-mu(t-(1:ma),1); xy(t,:)*ones((isscalar(x) < 1))];
            h(t,1) = parameters(2+z:2+z+p+q+v)'*[1; ((data(t-(1:p)) - mu(t-(1:p))) - asym).^2; h(t-(1:q)); yy(t,:)*ones((isscalar(y) < 1))];
            k(t,1) = parameters(3+z+2*p+q+v:3+z+3*p+2*q+v)'*[1; ((data(t-(1:p)) - mu(t-(1:p),1)).^4)./h(t-(1:p)).^2; k(t-(1:q))+3];
            n(t,1) = (2.*(2*k(t,1)-3))./(k(t,1)-3);
        end
    case 4 % NAGARCH
        asym=parameters(3+z+p+q:2+z+2*p+q+v);
        for t = (m+1):T; 
            mu(t,1) = parameters(1:1+z)'*[1; data(t-(1:ar)); data(t-(1:ma))-mu(t-(1:ma),1); xy(t,:)*ones((isscalar(x) < 1))];
            h(t,1) = parameters(2+z:2+z+p+q+v)'*[1; ((data(t-(1:p)) - mu(t-(1:p))) - asym).^2; h(t-(1:q)); yy(t,:)*ones((isscalar(y) < 1))];
            k(t,1) = parameters(3+z+2*p+q+v:3+z+3*p+2*q+v)'*[1; ((data(t-(1:p)) - mu(t-(1:p),1)).^4)./h(t-(1:p)).^2; k(t-(1:q))+3];
            n(t,1) = (2.*(2*k(t,1)-3))./(k(t,1)-3);
        end
        
end

end
