function T = note2tone(N)
% MUSIC.NOTE2TONE Converts a scientific pitch note to a tone relative to C4.
%   T = MUSIC.NOTE2TONE(N) returns T, the number of semitones above or below C4
%   at which note N occurs. N is a note string in scientific pitch notation, or
%   a cell array of strings.
%
%   Example
%      T = music.note2tone('F#6')  % returns 30
%
%   See also music.note2freq, music.note2interval, music.tone2note.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.


% Map note to interval/octave then tone.
[I,O] = music.note2interval(N);
T     = music.interval2tone(I,O);