function c = dstmtx(n)
%DSTMTX Discrete sine transform matrix.
%   D = DSTMTX(N) returns the N-by-N DST transform matrix.  D*A is the DST
%   of the columns of A and D'*A is the inverse DST of the columns of A
%   (when A is N-by-N).
%
%   If A is square, the two-dimensional DST of A can be computed as D*A*D'.
%   This computation is sometimes faster than using DSTN, especially if you
%   are computing large number of small DST's, because D needs to be
%   determined only once.
%
%   Class Support
%   -------------
%   N is an integer scalar of class double. D is returned as a matrix of
%   class double.
%   
%   Example
%   -------
%       A = im2double(imread('rice.png'));
%       D = dstmtx(size(A,1));
%       dst = D*A*D';
%       figure, imshow(dst)
%
%   See also DSTN, IDSTN, DCTMTX
%
%   -- Damien Garcia -- 2009/11
%   -- Adapted from DCTMTX --
%   website: <a
%   href="matlab:web('http://www.biomecardio.com')">www.BiomeCardio.com</a>

%   I/O Spec
%      N - input must be double
%      D - output DCT transform matrix is double

iptchecknargin(1,1,nargin,mfilename);
iptcheckinput(n,{'double'},{'integer' 'scalar'},mfilename,'n',1);

[cc,rr] = meshgrid(0:n-1);

c = sqrt(2 / n) * sin(pi * (2*cc + 1) .* (rr + 1) / (2 * n));
c(n,:) = c(n,:) / sqrt(2);
