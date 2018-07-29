%{

Demo for ipdm.m (Inter-Point Distance Matrix)

John D'Errico
e-mail: woodchips@rochester.rr.com

%}

%% A complete (internal) inter-point distance matrix.

% Each point is taken as one row of the input, so each column is a
% dimension. There will be a 5x5 array of interpoint distances between
% the points in a 5x2 set of data. Note that the diagonal elements in
% this matrix will be zero, since they describe the distance from a
% point to itself.
A = randn(5,2);
d = ipdm(A)

%% Distances may be in any number of dimensions, even 1-d.
A = rand(6,1);
d = ipdm(A)

%% Or in very many dimensions.
A = rand(5,1000);
d = ipdm(A)

%% The default metric used to compute the distance is the 2-norm, or Euclidean norm.
A = rand(3,2);
d = ipdm(A)

%% The 1-norm is also available as an option.

% The 1-norm is sometimes known as the city block norm. Of course,
% the 1-norm is just the sum of absolute values, so it is the total
% distance one would travel if constrained to move only along
% "streets" parallel to the x and y axes.

% Options are passed into ipdm using property/value pairs
d = ipdm(A,'metric',1)

%% The infinity norm is an option too.

% It is the maximum difference in any dimension. We can think
% of the infinity norm as the limit of a p-norm as p --> inf
d = ipdm(A,'metric',inf)

%% The 0-norm is not really a valid norm, but I've included it anyway.

% Its the smallest difference in any dimension. Why is it not a valid
% norm? You can have two widely distinct points with a "0-norm" of 0,
% as long as they exactly match in any one dimension. You can also
% look at the 0-norm as the limit of a p-norm, as p --> 0 from above.

% Properties can be shortened, and capitalization is ignored.
d = ipdm(A,'Met',0)

%% Inter-point distances may between two sets of points.

% Of course, the diagonal elements will no longer be expected to be zero.
A = randn(10,2);
B = randn(3,2);
d = ipdm(A,B)

%% You may only want some subset of the distances. The nearest neighbor is a common choice.

% Note that the result is a sparse matrix, to allow you to compute
% interpoint distance matrices between very large sets of points.
% When an array is returned, if that array is likely to be a sparse
% one, I've chosen to generate the array in a sparse format.
A = rand(7,3);
B = rand(5,3);
d = ipdm(A,B,'Subset','nearest')

%% You can return the result as a structure, or a 2-d array
d = ipdm(A,B,'Subset','nearest','result','struct')

% A structure as the output can sometimes be useful, if that is how you
% will be using the results anyway.
[d.rowindex,d.columnindex,d.distance]

%% You can find the single largest distance.
A = randn(2000,2);
B = randn(1000,2);

% Logically, the result should be a sparse matrix.
d = ipdm(A,B,'Subset','largestfew','limit',1)

%% or the k largest distances (here, k = 3)

% find the k = 3 largest distances
d = ipdm(A,B,'Subset','largestfew','limit',3)

%% Or the k smallest distances (here, k == 5)
d = ipdm(A,B,'Subset','smallestfew','limit',5)

%% You can find only those distances above a specific limit.
A = sort(rand(7,1));
% If an array is returned, then I fill those below the limit with -inf
d = ipdm(A,'Subset','Minimum','limit',0.5)

% If a structure is returned, then only the pairs beyond the specified
% limit are included.
d = ipdm(A,'Subset','Minimum','limit',0.5,'result','struct')

%% You can also limit the maximum distance found.
A = randn(10,2);
B = randn(4,2);
% Here the other elements are filled with +inf
d = ipdm(A,B,'Subset','Max','limit',1.5,'metric',inf)

%% Compute only the 1000 smallest distances between a large pair of arrays
% When the arrays are too large, computing the entire array may not fit
% entirely into memory. ipdm is smart enough to break the problem up to
% accomplish the task anyway. In this example, the complete interpoint
% distance matrix would have required roughly 800 megabytes of RAM to
% store. This would have exceeded the RAM that I have available on this
% computer, yet I only wanted the 1000 smallest elements in the end.
A = rand(10000,2);
B = rand(10000,2);
d = ipdm(A,B,'sub','smallestfew','lim',1000,'res','a');
spy(d)

%% Nearest neighbour is quite efficient in one dimension
% You don't want to compute the entire interpoint distance matrix,
% if you only need the nearest neighbors.
A = rand(100000,1);
tic,d = ipdm(A,'subset','nearest','result','struct');toc
d

%% ipdm uses bsxfun where that is possible.

% Older releases of Matlab did not have bsxfun, so I check first to see
% if this function exists. If it does exist in your release, ipdm can
% run faster and be more efficient in its use of memory.

% The ipdm code also attempts to use memory in an efficient way, so that
% very large distance matrices are processed in chunks. I try to minimize
% the creation of huge intermediate arrays when only a smaller subset of
% the full distance matrix is desired. The user can control the size of
% the chunks with the ChunkSize property.
A = rand(5000,1);

% The default ChunkSize is 2^25
tic,d = ipdm(A,'Subset','min','limit',0.99,'result','struct');toc

% Here, only 1 megabyte chunks will be processed at any time.
tic,d = ipdm(A,'Subset','min','limit',0.99,'result','struct','chunksize',2^20);toc

