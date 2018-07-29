function changes = get_program_changes(file_name)
% Gets the program changes in a midi file.
%
%   changes = get_program_changes(file_name)
%
% INPUTS:
%   file_name - the name of the midi file
%
% OUTPUTS:
%   changes - an Nx5 array of the patch changes.  Each row
%     is a single patch changes.  The columns are:
%        (1) the patch (instrument) number 
%        (2) the time of the command in beats
%        (3) the time of the command in seconds
%        (4) the track number
%        (5) the channel
%
% 2010-05-03 Christine Smit csmit@ee.columbia.edu



import edu.columbia.ee.csmit.MidiKaraoke.read.*;
import java.io.File;
import javax.sound.midi.*;

midiFile = File(file_name);
seq = MidiSystem.getSequence(midiFile);

% get the number of ticks/quarter note, which I assume is the
% 'beat' in the nm
ticksPerQuarterNote = seq.getResolution();

changesInMidi =  ProgramChangeViewParser.parse(seq);

changes = changesInMidi.getProgramChangesDoubles();

% add 1 to the patch numbers
changes(:,1) = changes(:,1) +1;
% convert the ticks to beats...
changes(:,2) = changes(:,2)./ticksPerQuarterNote;
% add 1 to the track number
changes(:,4) = changes(:,4)+1;
% add 1 to the channel numbers
changes(:,5) = changes(:,5)+1;


end