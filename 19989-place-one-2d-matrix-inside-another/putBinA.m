function out = putBinA(A,B,r,c)
% Function that places a 2D matrix B into a larger 2D matrix A. The
% upper-left corner of B is placed at coordinates (r,c) in A. If (r,c) are
% not given, then B is put in the upper-left corner of A, a default of
% (1,1). Some error checking is done first to make sure that A and B are 2D
% matrices, A is big enough to contain B, and the given (r,c) will not
% spill B outside of A.

%% Setup variables
[ar ac] = size(A);
[br bc] = size(B);
if nargin < 4
    r = 1; c = 1;
else
    r = round(r); c = round(c);
end

%% Error checking
% check that A and B are 2D matricies
if (numel(size(A))~=2) || (numel(size(B))~=2)
    error('The input matrices must be 2D arrays');
end
% check that A is >= B on both dims
if ar<br || ac<bc
    error('Matrix "A" must be big enough to contain matrix "B"');
end
% check that the (r,c) placement lands B entirely inside of A
if (ar < (r+br-1)) || (ac < (c+bc-1))
    error('Matrix "B" will fall outside matrix "A" with these coordinates');
end

%% Place B in A at (r,c) position
out = A;
rr = r + br - 1;
cc = c + bc - 1;
out(r:rr,c:cc) = B;
