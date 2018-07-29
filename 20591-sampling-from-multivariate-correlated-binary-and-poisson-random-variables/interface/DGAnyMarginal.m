function [samples,gammas,Lambda,joints2D,hists] = DGAnyMarginal(pmfs,Sigma,supports,Nsamples)

% [samples,gammas,Lambda,joints2D,hists] = DGAnyMarginal(pmfs,Sigma,supports,Nsamples)
%   Generates samples from a Multivariate Discretized Gaussian with specified marginals
%   and covariance. Also returns parameters of the fitted DG.
%
%   Inputs:
%     pmfs: the probability mass functions of the marginal distribution of the
%       input-random variables. Must be a cell-array with n elements, each of
%       which is a vector which sums to one
%     Sigma: The covariance matrix of the input-random variable. The function
%       does not check for admissability, i.e. results might be wrong if there
%       exists no random variable which has the specified marginals and
%       covariance.
%     supports: The support of each dimension of the input random variable.
%       Must be a cell-array with n elements, each of whcih is a vector with
%       increasing entries giving the possible values of each random variable,
%       e.g. if the first dimension of the rv is 1 with probability .2, 3 with
%       prob .8, then pmfs{1}=[.2,.8], supports{1}=[1,3]; If empty support is
%       specified, then each is taken to be [0:numel(pdfs{k}-1];
%     Nsamples: The number of samples to be generated.
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
%   Usage:
%
% Code from the paper: 'Generating spike-trains with specified
% correlations', Macke et al., submitted to Neural Computation
%
% www.kyb.mpg.de/bethgegroup/code/efficientsampling

[gammas,Lambda,joints2D]=FindDGAnyMarginal(pmfs,Sigma,supports);

[samples,hists]=SampleDGAnyMarginal(gammas,Lambda,supports,Nsamples);

samples = samples';
