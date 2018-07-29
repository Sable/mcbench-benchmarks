function y = pmean(x,p)
%Calculates generalized mean
% x = vector subject to generalized mean calculations. Can be also matrix.
% p = parameter for generalized mean.
% y = generalized mean value.
y = (sum(x.^p,1)/size(x,1)).^(1/p);

