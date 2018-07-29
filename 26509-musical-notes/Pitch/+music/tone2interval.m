function [I,O] = tone2interval(T,key)
% MUSIC.TONE2INTERVAL Returns the interval and octave of notes in a key.
%    I = MUSIC.TONE2INTERVAL(T) returns the interval at which the tones in T are
%    found in the key of 'C'. T is a vector of semitones defined relative to C4,
%    where C4 corresponds to tone 0.
%
%    I = MUSIC.TONE2INTERVAL(T,KEY) uses the key of KEY. KEY may be an interval
%    offset from 'C', or a character note (e.g., 'A', 'F#').
%
%    [I,O] = MUSIC.TONE2INTERVAL(...) also returns the octave number of each
%    tone.
%
%    Examples
%       I     = music.tone2interval([7 19])      % returns [7 7]
%       [I,O] = music.tone2interval([7 19])      % returns [7 7], [4 5]
%       [I,O] = music.tone2interval([7 19],'G')  % returns [0 0], [4 5]
%
%    See also music.tone2freq, music.tone2note,  music.interval2tone.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.

if nargin < 2
    key = 0;
end
if ischar(key)
    key = music.note2interval(key);
end

I = mod(T,12) - key;
I = mod(I,12);

O = 4 + floor(T / 12);
