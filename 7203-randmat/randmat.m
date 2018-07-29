function [Y,I] = randmat(X,DIM)
%RANDMAT    Shuffles array elements or cell elements randomly.
%   For vectors, RANDMAT(X) shuffles the array by calling randperm - use
%   randperm instead.
%   For matrices, RANDMAT(X) shuffles the elements randomly.
%   RANDMAT works for 1 or 2 dimensions.
%
%   Y = RANDMAT(X,DIM)
%   has an optional parameter.
%   DIM selects a dimension to shuffle randomly.
%   The result is in Y which has same shape and type as X.
%
%   [Y,I] = RANDMAT(X,DIM) also returns an index matrix I.
%   If X is a vector, then Y = X(I).
%   If X is an m-by-n matrix and DIM=1, then
%       for j = 1:n, Y(:,j) = X(I(:,j),j); end
%
%
%   Example: if X = [1 2 3
%                    4 5 6]
%
%   then RANDMAT(X,1) might be [1 5 3 and RANDMAT(X,2) might be [3 2 1
%                                4 2 6]                          4 6 5]
%
%   See also PERMS, RAND.

%  Author: Peter Bodin <pbodin@kth.se>
%
%  2005-11-20  Peter Bodin <pbodin@kth.se>
%  * Second revision
%
%   Removed the setting of the rand seed so that this function won´t 
%   disturb peoples manually set seeds. Thanks to John D'Errico who
%   explained why this should not be done.

msg = nargchk(1, 2, nargin);                            % check input
error(msg);
if ndims(X)>2
    error('RANDMAT works for 1 or 2 dimensions only.')
end
[r,c] = size(X);                                        % size
switch nargin                                           % argument switch
    case 1 || isvector(X)
        I = reshape(randperm(numel(X)),[r c]);          % use randperm if vector
        Y = X(I);                                       % or if all elements should be shuffled
    case 2
        switch DIM                                      % dimension switch
            case 1
                [I,I] = sort(rand([r c]),1);            % random row permutations
                Y = X(I+ repmat([0 (r+1:r:c*r)-1],r,1));
            case 2
                [Y,I] = randmat(X',1);                  % use transposed input for columns
                Y = Y';
            otherwise
                error('RANDMAT works for 1 or 2 dimensions only.')
        end
end

