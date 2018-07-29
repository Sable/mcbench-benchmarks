function f = dec2fix(x, nfracbits, nbits)

% DEC2FIX Convert decimal integer to binary string fixed point.
% 
% Usage: F = DEC2FIX(X, NFRACBITS, NBITS)
% 
% Converts the signed decimal integer given by X (either a scalar, vector,
% or matrix) to the two's complement representation as a string. If X is a
% vector or matrix, F(i, :) is the representation for X(i) (the shape of X
% is not preserved). Note that many fractional numbers that can be
% represented with a finite number of fractional digits cannot be
% represented by a finite number of fractional bits (specifically
% non-powers-of-two like 0.3), so input NFRACBITS is required to specify
% the precision for the number of fractional bits. Even powers-of-two
% fractional decimal numbers (like 0.5) require this input.
% 
% Example:
%     >> dec2fix([2.3 2.4 -2.3 -2.4], 3)
%     
%     ans =
%     
%     010.010
%     010.011
%     101.110
%     101.101
% 
% Inputs:
%   -X: decimal integers to convert to two's complement.
%   -NFRACBITS: number of bits to represent fractional part.
%   -NBITS: total number of bits in the representation including the
%   fractional bits (optional, default is the fewest number of bits
%   necessary to represent the integer portion).
% 
% Outputs:
%   -F: fixed point representation of X as a string.
% 
% See also: FIX2DEC, TWOS2DEC, DEC2TWOS, DEC2BIN, DEC2HEX, DEC2BASE.

error(nargchk(2, 3, nargin));
x = x(:);
maxx = max(abs(x));
nbits_min = max([nextpow2(maxx + (any(x == maxx))) + 1 + nfracbits, ...
    nfracbits]);

% Default number of bits.
if nargin < 3
    nbits = nbits_min;
elseif nbits < nbits_min
      warning('dec2twos:nbitsTooSmall', ['Minimum number of bits to ' ...
        'represent maximum input x is %i, which is greater than ' ...
        'input nbits = %i. Setting nbits = %i.'], ...
        nbits_min, nbits, nbits_min)
    nbits = nbits_min;
end

% Convert to two's complement string.
f = dec2twos(round(x * 2.^nfracbits), nbits);

% Insert binary point.
f(:, end+1) = '.';
f = f(:, [1:(nbits-nfracbits), nbits+1, (nbits-nfracbits+1):nbits]);