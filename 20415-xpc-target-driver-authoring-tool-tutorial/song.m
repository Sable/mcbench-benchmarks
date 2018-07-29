function [frequencies, durations, error, statistics] = ...
   song(notes, tempo, key, steps, octaves, tune)
% SONG converts a simple text based musical note notation
%      to frequencies & durations.
%
%   SONG takes up to 6 input arguments.
%      notes   - A space delimited string of musical notes.
%      tempo   - The tempo of the song in beats per minute.
%      key     - A key signature.
%      steps   - Number of steps to raise or lower each note.
%      octaves - Number of octaves to raise or lower every note.
%      tune    - Shift notes up or down.
%   SONG returns up to 4 arguments.
%      frequencies - A vector of frequencies for each note.
%      duration    - A vector of time durations for each note.
%      error       - A message indicating any error.
%                    An empty string if no errors detected.
%      statistics  - A vector containing statistics for the song.
%                    [Length Notes Min Max]
%                    Length - Length of the song in seconds.
%                    Notes  - Number of notes in the song.
%                    Min    - Lowest non-zero frequency in the song.
%                    Max    - Highest frequency in the song.
%
%   The format for the NOTES is as follows:
%      [octave]note[[#]accidental][beats]
%   Where:
%      octave     - A number specifying the octave. Default is 0.
%                   0 represents the octave of middle C.
%      note       - A letter in the range A-G (and R or Z for a rest),
%                   that specifies the specific note.
%                   No default, the note must be specified.
%      accidental - One of n, b or #, to indicate natural, flat, or sharp.
%                   Default is n, natural.
%                   Each accidental applies to one note only, and
%                   completely overrides the key signature for that note.
%                   A number can optionally proceed the accidental
%                   to indicate multiple or fractional sharps and flats.
%                   Default is 1.
%      beats      - A number greater than zero to indicate length of the
%                   note in beats. Default is 1.
%   Each note must be seperated by a space.
%
%   There are two formats for TEMPO as follows:
%      The number of beats per minute. Default is 90.
%      The tempo can be specified by name.
%      The following names are recognized using the following tempos:
%         'Prestissimo' = 200      'Andante'     = 90
%         'Vivacissimo' = 190      'Adagietto'   = 75
%         'Presto'      = 180      'Adagio'      = 70
%         'Vivace'      = 140      'Larghetto'   = 60
%         'Allegro'     = 130      'Lento'       = 50
%         'Allegretto'  = 120      'Largamente'  = 40
%         'Moderato'    = 110      'Larghissimo' = 20
%
%   There are two formats for the KEY signature as follows:
%      A comma delimited string of characters. Each letter can be either
%         n, f or s to indicate natural, flat or sharp. The order of the
%         notes is C,D,E,F,G,A,B.
%      The key signature can be specified by name.
%      The following names are recognized:
%         'C' &'Aminor'  ='n,n,n,n,n,n,n'
%         'G' &'Eminor'  ='n,n,n,s,n,n,n'   'F' &'Dminor'  ='n,n,n,n,n,n,f'
%         'D' &'Bminor'  ='s,n,n,s,n,n,n'   'Bb'&'Gminor'  ='n,n,f,n,n,n,f'
%         'A' &'F#minor' ='s,n,n,s,s,n,n'   'Eb'&'Cminor'  ='n,n,f,n,n,f,f'
%         'E' &'C#minor' ='s,s,n,s,s,n,n'   'Ab'&'Fminor'  ='n,f,f,n,n,f,f'
%         'B' &'G#minor' ='s,s,n,s,s,s,n'   'Db'&'Bbminor' ='n,f,f,n,f,f,f'
%         'F#'&'D#minor' ='s,s,s,s,s,s,n'   'Gb'&'Ebminor' ='f,f,f,n,f,f,f'
%         'C#'&'A#minor' ='s,s,s,s,s,s,s'   'Cb'&'Abminor' ='f,f,f,f,f,f,f'
%         'Aharmonic'  ='n, n,n,n,s,n,n'
%         'Eharmonic'  ='n,s,n,s,n,n,n'    'Dharmonic'  ='s,n,n,n,n,n,f'
%         'Bharmonic'  ='s,n,n,s,n,s,n'    'Gharmonic'  ='n,n,f,s,n,n,f'
%         'F#harmonic' ='s,n,s,s,s,n,n'    'Charmonic'  ='n,n,f,n,n,f,n'
%         'C#harmonic' ='s,s,n,s,s,n,s'    'Fharmonic'  ='n,f,n,n,n,f,f'
%         'G#harmonic' ='s,s,n,2s,s,s,n'   'Bbharmonic' ='n,f,f,n,f,n,f'
%         'D#harmonic' ='2s,s,s,s,s,s,n'   'Ebharmonic' ='f,n,f,n,f,f,f'
%         'A#harmonic' ='s,s,s,s,2s,s,s'   'Abharmonic' ='f,f,f,f,n,f,f'
%   Default is the C major key.
%
%   Each note can be raised or lowered a specified number of STEPS.
%   Each step equals two semitones. Default is 0.
%
%   The entire piece can be shifted up or down full or fractional OCTAVES.
%   Default is 0, no shift.
%
%   The TUNE of the entire song can be modified. The A above middle C is
%   defined as 440Hz. This can be adjusted to any frequency, by shifting
%   A4 up or down the specified number of Hz. Default is 0.
%
%   Example:
%      [sng.tune, sng.rhythm, sng.message, sng.stats] = ...
%      song('c d e f g a b 1c2 r 1c b a g f e d c4','Allegro','C',0,0,0);
%
%   song - version 1.0      Jon Raichek      jraichek@mathworks.com

   frequencies = [];
   durations   = [];
   error       = '';
   statistics  = [0 0 0 0];

   middleC  = 0.0;
   A4       = 440.0;
   r12      = power(2.0, 1.0/12.0);
   AoffsetC = 9.0;

   % Set default tune & A4
   if nargin < 6
      tune = 0.0;
   end
   if ~isnumeric(tune)
      error = ['Tune "' tune '" must be a number.'];
      return
   end
   A4 = A4 + tune;

   % Set default octave
   if nargin < 5
      octaves = 0.0;
   end
   if ~isnumeric(octaves)
      error = ['Octave "' octaves '" must be a number.'];
      return
   end
   octaves = octaves - middleC;

   % Set default steps & semitones
   if nargin < 4
      steps = 0.0;
   end
   if ~isnumeric(steps)
      error = ['Steps "' steps '" must be a number.'];
      return
   end
   semiTones = steps * 2.0;

   % Set default key signature
   if nargin < 3
      key = 'C';
   end
   if ~ischar(key)
      error = ['Key "' num2str(key) '" must be a string.'];
      return
   end

   % Set default tempo & SPB
   if nargin < 2
      tempo = 90.0;
   else
      if ischar(tempo)
         tempo = lower(tempo);
         switch tempo
            case 'prestissimo'
               tempo = 200;
            case 'vivacissimo'
               tempo = 190;
            case 'presto'
               tempo = 180;
            case 'vivace'
               tempo = 140;
            case 'allegro'
               tempo = 130;
            case 'allegretto'
               tempo = 120;
            case 'moderato'
               tempo = 110;
            case 'andante'
               tempo =  90;
            case 'adagietto'
               tempo =  75;
            case 'adagio'
               tempo =  70;
            case 'larghetto'
               tempo =  60;
            case 'lento'
               tempo =  50;
            case 'largamente'
               tempo =  40;
            case 'larghissimo'
               tempo =  20;
            otherwise
               error = ['I do not know the tempo "' tempo, '"'];
               tempo = 90.0;
         end
      end
   end
   secondsPerBeat = 60.0 / tempo;
   if 0 > secondsPerBeat
      error = ['The tempo "' num2str(tempo) '" is too slow.'];
      secondsPerBeat = 60.0 / 90.0;
   end

   % Check notes
   if nargin < 1
      error = 'I will pick a song for you.';
      [notes, ferror] = local_pickSong(-1);
      if ferror
         error = ferror;
      end
   end
   if isnumeric(notes)
      [notes, ferror] = local_pickSong(notes);
      if ferror
         error = ferror;
      end
   else
      if strcmp(notes, 'random')
         [notes, ferror] = local_pickSong(-1);
         if ferror
            error = ferror;
         end
      end
   end
   switch notes
      case 'twinkle'
         notes = ['c c g g a a g2 f f e e d d c2 g g f f e e d2 g g f ' ...
                 ' f e e d2 c c g g a a g2 f f e e d d c2             '];
      case 'jingle'
         notes = ['g.5 g.5 g 1e 1d 1c g3 g.5 g.5 g 1e 1d 1c a3 z.5 a.5' ...
                 ' b 1f 1e 1d b3 z.5 b.5 1g 1g 1f 1d 1e3 g.5 g.5 g 1e ' ...
                 ' 1d 1c g3 g.5 g.5 g 1e 1d 1c a3 z.5 a.4 b 1f 1e 1d  ' ...
                 ' 1g 1g 1g1.5 1g.5 1a 1g 1f 1d 1c3 1g 1e 1e 1e2 1e 1e' ...
                 ' 1e2 1e 1g 1c1.5 1d.5 1e3 z 1f 1f 1f1.5 1f.5 1f 1e  ' ...
                 ' 1e 1e.5 1e.5 1e 1d 1d 1e 1d2 1g2 1e 1e 1e2 1e 1e   ' ...
                 ' 1e2 1e 1g 1c1.5 1d.5 1e3 z.5 1f 1f 1f1.5 1f.5 1f 1e' ...
                 ' 1e 1e.5 1e.5 1g 1g 1f 1d 1c3                       '];
      case 'b5intro'
         notes =  'z.5 g.5 g.5 g.5 eb2 z.5 f.5 f.5 f.5 d4             ' ;
   end

   % Lookup standard key signatures
   scale = '';
   key = lower(key);
   switch key
      case {'cmajor', 'cmaj', 'c'}
         key = 'n n n n n n n';
         scale = ['c d e f g a b 1c2 r' ...
                 ' 1c b a g f e d c4'];
      case {'gmajor', 'gmaj', 'g'}
         key = 'n n n s n n n';
         scale = ['g a b 1c 1d 1e 1f# 1g2 r' ...
                 ' 1g 1f# 1e 1d 1c b a g4'];
      case {'dmajor', 'dmaj', 'd'}
         key = 's n n s n n n';
         scale = ['d e f# g a b 1c# 1d2 r' ...
                 ' 1d 1c# b a g f# e d4'];
      case {'amajor', 'amaj', 'a'}
         key = 's n n s s n n';
         scale = ['a b 1c# 1d 1e 1f# 1g# 1a2 r' ...
                 ' 1a 1g# 1f# 1e 1d 1c# b a4'];
      case {'emajor', 'emaj', 'e'}
         key = 's s n s s n n';
         scale = ['e f# g# a b 1c# 1d# 1e2 r' ...
                 ' 1e 1d# 1c# b a g# f# e4'];
      case {'bmajor', 'bmaj', 'b'}
         key = 's s n s s s n';
         scale = ['b 1c# 1d# 1e 1f# 1g# 1a# 1b2 r' ...
                 ' 1b 1a# 1g# 1f# 1e 1d# 1c# b4'];
      case {'f#major', 'f#maj', 'f#'}
         key = 's s s s s s n';
         scale = ['f# g# a# b 1c# 1d# 1e# 1f#2 r' ...
                 ' 1f# 1e# 1d# 1c# b a# g# f#4'];
      case {'c#major', 'c#maj', 'c#'}
         key = 's s s s s s s';
         scale = ['c# d# e# f# g# a# b# 1c#2 r' ...
                 ' 1c# b# a# g# f# e# d# c#4'];
      case {'fmajor', 'fmaj', 'f'}
         key = 'n n n n n n f';
         scale = ['f g a bb 1c 1d 1e 1f2 r' ...
                 ' 1f 1e 1d 1c bb a g f4'];
      case {'bbmajor', bbmaj', 'bb'}
         key = 'n n f n n n f';
         scale = ['bb 1c 1d 1eb 1f 1g 1a 1bb2 r' ...
                 ' 1bb 1a 1g 1f 1eb 1d 1c bb4'];
      case {'ebmajor', 'ebmaj', 'eb'}
         key = 'n n f n n f f';
         scale = ['eb f g ab bb 1c 1d 1eb2 r' ...
                 ' 1eb 1d 1c bb ab g f eb4'];
      case {'abmajor', 'abmaj', 'ab'}
         key = 'n f f n n f f';
         scale = ['ab bb 1c 1db 1eb 1f 1g 1ab2 r' ...
                 ' 1ab 1g 1f 1eb 1db 1c bb ab4'];
      case {'dbmajor', 'dbmaj', 'db'}
         key = 'n f f n f f f';
         scale = ['db eb f gb ab bb 1c 1db2 r' ...
                 ' 1db 1c bb ab gb f eb db4'];
      case {'gbmajor', 'gbmaj', 'gb'}
         key = 'f f f n f f f';
         scale = ['gb ab bb 1cb 1db 1eb 1f 1gb2 r' ...
                 ' 1gb 1f 1eb 1db 1cb bb ab gb4'];
      case {'cbmajor', 'cbmaj', 'cb'}
         key = 'f f f f f f f';
         scale = ['cb db eb fb gb ab bb 1cb2 r' ...
                 ' 1cb bb ab gb fb eb db cb4'];
      case {'aminor', 'amin', 'am'}
         key = 'n n n n n n n';
         scale = ['a b 1c 1d 1e 1f 1g 1a2 r' ...
                 ' 1a 1g 1f 1e 1d 1c b a4'];
      case {'eminor', 'emin', 'em'}
         key = 'n n n s n n n';
         scale = ['e f# g a b 1c 1d 1e2 r' ...
                 ' 1e 1d 1c b a g f# e4'];
      case {'bminor', 'bmin', 'bm'}
         key = 's n n s n n n';
         scale = ['b 1c# 1d 1e 1f# 1g 1a 1b2 r' ...
                 ' 1b 1a 1g 1f# 1e 1d 1c# b4'];
      case {'f#minor', 'f#min', 'f#m'}
         key = 's n n s s n n';
         scale = ['f# g# a b 1c# 1d 1e 1f#2 r' ...
                 ' 1f# 1e 1d 1c# b a g# f#4'];
      case {'c#minor', 'c#min', 'c#m'}
         key = 's s n s s n n';
         scale = ['c# d# e f# g# a b 1c#2 r' ...
                 ' 1c# b a g# f# e d# c#4'];
      case {'g#minor', 'g#min', 'g#m'}
         key = 's s n s s s n';
         scale = ['g# a# b 1c# 1d# 1e 1f# 1g#2 r' ...
                 ' 1g# 1f# 1e 1d# 1c# b a# g#4'];
      case {'d#minor', 'd#min', 'd#m'}
         key = 's s s s s s n';
         scale = ['d# e# f# g# a# b 1c# 1d#2 r' ...
                 ' 1d# 1c# b a# g# f# e# d#4'];
      case {'a#minor', 'a#min', 'a#m'}
         key = 's s s s s s s';
         scale = ['a# b# 1c# 1d# 1e# 1f# 1g# 1a#2 r' ...
                 ' 1a# 1g# 1f# 1e# 1d# 1c# b# a#4'];
      case {'dminor', 'dmin', 'dm'}
         key = 'n n n n n n f';
         scale = ['d e f g a bb 1c 1d2 r' ...
                 ' 1d 1c bb a g f e d4'];
      case {'gminor', 'gmin', 'gm'}
         key = 'n n f n n n f';
         scale = ['g a bb 1c 1d 1eb 1f 1g2 r' ...
                 ' 1g 1f 1eb 1d 1c bb a g4'];
      case {'cminor', 'cmin', 'cm'}
         key = 'n n f n n f f';
         scale = ['c 1d 1eb 1f 1g 1ab 1bb 1c2 r' ...
                 ' 1c 1bb 1ab 1g 1f 1eb 1d c4'];
      case {'fminor', 'fmin', 'fm'}
         key = 'n f f n n f f';
         scale = ['f g ab bb 1c 1db 1eb 1f2 r' ...
                 ' 1f 1eb 1db 1c bb ab g f4'];
      case {'bbminor', 'bbmin', 'bbm'}
         key = 'n f f n f f f';
         scale = ['bb 1c 1db 1eb 1f 1gb 1ab 1bb2 r' ...
                 ' 1bb 1ab 1gb 1f 1eb 1db 1c bb4'];
      case {'ebminor', 'ebmin', 'ebm'}
         key = 'f f f n f f f';
         scale = ['eb f gb ab bb 1cb 1db 1eb2 r' ...
                 ' 1eb 1db 1cb bb ab gb f eb4'];
      case {'abminor', 'abmin', 'abm'}
         key = 'f f f f f f f';
         scale = ['ab bb 1cb 1db 1eb 1fb 1gb 1ab2 r' ...
                 ' 1ab 1gb 1fb 1eb 1db 1cb bb ab4'];
      case {'aharmonic' 'aharm' 'ah'}
         key = ' n  n  n  n  s  n  n';
         scale = ['a b 1c 1d 1e 1f 1g# 1a2 r' ...
                 ' 1a 1g# 1f 1e 1d 1c b a4'];
      case {'eharmonic' 'eharm' 'eh'}
         key = ' n  s  n  s  n  n  n';
         scale = ['e f# g a b 1c 1d# 1e2 r' ...
                 ' 1e 1d# 1c b a g f# e4'];
      case {'bharmonic' 'bharm' 'bh'}
         key = ' s  n  n  s  n  s  n';
         scale = ['b 1c# 1d 1e 1f# 1g 1a# 1b2 r' ...
                 ' 1b 1a# 1g 1f# 1e 1d 1c# b4'];
      case {'f#harmonic' 'f#harm' 'f#h'}
         key = ' s  n  s  s  s  n  n';
         scale = ['f# g# a b 1c# 1d 1e# 1f#2 r' ...
                 ' 1f# 1e# 1d 1c# b a g# f#4'];
      case {'c#harmonic' 'c#harm' 'c#h'}
         key = ' s  s  n  s  s  n  s';
         scale = ['c# d# e f# g# a b# 1c#2 r' ...
                 ' 1c# b# a g# f# e d# c#4'];
      case {'g#harmonic' 'g#harm' 'g#h'}
         key = ' s  s  n 2s  s  s  n';
         scale = ['g# a# b 1c# 1d# 1e 1f2# 1g#2 r' ...
                 ' 1g# 1f2# 1e 1d# 1c# b a# g#4'];
      case {'d#harmonic' 'd#harm' 'd#h'}
         key = '2s  s  s  s  s  s  n';
         scale = ['d# e# f# g# a# b 1c2# 1d#2 r' ...
                 ' 1d# 1c2# b a# g# f# e# d#4'];
      case {'a#harmonic' 'a#harm' 'a#h'}
         key = ' s  s  s  s 2s  s  s';
         scale = ['a# b# 1c# 1d# 1e# 1f# 1g2# 1a#2 r' ...
                 ' 1a# 1g2# 1f# 1e# 1d# 1c# b# a#4'];
      case {'dharmonic' 'dharm' 'dh'}
         key = ' s  n  n  n  n  n  f';
         scale = ['d e f g a bb 1c# 1d2 r' ...
                 ' 1d 1c# bb a g f e d4'];
      case {'gharmonic' 'gharm' 'gh'}
         key = ' n  n  f  s  n  n  f';
         scale = ['g a bb 1c 1d 1eb 1f# 1g2 r' ...
                 ' 1g 1f# 1eb 1d 1c bb a g4'];
      case {'charmonic' 'charm' 'ch'}
         key = ' n  n  f  n  n  f  n';
         scale = ['c 1d 1eb 1f 1g 1ab 1bn 1c2 r' ...
                 ' 1c 1bn 1ab 1g 1f 1eb 1d c4'];
      case {'fharmonic' 'fharm' 'fh'}
         key = ' n  f  n  n  n  f  f';
         scale = ['f g ab bb 1c 1db 1en 1f2 r' ...
                 ' 1f 1en 1db 1c bb ab g f4'];
      case {'bbharmonic' 'bbharm' 'bbh'}
         key = ' n  f  f  n  f  n  f';
         scale = ['bb 1c 1db 1eb 1f 1gb 1an 1bb2 r' ...
                 ' 1bb 1an 1gb 1f 1eb 1db 1c bb4'];
      case {'ebharmonic' 'ebharm' 'ebh'}
         key = ' f  n  f  n  f  f  f';
         scale = ['eb f gb ab bb 1cb 1dn 1eb2 r' ...
                 ' 1eb 1dn 1cb bb ab gb f eb4'];
      case {'abharmonic' 'abharm' 'abh'}
         key = ' f  f  f  f  n  f  f';
         scale = ['ab bb 1cb 1db 1eb 1fb 1gn 1ab2 r' ...
                 ' 1ab 1gn 1fb 1eb 1db 1cb bb ab4'];
      otherwise
   end

   % Play a scale
   if strcmp(notes, 'scale')
      if isempty(scale)
         scale = 'c d e f g a b 1c 1c b a g f e d c';
      end
      notes = scale;
   end

   % Parse key signature
   cdr = strrep(key, ',', ' ');
   keySig = [0 0 0 0 0 0 0];
   currentToken = 0;
   while ~isempty(cdr)
      [car, cdr] = strtok(cdr); %#ok<STTOK>
      if isempty(car)
         break
      end
      currentToken = currentToken + 1;
      badNote = ['I am not familier with the key signature ' ...
                 num2str(currentToken) ' "' car '". '];
      if currentToken > 7
         break
      end
      index = 1;
      [modifier, isNumber, index, ferror] = local_getNumber(car, index);
      if ferror
         error = [badNote ferror];
         return
      end
      if ~isNumber
         modifier = 1.0;
      end
      [accidental, isAccidental, index, ferror] = ...
         local_getAccidental(car, index);
      if ferror
         error = [badNote ferror];
         return
      end
      if ~ isAccidental
         error = [badNote 'No accidental provided.'];
         return
      end
      keySig(currentToken) = accidental * modifier;
      if index <= length(car)
         error = [badNote 'Extra stuff at end.'];
         return
      end
   end

   % Parse notes
   cdr = notes;
   currentToken = 0;
   while ~isempty(cdr)
      [car, cdr] = strtok(cdr); %#ok<STTOK>
      if isempty(car)
         break
      end
      currentToken = currentToken + 1;
      index = 1;
      badNote = ['Note ' num2str(currentToken) ' "' car ...
                 '" is out of tune. '];
      switch car(1)
         case '%'
            continue
         case {'@', '$', '!'}
            error = [badNote 'Reserved.'];
            continue
      end
      [octave, isNumber, index, ferror] = local_getNumber(car, index);
      if ferror
         error = [badNote ferror];
         break
      end
      if ~isNumber
         octave = middleC;
      end
      [note, isNote, index, ferror] = local_getNote(car, index);
      if ferror
         error = [badNote ferror];
         break
      end
      note = note - AoffsetC;
      [number, isNumber, index, ferror] = local_getNumber(car, index);
      if ferror
         error = [badNote ferror];
         break
      end
      [accidental, isAccidental, index, ferror] = ...
         local_getAccidental(car, index);
      if ferror
         error = [badNote ferror];
         break
      end
      if isAccidental
         if isNumber
            accidental = accidental * number;
         end
         [beats, isNumber, index, ferror] = local_getNumber(car, index);
         if ferror
            error = [badNote ferror];
            break
         end
      else
         if isNote
            accidental = keySig(isNote);
         end
         beats = number;
      end
      if ~isNumber
         beats = 1.0;
      end
      if 0 >= beats
         error = [badNote 'That is a very short note.'];
         continue
      end
      if index <= length(car) && car(index) == '/'
         error = [badNote 'Reserved.'];
         while index <= length(car) 
            if car(index) == '%'
               break
            end
            index = index + 1;
         end
      end
      if index <= length(car) && car(index) ~= '%'
         error = [badNote 'Extra stuff at end of note.'];
      end
      if isNote
         frequency = power(r12, note+accidental+semiTones) * ...
                     A4 *                                    ...
                     power(2, octave+octaves);
      else
         frequency = 0.0;
      end
      duration = beats * secondsPerBeat;
      frequencies = [frequencies frequency]; %#ok<AGROW>
      durations   = [durations   duration]; %#ok<AGROW>
   end

   % Collect statistics
   statistics = [sum(durations) length(frequencies)];
   if isempty(nonzeros(frequencies))
      statistics = [statistics 0];
   else
      statistics = [statistics min(nonzeros(frequencies))];
   end
   if isempty(frequencies)
      statistics = [statistics 0];
   else
      statistics = [statistics max(frequencies)];
   end

return   % End of song()


function [number, isNumber, next, error] = ...
   local_getNumber(numberString, index)
% LOCAL_GETNUMBER extracts a number from a note.
%
%   number   - The Number.
%   isNumber - 0: The was no number, 1: There was a number
%   next     - Index to first char after the number.
%   error    - Error message.

   number = 0.0;
   isNumber = 0;
   next = index;
   error = '';

   if length(numberString) < index
      return
   end

   % Number Format: [+|-]{0-9}[.]{0-9}

   sign = 1.0;
   if numberString(index) == '+'
      sign = 1.0;
      index = index + 1;
   elseif numberString(index) == '-'
      sign = -1.0;
      index = index + 1;
   end

   if length(numberString) < index
      error = 'Bad number, need more than a sign.';
      next = index;
      return
   end

   while numberString(index) == '0' || numberString(index) == '1' || ...
         numberString(index) == '2' || numberString(index) == '3' || ...
         numberString(index) == '4' || numberString(index) == '5' || ...
         numberString(index) == '6' || numberString(index) == '7' || ...
         numberString(index) == '8' || numberString(index) == '9'
      digit = 0;
      if numberString(index) == '1', digit = 1; end
      if numberString(index) == '2', digit = 2; end
      if numberString(index) == '3', digit = 3; end
      if numberString(index) == '4', digit = 4; end
      if numberString(index) == '5', digit = 5; end
      if numberString(index) == '6', digit = 6; end
      if numberString(index) == '7', digit = 7; end
      if numberString(index) == '8', digit = 8; end
      if numberString(index) == '9', digit = 9; end
      number = (number * 10) + digit;
      index = index + 1;
      if length(numberString) < index
         break;
      end
   end

   if length(numberString) < index
      next = index;
      number = number * sign;
      isNumber = 1;
      return
   end

   fraction = 0.1;
   if numberString(index) == '.'
      index = index + 1;
      if length(numberString) < index
         next = index;
         number = number * sign;
         isNumber = 1;
         return
      end
      while numberString(index) == '0' || numberString(index) == '1' || ...
            numberString(index) == '2' || numberString(index) == '3' || ...
            numberString(index) == '4' || numberString(index) == '5' || ...
            numberString(index) == '6' || numberString(index) == '7' || ...
            numberString(index) == '8' || numberString(index) == '9'
         digit = 0;
         if numberString(index) == '1', digit = 1; end
         if numberString(index) == '2', digit = 2; end
         if numberString(index) == '3', digit = 3; end
         if numberString(index) == '4', digit = 4; end
         if numberString(index) == '5', digit = 5; end
         if numberString(index) == '6', digit = 6; end
         if numberString(index) == '7', digit = 7; end
         if numberString(index) == '8', digit = 8; end
         if numberString(index) == '9', digit = 9; end
         number = number + (digit * fraction);
         fraction = fraction / 10.0;
         index = index + 1;
         if length(numberString) < index
            break;
         end
      end
   end

   next = index;

   number = number * sign;

   isNumber = 1;

return   % End of local_getNumber()


function [accidental, isAccidental, next, error] = ...
   local_getAccidental(accidentalString, index)
% LOCAL_GETACCIDENTAL extracts the accidental from a note.
%
%   accidental   - Number of semitones from the natural note.
%   isAccidental - 0: The was no accidental, 1: There was an accidental
%   next         - Index to first char after the accidental.
%   error        - Error message.

   accidental = 0.0;
   isAccidental = 0;
   next = index;
   error = '';

   if length(accidentalString) < index
      return
   end

   % accidental is the number of semitones from the natural note
   switch accidentalString(index)
      case {'n', 'N'}
         accidental = 0.0;
         isAccidental = 1;
      case {'b', 'f', 'F'}
         accidental = -1.0;
         isAccidental = 1;
      case {'#', 's', 'S'}
         accidental = 1.0;
         isAccidental = 1;
      otherwise
         accidental = 0.0;
         isAccidental = 0;
   end

   if isAccidental
      next = index + 1;
   end

return   % End of local_getAccidental()


function [note, isNote, next, error] = local_getNote(noteString, index)
% LOCAL_GETNOTE extracts the note.
%
%   note   - Number of semitones from C.
%   isNote - 0:Rest, 1:C, 2:D, 3:E, 4:F, 5:G, 6:A, 7:B
%   next   - Index to first char after the note.
%   error  - Error message.

   note = 0;
   isNote = 0;
   next = index;
   error = '';

   if length(noteString) < index
      error = 'There is no note.';
      return
   end

   % note is the number of semitones from C
   switch noteString(index)
      case {'A', 'a'}
         note = 9.0;
         isNote = 6;
      case {'B', 'b'}
         note = 11.0;
         isNote = 7;
      case {'C', 'c'}
         note = 0.0;
         isNote = 1;
      case {'D', 'd'}
         note = 2.0;
         isNote = 2;
      case {'E', 'e'}
         note = 4.0;
         isNote = 3;
      case {'F', 'f'}
         note = 5.0;
         isNote = 4;
      case {'G', 'g'}
         note = 7.0;
         isNote = 5;
      case {'R', 'r', 'Z', 'z'}
         isNote = 0;
      otherwise
         error = 'I only know the notes A-G and rests';
         return
   end

   next = index + 1;

return   % End of local_getNote()


function [ditty, error] = local_pickSong(pick)
% LOCAL_PICKSONG picks a song.
%
%   ditty - Name of selected or random song.
%   error - Error message.

   error = '';

   if pick < 0
      c = clock;
      pick = rem(round(c(6)*1000), 3);
   end

   switch pick
      case 0
         ditty = 'twinkle';
      case 1
         ditty = 'jingle';
      case 2
         ditty = 'b5intro';
      otherwise
         ditty = 'scale';
         error = 'I never heard of that song, how about a nice scale?';
   end

return   % End of local_pickSong()
