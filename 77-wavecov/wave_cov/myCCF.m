function A = myCCF(U, V)
%%
%% Provides all N-1 autocovariance estimates from a vector of observations
%%
N = length(U);
A = sum(xcov(U(~isnan(U)), V(~isnan(V)), 'biased').^2);
