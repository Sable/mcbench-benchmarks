function [samples,gammas,Lambda,joints2D,pmfs,hists,supports]=DGPoisson(means,Sigma,Nsamples,acc)

% [samples,gammas,Lambda,joints2D,cmfs,hists] = DGPoisson(means,Sigma,Nsamples,acc)
%   Generates samples from a Multivariate Discretized Gaussian with Poisson marginals
%   and specified covariance. Also returns parameters of the fitted DG.
%
%   Inputs:
%     means: the means of the input Poissons. Must be a vector with n elements.
%     Sigma: The covariance matrix of the input-random variable. The function
%       does not check for admissability, i.e. results might be wrong if there
%       exists no random variable which has the specified marginals and
%       covariance.
%     Nsamples: The number of samples to be generated.
%     acc: the desired accuracy. If empty or missing, default ist used
%
%   Outputs:
%     samples: a matrix of size Nsamples by n, where each row is a sample from
%       the DG.
%     gammas: the discretization thresholds, as described in the paper. When
%       sampling. The k-th dimension of the output random variable is f if e.g.
%       supports{k}(1)=f and gammas{k}(f) <= U(k) <= gammas{k}(f+1)
%     Lambda: the covariance matrix of the latent Gaussian random variable U
%     joints2D: An n by n cell array, where each entry contains the 2
%       dimensional joint distribution of  a pair of dimensions of the DG.
%     hists: the empirical marginals of the samples returned in "samples"
%
% Code from the paper: 'Generating spike-trains with specified
% correlations', Macke et al., submitted to Neural Computation
%
% www.kyb.mpg.de/bethgegroup/code/efficientsampling


if nargin<=3
    acc=[];
end

% calculate marginal distribution of Poisson
[pmfs,supports] = PoissonMarginals(means,acc);

% find paramters of DG
[gammas,Lambda,joints2D]=FindDGAnyMarginal(pmfs,Sigma,supports);

% generate samples
[samples,hists]=SampleDGAnyMarginal(gammas,Lambda,supports,Nsamples);

samples = samples';
