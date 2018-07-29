function N = freq2note(f)
% MUSIC.FREQ2NOTE converts a frequency to a note string.
%    N = MUSIC.FREQ2NOTE(F) converts frequency F to the nearest musical note. If
%    F is not a natural note the character string defaults to a sharp (#) note.
%    F may be a vector of frequencies.
%
%    N = MUSIC.FREQ2NOTE(F,SYM) specifies which symbol to use for accidental
%    notes. SYM may be '#' (sharp) or 'b' (flat).
%
%    Examples
%       N = music.freq2note(466.16);      % returns 'A#4'
%       N = music.freq2note(466.16,'b');  % returns 'Bb4'
%
%    See also music.freq2tone, music.freq2interval, music.note2freq.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.


% Convert frequency to tone then use MUSIC.TONE2NOTE.
T = music.freq2tone(f);
N = music.tone2note(T);