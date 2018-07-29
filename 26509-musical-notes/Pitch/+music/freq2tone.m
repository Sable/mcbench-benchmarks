function T = freq2tone(f)
% MUSIC.FREQ2TONE converts a frequency to a musical semitone.
%    T = MUSIC.FREQ2TONE(F) converts frequency F to the nearest 
%    semitone.
%
%    Example
%       T = music.freq2tone(220)  % returns -3
%
%    See also music.freq2note, music.freq2interval, music.tone2freq.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.


fC4 = 261.625565300599;  % middle C (C4) is 261.63 Hz

T = 12 * log2(f./fC4);
T = round(T);


