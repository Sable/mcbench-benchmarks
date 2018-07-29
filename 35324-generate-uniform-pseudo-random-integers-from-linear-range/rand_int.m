function result = rand_int(R,N)
%RAND_INT generates a matrix of integers randomly distributed over range R.
%  A = RAND_INT(R,N) returns an n-by-n matrix containing pseudorandom
%  integer values from the range specified by R.
%
%   Examples:
%       x = rand_int(5,1);           %integer in range 0 to 5
%       d6 = rand_int([1 6],1);      %integer in range 1 to 6
%       vc = rand_int([9 99],[3 1]); %col vector with values from 9 to 99
%       vr = rand_int(1,[1 3]);      %row vector with values of 0 or 1
%
%     See also rand, randn, randi.

if nargin < 2, N = [1 1]; end
if nargin < 1, R = [0 1]; end

if (numel(R)==1), R = [R 0]; end
if (numel(R)~=2),
    error('Specified range must be a matrix with size [1 2].');
end

result = floor(min(R) + (max(R)-min(R)+1) .* rand(N));

%==========================================================================
%rand_int.m
%Function that uses rand to generate random integers in some linear range.
%--------------------------------------------------------------------------
%author:  David Sedarsky
%date:    February, 2012