function f = interval2freq(I,O,key)
% MUSIC.INTERVAL2FREQ returns the frequency of a musical interval.
%    T = MUSIC.INTERVAL2FREQ(I,OCT) returns the frequency F of each note
%    specified by interval/octave pair I and OCT, respectively. I and OCT are
%    interpreted in the key of 'C'. If OCT is scalar, the same octave is used
%    for each interval.
%
%    T = MUSIC.INTERVAL2FREQ(I,OCT,KEY) interprets I and OCT in the specified
%    KEY. KEY may be a character note (e.g., 'A', 'F#'), or an interval offset
%    from 'C'.
%
%    Examples
%       t = music.interval2freq([0 1],[4 5]);      % returns [261.6  554.4]
%       t = music.interval2freq([0 1],[4 5],'G');  % returns [392.0  830.6]
%
%    See also music.interval2tone, music.interval2note, music.freq2interval.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.


if nargin < 3
    key = 0;
end
if ischar(key)
    key = music.note2interval(key);
end

% Find semitone then convert to frequency
t = music.interval2tone(I,O,key);
f = music.tone2freq(t);