function f = note2freq(N)
% MUSIC.NOTE2FREQ Converts a scientific pitch note to a frequency.
%   F = MUSIC.NOTE2FREQ(N) returns the frequency of note N. N is a note string
%   in scientific pitch notation, or a cell array of strings.
%
%   Example
%      f = music.note2freq('F#6')  % returns 1480.0
%
%   See also music.note2tone, music.note2cent, music.freq2note.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.


T = music.note2tone(N);
f = music.tone2freq(T);