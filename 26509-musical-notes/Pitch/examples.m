%% Music function examples
% The MUSIC package directory contains a collection of utility functions for
% converting between different musical measures. You can convert between
% frequencies, tones, and character notes. There are also functions for
% calculating the number of cents between two notes.

%    Copyright 2010 The MathWorks, Inc.


%% Scientific Pitch Notation
% Scientific pitch notation is a character-based method of specifying a note.
% There are two parts: the note and the octave. For example, middle C on the
% piano 'C4' and the low E string on a guitar is 'E2'.

notes = {'C3', 'A3', 'A4', 'Bb6'}


%% Semitones
% A semitone is equal to one half-step. For example, A# is one semitone above A.
% Semitones can also specify an absolute note. In this package, the term
% 'semitone' means the number of half-steps above or below C4. C4 is 'middle C'
% on a piano and is a common musical reference datum.

tones = music.note2tone(notes)


%% Frequency
% The frequency of a note doubles every octave. For example A3 is 220 Hz and
% A4 is 440 Hz.

freqs = music.note2freq(notes)


%% Musical Interval
% The formats above are ways of specifying absolute pitches. In music theory
% however the most important characteristic of a note is its position in a key.
% C3 and C4 are different frequencies but they can be substituted for each
% other in a musical phrase. The passage will still sound correct and pleasing
% to the ear (assuming it was pleasing to begin with!).
%
% In this representation we derive the interval of a note within a given key, as
% well as the absolute octave it occurs in.

[intervalsC,octavesC] = music.note2interval(notes,'C')  % key of 'C'
[intervalsG,octavesG] = music.note2interval(notes,'G')  % key of 'G'


%% Centitones
% A cent is a logarithmic measure of note spacing. A semitone is equal to 100
% cents and there are 1200 cents in an octave. They are frequently used when
% tuning instruments as a measure of how close a pitch is to the correct
% frequency. For example, a guitar string can be considered tuned if it is
% within +/- 10 cents of the correct pitch. 

cents = music.note2cent('C4',notes)