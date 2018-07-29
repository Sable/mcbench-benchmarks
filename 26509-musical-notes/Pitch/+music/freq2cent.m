function c = freq2cent(f1,f2)
% MUSIC.FREQ2CENT Returns the number of cents between two frequencies.
%    C = MUSIC.FREQ2CENT(F) returns the number of cents between middle C (C4)
%    and frequency F. F may be a vector.
%
%    C = MUSIC.FREQ2CENT(F1,F2) returns the number of cents between F1 and F2.
%    F1 and F2 may be vectors of the same size, or one may be scalar.
%
%    Examples
%       c = music.freq2cent(523.25);             % returns 1200
%       c = music.freq2cent(220, 246.94);        % returns 200
%       c = music.freq2cent([220 440], 246.94);  % returns [200 -1000]
%
%    See also music.freq2tone, music.freq2note, music.freq2interval.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.


if nargin < 2
    f2 = f1;
    f1 = 261.625565300599;
end

c = 1200 * log2( f2 ./ f1 );