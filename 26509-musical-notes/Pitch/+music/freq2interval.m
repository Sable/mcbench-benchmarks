function [I,O] = freq2interval(f,key)
% MUSIC.FREQ2INTERVAL Returns the interval and octave of a frequency.
%    I = MUSIC.FREQ2INTERVAL(F) returns the interval at which the frequencies in
%    F are found in the key of 'C'.
%
%    I = MUSIC.FREQ2INTERVAL(F,KEY) uses the key of KEY. KEY may be an interval
%    offset from 'C', or a character note (e.g., 'A', 'F#').
%
%    [I,O] = FREQ2INTERVAL(...) also returns the octave number of the notes.
%
%    Examples
%       I     = music.freq2interval([392 784])      % returns [7 7]
%       [I,O] = music.freq2interval([392 784])      % returns [7 7], [4 5]
%       [I,O] = music.freq2interval([392 784],'G')  % returns [0 0], [4 5]
%
%    See also music.freq2tone, music.freq2note, music.interval2freq.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.

if nargin < 2
    key = 0;
end
if ischar(key)
    key = music.note2interval(key);
end

% Convert to semitones and use semitone->interval conversion.
T     = music.freq2tone(f);
[I,O] = music.tone2interval(T,key);