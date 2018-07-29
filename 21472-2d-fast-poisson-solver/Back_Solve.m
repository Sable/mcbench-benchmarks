%
% Work in progress.  Needs to be written to pay heed to sparsity.
%
function [x] = Back_Solve(A,b)
x = A\b;