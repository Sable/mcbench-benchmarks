function hc = binHistIndep(mu)
% hc = binHistIndep(mu)
% 	Computes expected histogram under independence assumption
%   P(X)=PROD(P(x_i))
%
% Code from the paper: 'Generating spike-trains with specified
% correlations', Macke et al., submitted to Neural Computation
%
% www.kyb.mpg.de/bethgegroup/code/efficientsampling



% generate all possible binary patterns
n = size(mu,1);
c = 0:2^n-1;
pattern = zeros(n,size(c,2));

for i=n:-1:1
    idx = c>=2^(i-1);
    pattern(i,idx)=1;
    c(idx) = c(idx) - 2^(i-1);    
end

pattern = flipud(pattern);

% transform to probabilities
mu = mu/2+.5;

% find relevant probabilities for independent model
pMat = (repmat(mu,1,size(pattern,2)).*pattern) + (repmat(1-mu,1,size(pattern,2)).* (~pattern));

% calculate histogram
hc = prod(pMat);