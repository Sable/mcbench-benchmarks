function [Series, Sigmas, Kurtosis] = garchksim(parameters, model, p, q, H, K, y, NumSamples, NumPaths)
%{
-----------------------------------------------------------------------
 PURPOSE: 
 Simulation of GARCH models
-----------------------------------------------------------------------
  USAGE:
  [Series, Sigmas] = garchsim(parameters, model, distr, p, q, H, NumSamples, NumPaths)
 
 INPUTS:
 parameters:    a vector of parameters (i.e. constant, ARCH, GARCH, Gamma, Delta, DoF)
 model:         'GARCH', 'GJR', 'AGARCH', 'NAGARCH'
 p:             positive scalar integer representing the order of ARCH
 q:             positive scalar integer representing the order of GARCH
 H:             a vector of time series of positive pre-sample 
                conditional standard deviations.
 K:             a vector of time series of positive pre-sample 
                conditional kurtosis. Must not be empty!
 y:             a vector of factors for the volatility process, must be positive!
 NumSamples:    The number of samples. If is left empty 100 samples will be generated.
 NumPaths:      The number of paths. If it is left empty 1 path will be estimated.


 OUTPUTS:
 Series:       (NumSamples x NumPaths) simulated series with GARCH variances
 Sigmas:       (NumSamples x NumbPaths) vector of conditional standard deviations
 Kurtosis:     (NumSamples x NumbPaths) vector of conditional kurtosis
-----------------------------------------------------------------------
 Author:
 Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
 Date:     11/2011
-----------------------------------------------------------------------
%}

if nargin == 0 
    error('Parameters, GARCH Model, ARCH, GARCH, Sigmas, Number of Samples,  Number of Paths') 
end

if nargin < 9 | isempty(NumPaths)
    NumPaths=1;
end

if isempty(K)
    error('K vector must not be empty')
end

% Verifying that the vector of parameters is a column vector
[r,c]=size(parameters);
if r<c
    parameters=parameters';
end

m  =  max([p,q]);   

RandomNumbers = trnd(K(end), NumSamples+m, NumPaths); % The conditional kurtosis estimate is used to generate the random numbers

resids=[];
h=[];
series=[];
k=[];

if isscalar(y)
     factors = 0;
else
     factors = sum(parameters(2+p+q:1+p+q+size(y,2)).*y(end,:));
end


% Set initial value to the unconditional
if isequal(strcat(model), 'GARCH')
   h(1:m,1:NumPaths) = (parameters(1)+factors)/(1-sum(parameters(2:1+p)) - sum(parameters(3:1+p+q))); 
   k(1:m,1:NumPaths) = parameters(2+p+q)./(1-sum(parameters(3+p+q:2+2*p+q)) - sum(parameters(4+2*p:3+2*p+q))); 
elseif  isequal(strcat(model), 'GJR')
   h(1:m,1:NumPaths) = (parameters(1)+factors)/(1-sum(parameters(2:1+p)) - sum(parameters(3:1+p+q)) - sum(parameters(4:1+p+q)));  
   k(1:m,1:NumPaths) = parameters(2+2*p+q)./(1-sum(parameters(3+2*p+q:2+3*p+q)) - sum(parameters(4+3*p:3+3*p+q))); 
elseif isequal(strcat(model), 'AGARCH')
   h(1:m,1:NumPaths) = (parameters(1)-sum(parameters(2:1+p).*parameters(4:1+p+q))+factors)./(1-sum(parameters(2:1+p)) - sum(parameters(3:1+p+q))); 
   k(1:m,1:NumPaths) = parameters(2+2*p+q)./(1-sum(parameters(3+2*p+q:2+3*p+q)) - sum(parameters(4+3*p:3+3*p+q))); 
elseif isequal(strcat(model), 'NAGARCH')
   h(1:m,1:NumPaths) = (parameters(1)-sum(parameters(2:1+p).*parameters(4:1+p+q)) + factors)./(1-sum(parameters(2:1+p)) - sum(parameters(3:1+p+q))); 
   k(1:m,1:NumPaths) = parameters(2+2*p+q)./(1-sum(parameters(3+2*p+q:2+3*p+q)) - sum(parameters(4+3*p:3+3*p+q))); 
else error('Invalid GARCH Model');
end

if isempty(H)
    series=randn(1:m,NumPaths).*sqrt(h);
else
    series=sqrt(H(end-m+1:end))*ones(1,NumPaths).*RandomNumbers(1:m,:);
end

if strcmp(model,'GARCH')
    for i = 1:NumPaths
        for t = (m+1):(size(RandomNumbers,1)-m)
            h(t,i) = parameters(1:1+p+q)'* [1 ; series(t-(1:p),i).^2;  h(t-(1:q),i) ];
            series(t,i)=RandomNumbers(t,i)*sqrt(h(t,i));
            k(t,i) = parameters(2+p+q:2+2*p+2*q)'* [1 ; (series(t-(1:p),i).^4)./ (h(t-(1:q),i).^2);  h(t-(1:q),i)];
        end
    end
elseif strcmp(model,'GJR')
    for i = 1:NumPaths
        for t = (m+1):(size(RandomNumbers,1)-m)
            h(t,i) =  parameters(1:1+2*p+q)'*[1; series(t-(1:p),i).^2; h(t-(1:q),i); (series(t-(1:p),i)<0).*(series(t-(1:p),i).^2)];
            series(t,i)=RandomNumbers(t,i)*sqrt(h(t,i));
            k(t,i) = parameters(2+2*p+q:2+3*p+2*q)'* [1 ; (series(t-(1:p),i).^4)./ (h(t-(1:q),i).^2);  h(t-(1:q),i)];
        end
    end
elseif strcmp(model,'AGARCH')
    for i = 1:NumPaths
        for t = (m+1):(size(RandomNumbers,1)-m)
            h(t,i) = parameters(1:1+p+q)'*[1; (series(t-(1:p),i) - parameters(2+p+q:1+2*p+q)).^2; h(t-(1:q),i)];
            series(t,i)=RandomNumbers(t,i)*sqrt(h(t,i));
            k(t,i) = parameters(2+2*p+q:2+3*p+2*q)'* [1 ; (series(t-(1:p),i).^4)./ (h(t-(1:q),i).^2);  h(t-(1:q),i)];
        end
    end
elseif strcmp(model,'NAGARCH')
    for i = 1:NumPaths
        for t = (m+1):(size(RandomNumbers,1)-m)
            h(t,i) = parameters(1:1+p+q)'*[1; (series(t-(1:p),i)./sqrt(h(t-(1:p),i)) + parameters(2+p+q:1+2*p+q)).^2; h(t-(1:q),i)];
            series(t,i)=RandomNumbers(t,i)*sqrt(h(t,i));
            k(t,i) = parameters(2+2*p+q:2+3*p+2*q)'* [1 ; (series(t-(1:p),i).^4)./ (h(t-(1:q),i).^2);  h(t-(1:q),i)];
        end
    end
else error('Invalid GARCH Model');
end


Series=series;
Sigmas=h;
Kurtosis=k;


end



