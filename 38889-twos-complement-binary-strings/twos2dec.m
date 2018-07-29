function x = twos2dec(t)

% TWOS2DEC Convert binary string two's complement to decimal integer.
% 
% Usage: X = TWOS2DEC(T)
% 
% Converts the two's complement representation as a string given by T to
% decimal integers X. T can be a character array or cell string. Input
% multiple numbers into T along the rows, and the output will be as a
% column vector. Similarly to BIN2DEC, leading spaces in T are sign
% extended (so treated as either 0 or 1 depending on the first non space
% character), and embedded and trailing spaces are removed.
% 
% Example:
%     >> twos2dec(['010 111'; ' 010111'; '101011 '; ' 10   1'])
%     
%     ans =
%     
%         23
%         23
%        -21
%         -3
% 
% Inputs:
%   -T: string two's complement numbers to convert to decimal integers.
% 
% Outputs:
%   -X: decimal representation of T.
% 
% See also: DEC2TWOS, FIX2DEC, DEC2FIX, BIN2DEC, HEX2DEC, BASE2DEC.

error(nargchk(1, 1, nargin));
if iscellstr(t)
    t = char(t);
end

% Convert to numbers.
x = bin2dec(t);

% Get the number of bits as the number of 0's and 1's in each row.
nbits = sum(t == '0' | t == '1', 2);

% Case for negative numbers.
xneg = log2(x) >= nbits - 1;
% xneg = bitshift(x, -(nbits - 1)) == 1;
if any(xneg)
    x(xneg) = -( bitcmp(x(xneg), nbits(xneg)) + 1 );
end