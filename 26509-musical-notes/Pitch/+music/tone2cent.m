function c = tone2cent(t1,t2)
% MUSIC.TONE2CENT Returns the number of cents between two semitones.
%    C = MUSIC.TONE2CENT(T) returns the number of cents between T and middle C
%    (C4). T is a semitone interval defined relative to C4.
%
%    C = MUSIC.TONE2CENT(T1,T2) returns the number of cents between T1 and T2.
%    T1 and T2 are musical semitones defined relative to C4. T1 and T2 may be
%    vectors of the same size, or one may be scalar.
%
%    Examples
%       c = music.tone2cent(12);         % returns 1200
%       c = music.tone2cent(-3,-1);      % returns 200
%       c = music.tone2cent([-3 9],-1);  % returns [200 -1000]
%
%    See also music.tone2freq, music.tone2interval, music.tone2note.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.


if nargin < 2
    t2 = t1;
    t1 = 0;
end

f1 = music.tone2freq(t1);
f2 = music.tone2freq(t2);

% Could call MUSIC.FREQ2TONE but it is easy to inline this simple calclation.
c  = 1200 * log2( f2 ./ f1 );