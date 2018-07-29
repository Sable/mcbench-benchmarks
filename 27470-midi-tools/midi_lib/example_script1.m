%% Reading and writing midi files
% This short demo will show you how to read in a midi file, do some simple
% manipulation, and then write out new modified files.  
%
% Before you try these function, you will need to make sure that
% KaraokeMidiJava.jar can be found by matlab.  The easiest way to do this
% is to edit Matlab's |classpath.txt| and add the path to the midi jar.
% You will, I believe, need to restart Matlab once you have updated the
% classpath file.
%
% |readmidi_java.m| and |writemidi_java.m| were inspired by the |readmidi.m| and
% |writemidi.m| of the
% <https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/miditoolbox/ Midi Toolbox>.  
% My versions can take the same inputs, but also
% have a few extensions, which you can find by reading the help information
% for each function.
%

%% Reading in a midi file
% First read in the file, which is "The sun, whose rays are all ablaze" 
% from _The Mikado_ by Gilbert and Sullivan.  (Thanks to the 
% <http://math.boisestate.edu/gas/mikado/html/index.html Gilbert & Sullivan archives> for this file!)

% Read a midi file into a note matrix, getting the optional
% track column.  (Note that .kar files are midi karaoke files.  They use
% exactly the same file format as .mid files.  The .kar basically just
% indicates that this is a midi file which contains midi lyric messages.) 
%
% The columns are:
%       (1) - note start in beats
%       (2) - note duration in beats
%       (3) - channel
%       (4) - midi pitch (60 --> C4 = middle C)
%       (5) - velocity
%       (6) - note start in seconds
%       (7) - note duration in seconds
note_matrix = readmidi_java('202.kar');

% see how many notes we have
fprintf('Number of notes: %d\n', size(note_matrix,1));
% plot the note onsets 
figure(1);
clf;
plot(note_matrix(:,1));
ylabel('Note onset (beats)');
xlabel('Note index');
title('Note onsets in beats');
figure(2);
clf;
plot(note_matrix(:,6));
ylabel('Note onset (seconds)');
xlabel('Note index');
title('Note onsets in seconds');


%% Writing out a midi file
% Now write out a couple of midi files that just contain the notes from the
% vocals melody.

% The vocal melody is in channel 3.
vocal_matrix = note_matrix(note_matrix(:,3) == 3,:);
% Get the tempo information from 202.kar
tempos = get_tempos('202.kar');
fprintf('Number of tempos: %d\n', size(tempos,1));

% Write out a midi file that preserves the beat information.  Use the last
% tempo from 202.kar
writemidi_java(vocal_matrix,'just_vocals_beats.mid',120,tempos(end,1));
% Write out another version that preserves the timing.  This may be helpful
% if you want to synthesize the file.  202.kar has
% multiple tempo changes, so specifying a single tempo in writemidi_java
% won't help.  This function writes a midi file that preserves the times in
% the note matrix (columns 6 & 7), but not the beats.  
writemidi_seconds(vocal_matrix,'just_vocals_seconds.mid');

%%  Checking written midi file
% Read the vocal file in and make sure that it matches what we wrote.
% The |just_vocals_beats.mid| file should have preserved the beat information
% in |note_matrix|, but the timing information will be wrong because of the
% tempo changes in |202.kar|.  The |just_vocals_seconds.mid| file should do the
% opposite.

vm_beats = readmidi_java('just_vocals_beats.mid');
vm_seconds = readmidi_java('just_vocals_seconds.mid');

figure(1);
clf
plot(vocal_matrix(:,1), 'b.-');
hold on;
plot(vm_beats(:,1),'r');
plot(vm_seconds(:,1),'g');
legend('manipulated note matrix', 'correct beats matrix',...
    'correct times matrix','Location','NorthWest');
legend('boxoff');
ylabel('Note onset (beats)');
xlabel('Note index');
title('Vocal line notes in beats');

figure(2);
clf
plot(vocal_matrix(:,6), 'b.-');
hold on;
plot(vm_beats(:,6),'r');
plot(vm_seconds(:,6),'g');
legend('manipulated note matrix', 'correct beats matrix',...
    'correct times matrix','Location','NorthWest');
legend('boxoff');
ylabel('Note onset (seconds)');
xlabel('Note index');
title('Vocal line notes in seconds');

% 2010-05-03 Christine Smit csmit@ee.columbia.edu

