function c = note2cent(N1,N2)
% MUSIC.NOTE2CENT Returns the number of cents between notes.
%    C = MUSIC.NOTE2CENT(N) returns the number of cents between N and middle C
%    (C4). N is a string or cell array of strings specifying notes in scientific
%    pitch format.
%
%    C = MUSIC.NOTE2CENT(N1,N2) returns the number of cents between N1 and N2.
%    N1 and N2 are note strings in scientific pitch format. N1 and N2 may be
%    cell arrays of the same size, or one may be scalar.
%
%    Examples
%       c = music.note2cent('C5');               % returns 1200
%       c = music.note2cent('A3','B3');          % returns 200
%       c = music.note2cent({'A3','A4'}, 'B3');  % returns [200 -1000]
%
%    See also music.note2freq, music.note2tone.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.


if nargin < 2
    N2 = N1;
    N1 = 'C4';
end

f1 = music.note2freq(N1);
f2 = music.note2freq(N2);

% Could call MUSIC.FREQ2TONE but it is easy to inline this simple calclation.
c  = 1200 * log2( f2 ./ f1 );