function N = interval2note(I,O,key,accsym)
% MUSIC.INTERVAL2NOTE returns a note string in scientific pitch notation.
%    T = MUSIC.INTERVAL2NOTE(I,OCT) returns, in scientific pitch format, each
%    note specified by interval/octave pair I and OCT, respectively. I and OCT
%    are interpreted in the key of 'C'. If OCT is scalar, the same octave is
%    used for each interval. N is not a natural note the character string
%    defaults to a sharp (#) note.
%
%    T = MUSIC.INTERVAL2NOTE(I,OCT,KEY) interprets I and OCT in the specified
%    KEY. KEY may be a character note (e.g., 'A', 'F#'), or an interval offset
%    from 'C'.
%
%    T = MUSIC.INTERVAL2NOTE(I,OCT,KEY,SYM) specifies which symbol to use for
%    accidental notes. SYM may be '#' (sharp) or 'b' (flat).
%
%    Examples
%       N = music.interval2note([0 1],[4 5]);          % returns {'C4','C#5'}
%       N = music.interval2note([0 1],[4 5],'G');      % returns {'G4','G#5'}
%       N = music.interval2note([0 1],[4 5],'G','b');  % returns {'G4','Ab5'}
%
%    See also music.interval2tone, music.interval2freq, music.note2interval.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.


if nargin < 3
    key = 0;  % default key is 'C'
end
if nargin < 4
    accsym = '';
end
if ischar(key)
    key = music.note2interval(key);
end

T = music.interval2tone(I,O,key);
N = music.tone2note(T,accsym);