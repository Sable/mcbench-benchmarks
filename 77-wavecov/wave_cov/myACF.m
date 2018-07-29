function A = myACF(V)
%%
%% Provides all N-1 autocovariance estimates from a vector of observations
%%
N = length(V);
A = xcov(V(~isnan(V)), 'biased')';
NV = sum(~isnan(V));
A = [repmat(NaN, 1, N-NV+1) A(NV:(2*(NV-1)))];
