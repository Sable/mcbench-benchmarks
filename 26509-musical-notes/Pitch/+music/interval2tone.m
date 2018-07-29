function T = interval2tone(I,O,key)
% MUSIC.INTERVAL2TONE returns the absolute musical semitone of an interval.
%    T = MUSIC.INTERVAL2TONE(I,OCT) returns the absolute musical semitone T of
%    each note specified by interval/octave pair I and OCT, respectively. I and
%    OCT are interpreted in the key of 'C'. If OCT is scalar, the same octave is
%    used for each interval. T is the number of semitones above or below C4.
%
%    T = MUSIC.INTERVAL2TONE(I,OCT,KEY) interprets I and OCT in the specified
%    KEY. KEY may be a character note (e.g., 'A', 'F#'), or an interval offset
%    from 'C'.
%
%    Examples
%       t = music.interval2tone([0 1],[4 5]);      % returns [0 13]
%       t = music.interval2tone([0 1],[4 5],'G');  % returns [7 20]
%
%    See also music.interval2note, music.interval2freq, music.tone2interval.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.


if nargin < 3
    key = 0;
end
if ischar(key)
    key = music.note2interval(key);
end

% Resolve octave to semitone
octOffset = 12 * (O - 4);
T = octOffset + I + key;