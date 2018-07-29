function x = sampleCovPoisson(m,C,nSamples,err)

% x = sampleCovPoisson(m,C,nSamples,err)
%   Draw random samples from multivariate poisson distribution with means m
%   and covariances C. If you need many samples, call this function
%   oftentimes as there is a memory bottleneck at the end.
%
%   IMPORTANT: Covariance matrix is input, not correlation matrix. 
%            C = Cr .* sqrt(m*m')
%
%   m:          D*1 mean vector
%   C:          D*D Covariance matrix
%   nSamples:   number of samples to generate
%   err:        desired accuarcy (preset is fine)
%
% Code from the paper: 'Generating spike-trains with specified
% correlations', Macke et al., submitted to Neural Computation
%
% www.kyb.mpg.de/bethgegroup/code/efficientsampling


% We generate Poisson distributed random vectors by using its property of being
% the limiting process of a Bernoulli process. 
% Specifically, we draw i.i.d. Bernoulli random vectors with correlated 
% components using a dichotomized Gaussian distribution and sum them up to
% obtain a Poisson distributed vector with correlated components.

% number of bins to use
% B(N,p) = Bernoulli distribution with parameters N and p
% P(lambda) = Poisson distribution with parameter lamda
%    Var[B] = N*p*(1-p)
%    Var[P] = lambda = N*p 
%       ==> error(Var) ~ p
%       ==> N := lambda/p

if nargin < 4
    err = 0.02;
end
m = m(:);
lambda = max(m);

% find the number of Bernoulli trials to get a good approximation
N = ceil(lambda/err);     

% determine parameters for latent Gaussian distribution
[g,L] = findLatentGaussian(m/N,C/N);

% sample from latent gaussian
n = length(m);
s = real(sqrtm(L)) * randn(n,N*nSamples);

% apply dichotomization
t = repmat(-g,1,N*nSamples);        % this step is a memory bottleneck! 
b = (s > t);
x = sum(reshape(b,[n,nSamples,N]),3);


