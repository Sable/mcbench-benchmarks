function [B,ranges] = EstimateDiscreteJoint(A)

% [B,ranges] = EstimateDiscreteJoint(A)
%   Estimates the discreet joint distribution of samples in a matrix A with
%   dimension D x N, where N is the number of examples and D is the number
%   of dimensions.
%
% Code from the paper: 'Generating spike-trains with specified
% correlations', Macke et al., submitted to Neural Computation
%
% www.kyb.mpg.de/bethgegroup/code/efficientsampling


A = A';

[N,d]=size(A);
if nargin==1
    for k=1:d
        [ranges{k},i{k},j(:,k)]=unique(A(:,k));
        rangesize(k)=numel(ranges{k});
    end
end

J=num2cell(j);
B=zeros(rangesize);

for k=1:N
    ind=J(k,:);
    B(ind{:})=B(ind{:})+1;
end

B=B/N;
