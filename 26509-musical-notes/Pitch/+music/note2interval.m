function [I,oct] = note2interval(N,key)
% MUSIC.NOTE2INTERVAL Converts a note string to a semitone interval and octave.
%   [I,O] = MUSIC.NOTE2INTERVAL(N) returns the interval I and octave O at which
%   note N is found in the key of 'C'. N is a note in scientific pitch notation
%   (e.g. 'A#3') or a simple note string without an octave specification (e.g.
%   'A#'). If the octave is not defined O will be NaN. N may be a cell array of
%   strings.
%
%   [I,O] = MUSIC.NOTE2INTERVAL(N,KEY) returns the interval at which note N is
%   found in the key of KEY. KEY may be a character note (e.g., 'A', 'F#'), or
%   an interval offset from 'C'.
%
%   Example
%      [I,O] = music.note2interval('F#')       % returns 6, NaN
%      [I,O] = music.note2interval('F#5','G')  % returns 11, 5
%
%   See also music.note2tone, music.note2freq, music.interval2note.

%    Author: E. Johnson
%    Copyright 2010 The MathWorks, Inc.


% Resolve character key to offset from C
if nargin < 2
    key = 0;
end
if ischar(key)
    key = music.note2interval(key);
end

% The interval offset from the beginning of the notes octave, can be used to
% index into this table. Which column is used depends on whether or not the key
% is expressed using sharps or flats.
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
              'B'   'B' ; };
   
N  = cellstr(N);  % ensure N is a cell array
sz = size(N);     % record original size of N
N  = N(:);        % ensure N is a column vector


% Use regular expression to separate octave from note.
C = regexp(N,'([AaBbCcDdEeFfGg][Bb#]?)(\d*$)','tokens');

note = cellfun( @(c)c{1}{1}, C, 'UniformOutput', false );  % simple note
oct  = cellfun( @(c)str2double(c{1}{2}), C );              % octave

ind  = cellfun(@(n)find(strcmpi(noteTable,n),1),note);

[row,col] = ind2sub(size(noteTable),ind); %#ok

I = row - 1 - key;
I = mod(I,12);

I   = reshape(I,  sz);
oct = reshape(oct,sz);