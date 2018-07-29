function f = tone2freq(T)
% MUSIC.TONE2FREQ converts a musical semitone to a frequency.
%    F = MUSIC.TONE2FREQ(T) converts the musical semitones in T to frequencies.
%
%    Example
%       f = music.tone2freq(0:2);  % returns [261.63  277.19  293.67]
%
%    See also music.tone2interval, music.tone2note, music.freq2tone.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.


fC4 = 261.625565300599;  % Middle C (C4) is 261.63 Hz

f = fC4 .* 2 .^ (T / 12);