function display_midi_in_time_order(file_name)
% Prints the events of a midi file to the screen in time order 
% (as opposed to by track).
%
%   display_midi_in_time_order(file_name)
%
% INPUTS:
%   file_name - name of the midi file
%
% NOTES:
%   Each line of the display represents a single midi message.
%   For example,
%
%   [Note Off (channel 0): 60, velocity 40] track 1, 1.0 (200)
%
%   Means that this is a note off command on channel 0, note 
%   number 60, velocity 40, track 1, time 1.0 (in seconds) and
%   200 (in ticks).
%
% 2010-05-03 Christine Smit csmit@ee.columbia.edu


import edu.columbia.ee.csmit.MidiKaraoke.read.MidiCommandSorter;
import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import javax.sound.midi.MidiMessage;
import javax.sound.midi.MidiSystem;
import javax.sound.midi.Sequence;

file = File(file_name);
mySeq = MidiSystem.getSequence(file);
            
commands = MidiCommandSorter.sort(mySeq);
it = commands.iterator();
% Note that each line here contains the midi command, the track
% number, the time of the command in seconds, and the time in
% ticks.  Also note that the midi commands appear in time-order,
% not file order.  The time in seconds has been calculated from
% the tempo changes in the file.
while it.hasNext()
    fprintf('%s\n',char(it.next().toString()));
end

end