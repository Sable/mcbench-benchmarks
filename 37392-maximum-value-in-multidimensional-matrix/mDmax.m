function [max_val,ind] = mDmax(x)
%MDMAX Largest component in a multidimensional matrix.
%   For a matrix X, MDMAX(X) is the largest element in X. 
%
%   [Y,I] = MDMAX(X) returns the indices of the maximum value in vector I.
%
%   When X is complex, the maximum is computed using the magnitude
%   MAX(ABS(X)). In the case of equal magnitude elements, then the phase
%   angle MAX(ANGLE(X)) is used.
%
%   NaN's are ignored when computing the maximum. When all elements in X
%   are NaN's, then the first one is returned as the maximum.
%
%   Example: If X = [2 8 4;   then mDmax(X) is 9,
%                    7 3 9]
%   and
%            [val,ind] = mDmax(X) returns val=9 and ind=[2 3]
%
%   Note: The vector ind can be used to access elements from X using this
%   neat trick:
%              sub = num2cell(ind)
%              val = x(sub{:}); 

[max_val,position] = max(x(:));
ind = myind2sub(size(x),position);

%--------------------------------------------------------------
function ind = myind2sub(siz,ndx)

dim = numel(siz);
sub = cell(dim,1);
[sub{:}] = ind2sub(siz,ndx);
ind = cell2mat(sub);

% Old implementation
% siz = double(siz);
% 
% n = length(siz);
% k = [1 cumprod(siz(1:end-1))];
% for i = n:-1:1,
%     vi = rem(ndx-1, k(i)) + 1;
%     vj = (ndx - vi)/k(i) + 1;
%     ind(:,i) = vj;
%     ndx = vi;
% end

 
