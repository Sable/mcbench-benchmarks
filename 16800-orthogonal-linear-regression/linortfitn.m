function [hyperplane_normal, hyperplane_offset] = linortfitn(data)
% LINORTFITN  Fit a line to data by ORTHOGONAL least-squares.
%    [N,C] = LINORTFITN(DATA) finds the coefficients of a hyperplane (in
%    Hessian normal form) that best fits the data in an ORTHOGONAL
%    least-squares sense.  Consider the hyperplane
%       H = {x | dot(N,x) + C == 0},
%    and the minimum (Euclidean) distance between this hyperplane and each
%    datapoint DATA(i,:) -- LINORTFITN finds N and C such that the sum of
%    squared distances is minimized.

[M,N] = size(data);
if M <= N,
    error('linortfitn:DegenerateProblem',...
        'There are fewer datapoints than dimensions: the data is perfectly fit by a hyperplane.');
end

[U,S,V] = svd(data - repmat(mean(data),M,1), 0);
hyperplane_normal = V(:,end);
hyperplane_offset = - mean(data * hyperplane_normal);
