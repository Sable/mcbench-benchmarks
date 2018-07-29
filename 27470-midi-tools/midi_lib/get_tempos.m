function tempos = get_tempos(file_name)
% Returns the tempos from the midi file.
%
%   tempos = get_tempos(file_name)
%
% INPUTS:
%   file_name - the name of the midi file
% 
% OUPUTS:
%   tempos - and Nx4 list of the N tempo commands.  The colums are:
%     1 - quarter notes (beats) per minute
%     2 - time in beats at which the command was sent
%     3 - time in seconds at which the command was sent
%     4 - track number of the command
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


temposInTracks = SetTempoViewParser.parse(seq);
tempos = temposInTracks.getTemposDoubles;

% convert the first column from microseconds per quarter note to beats
% per minutes
col = 1./tempos(:,1); % quarter notes per microsecond
tempos(:,1) = col*1e6*60; 

% convert the second column from ticks to beats
tempos(:,2) = tempos(:,2)./ticksPerQuarterNote;

% add 1 to the track numbers
tempos(:,4) = tempos(:,4) +1;

end