function timeSignatures = get_time_signatures(file_name)
% Returns the time signatures from the midi file.
%
%   timeSignatures = get_time_signatures(file_name)
%
% INPUTS:
%   file_name - the name of the midi file
%
% OUTPUTS:
%   timeSignatures - the time signature commands.  The columns are:
%     1 - numerator of time signature
%     2 - denominator of time signature
%     3 - number of midi clocks in a metronome click
%     4 - the "number of notated 32nd notes in a midi quarter note" (stolen
%       from http://www.borg.com/~jglatt/tech/midifile/time.htm)
%     5 - time of event in beats
%     6 - time of event in seconds
%     7 - track number
%
% 2010-05-03 Christine Smit csmit@ee.columbia.edu



import edu.columbia.ee.csmit.MidiKaraoke.read.*;
import java.io.File;
import javax.sound.midi.*;


midiFile = File(file_name);
seq = MidiSystem.getSequence(midiFile);

timeSignatureRoll = TimeSignatureViewParser.parse(seq);
timeSignatures = timeSignatureRoll.getTimeSignaturesDoubles;

% get the number of ticks/quarter note, which I assume is the
% 'beat' in the nm
ticksPerQuarterNote = seq.getResolution();

% convert ticks to beats
timeSignatures(:,5) = timeSignatures(:,5)./ticksPerQuarterNote;

% add 1 to the track number
timeSignatures(:,7) = timeSignatures(:,7) +1;

end