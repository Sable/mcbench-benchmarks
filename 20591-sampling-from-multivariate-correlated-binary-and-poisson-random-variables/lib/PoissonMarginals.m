function [pmfs,supports] = PoissonMarginals(means,acc)
%
% [pmfs,supports] = PoissonMarginals(means,acc)
%   Finds the probability mass functions (pmfs) and approximate supports of a set of
%   Poisson random variables with means specified in input "means". The
%   second argument, "acc", specifies the desired degree of accuracy. The
%   "support" is taken to consist of all values for which the pmfs is greater
%   than acc.
%
%   Inputs:
%     means: the means of the Poisson RVs
%     acc: desired accuracy
%
%   Outputs:
%     pmfs: a cell-array of vectors, where the k-th element is the probability
%       mass function of the k-th Poisson random variable. 
%     supports: a cell-array of vectors, where the k-th element is a vector of
%       integers of the states that the k-th Poisson random variable would take
%       with probability larger than "acc". E.g., P(kth
%       RV==supports{k}(1))=pmfs{k}(1);
%
% Code from the paper: 'Generating spike-trains with specified
% correlations', Macke et al., submitted to Neural Computation
%
% www.kyb.mpg.de/bethgegroup/code/efficientsampling

if nargin==2 || isempty(acc)
    acc=1e-8;
end
numdims=numel(means);

% first, determine range of variables to sum over
for k=1:numdims
    cmfs{k}=poisscdf(0:max(ceil(5*means(k)),20),means(k));
    pmfs{k}=poisspdf(0:max(ceil(5*means(k)),20),means(k)); 
    supports{k}=find((cmfs{k}<=1-acc) & pmfs{k}>=acc)-1;
    cmfs{k}=cmfs{k}(supports{k}+1);
    pmfs{k}=poisspdf(supports{k},means(k)); 
end
