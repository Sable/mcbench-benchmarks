function note = tone2note(T,accsym)
% MUSIC.TONE2NOTE Converts a musical semitone to a character note.
%    N = MUSIC.TONE2NOTE(T) returns the character string identifying the note of
%    semitone T. If T is not a natural note the character string defaults to a
%    sharp (#) note. T may be a vector of semitones.
%
%    N = MUSIC.TONE2NOTE(T,SYM) specifies which symbol to use for accidental
%    notes. SYM may be '#' (sharp) or 'b' (flat).
%
%    Examples
%       N = music.tone2note(10);      % returns 'A#4'
%       N = music.tone2note(10,'b');  % returns 'Bb4'
%
%    See also music.tone2freq, music.tone2interval, music.note2tone.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.


% Determine if sharp or flat column should be used
if nargin < 2
    accsym = '';
end
switch lower(accsym)
    case '#'
        acc = 1;
    case 'b'
        acc = 2;
    otherwise
        acc = 1;
end

% The relative value of the semitone, as an offset from the beginning of the
% notes octave, can be used to index into this table. Which column is used
% depends on whether or not the key is expressed using sharps or flats.
noteTable = { 'C'   'C' ;
              'C#'  'Db';
              'D'   'D' ;
              'D#'  'Eb';
              'E'   'E' ;
              'F'   'F' ;
              'F#'  'Gb';
              'G'   'G' ;
              'G#'  'Ab';
              'A'   'A' ;
              'A#'  'Bb';
              'B'   'B' ;
              ''    ''  ; };

octave = 4 + floor(T / 12);
octave = num2cell(octave(:));

% Set NaN elements to []
idxNaN = cellfun(@isnan,octave);
octave(idxNaN) = {[]};

indNote                 = mod(T,12) + 1;
indNote(isnan(indNote)) = 13;

note = cellfun( @(n,o)sprintf('%s%d',n,o), ...
                noteTable(indNote,acc), ...
                octave, ...
                'UniformOutput', false );

if numel(note) == 1
    note = char(note);
else
    note = reshape(note,size(T));
end