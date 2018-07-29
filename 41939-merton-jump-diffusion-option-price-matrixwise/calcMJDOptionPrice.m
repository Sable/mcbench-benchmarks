function P = calcMJDOptionPrice(cp,S,K,T,sigma,r,q,lambda,a,b,n)
%
% Inputs:
%   cp          [1,-1] Call,Put
%   S           Current Price
%   K           Strike Vector
%   T           Time-to-Maturity Vector
%   sigma       Volatility of Diffusion
%   r           Risk-free-Rate
%   q           Div Yield
%   lambda      Poisson Rate
%   a           Jump Mean
%   b           Jump Std Deviation
%   n           Event Count (Limited to 170 since factorial(170)=7.26e306)
%
% Example:
%   S = 100; K = (20:5:180)'; T = (0.1:0.1:5)';
%   sigma = 0.2; cp = 1; r = 0.0075; q = 0; lambda = 0.01; a = -0.2; b = 0.6; n = 50;
%   P = calcMJDOptionPrice(cp,S,K,T,sigma,r,q,lambda,a,b,n);
%
%   [mK,mT] = meshgrid(K,T); [sigma,C] = calcBSImpVol(cp,P,S,mK,mT,r,q);
%   subplot(2,1,1); mesh(mK,mT,P); subplot(2,1,2); mesh(mK,mT,sigma);
%
% References:
%   Merton, 1976, Option Pricing When Underlying Stock Returns are Discontinuous
%   http://www.people.hbs.edu/rmerton/optionpricingwhenunderlingstock.pdf
%
% Author: Mark Whirdy

%% CALCULATE MERTON JUMP DIFFUSION PRICES BY MERTON'S CLOSED FORM SOLUTION

[K,T] = meshgrid(K,T);
[u,v] = size(K);
K = K(:,:,ones(1,1,n)); T = T(:,:,ones(1,1,n));
n = ones(1,1,n); n(:)=0:size(n,3)-1; factn = factorial(n);
n = n(ones(u,1),ones(1,v),:); factn = factn(ones(u,1),ones(1,v),:);

m = a+0.5*b.^2;
lambda_prime = lambda.*exp(m);
r_n = r - lambda*(exp(m)-1) + n.*(m)./T;
sigma_n = sqrt(sigma.^2 + (n*b^2)./T);

dfcn = @(z,sigma,r)((1./(sigma.*(T.^(0.5)))).*(log(S./K) + (r - q + z.*0.5*(sigma.^2)).*T));
callfcn = @(sigma,r)(((1./factn).*exp(-lambda_prime.*T).*(lambda_prime.*T).^n).*(exp(-q.*T).*S.*Nfcn(dfcn(1,sigma,r)) - K.*exp(-r.*T).*Nfcn(dfcn(-1,sigma,r)))); % Call

P = sum(callfcn(sigma_n,r_n),3); % Eqn 19 of Merton, 1976

if cp==-1
    P = P - S.*exp(-q.*T(:,:,1)) + K(:,:,1).*exp(-r.*T(:,:,1)); % Convert Call to Put by Parity Relation
end

end

%
%
%
%% NORM INVERSE

function p = Nfcn(x)

p=0.5*(1.+erf(x./sqrt(2)));

end

