function x = fix2dec(t)

% FIX2DEC Convert binary string fixed point to decimal integer.
% 
% Usage: X = FIX2DEC(T)
% 
% Converts the two's complement fixed point representation as a string
% given by T with a binary point to decimal values. Specifically, the input
% should be of the form '10011.10110', for example. T can be a character
% array or cell string. Input multiple numbers into T along the rows, and
% the output will be as a column vector. Similarly to BIN2DEC and TWOS2DEC,
% leading spaces in T are sign extended (so treated as either 0 or 1
% depending on the first non space character), and embedded and trailing
% spaces are removed.
% 
% Example:
%     >> fix2dec(['10011.10110'; '     11.1  '; ' 0.101110  '])
%     
%     ans =
%     
%       -12.3125
%        -0.5000
%         0.7188
% 
% Inputs:
%   -T: string two's complement fixed point numbers to convert to decimal
%   integers.
% 
% Outputs:
%   -X: decimal representation of T.
% 
% See also: DEC2FIX, TWOS2DEC, DEC2TWOS, BIN2DEC, HEX2DEC, BASE2DEC.


error(nargchk(1, 1, nargin));
if iscellstr(t)
    t = char(t);
end

% Get the number of fractional points for each input.
binpt = t == '.';

% Make sure there is only one binary point in every row.
if any(sum(binpt, 2) > 1)
    error('fix2dec:tooManyBinaryPoints', ...
        'Only one binary point allowed in each row.');
end

% Get number of 0's and 1's after each binary point.
frac = sum((t == '0' | t == '1') & logical(cumsum(binpt, 2)), 2);

% Remove binary point.
t(binpt) = ' ';

% Convert using twos2dec.
x = twos2dec(t) .* 2.^-frac;