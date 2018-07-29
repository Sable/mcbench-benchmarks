%% Extentions
% This script shows some of the extensions I have created for accessing
% (and writing) midi files.

%% Tracks
% The standard note matrix from the
% <https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/miditoolbox/ Midi Toolbox>.  
% does not have track information.  My extensions add an eighth column to
% the note matrix with track information.

% Read in a midi file an get the track information
nm = readmidi_java('202.kar',true);
fprintf('There are %d tracks with notes in this midi file.\n', ...
    length(unique(nm(:,8))));
% And write out tracks ...
writemidi_java(nm,'track_demo.mid');
% If we read this newly created midi file back in again, we should get the
% tracks...
nm_new = readmidi_java('track_demo.mid',true);
figure(1);
clf;
plot(nm(:,8) == nm_new(:,8),'b*');
title('Note track numbers check');
xlabel('note number');
ylim([-0.2 1.2]);
set(gca,'YTick',[0,1])
set(gca,'YTickLabel',{'different','same'})


%% Lyrics
% Some midi files have lyrics embedded in them.  If the file extension is
% .kar rather than .mid or .midi, it will almost certainly have lyrics.

% Get the lyrics in text form.  get_lyrics_as_bytes() will give you the raw
% bytes, which may be easier to use for more complex processing.  Some of
% the original lyric commands in the midi file may have unprintable
% characters.  These unprintable characters are converted into hex strings
% by get_lyrics_as_text().
[lyrics info] = get_lyrics_as_text('202.kar');

% Now go ahead and print out the first 20 lyric commands and their times in
% seconds
fprintf('********* FIRST 20 RAW LYRICS ********* \n\n');
for i=1:20
   fprintf('%g: |%s|\n',info(i,2),lyrics{i});
end
fprintf('\n\n');

% Now try to do something a little smarter so that we can see the lyrics
% as lines.  In this particular midi file, 0xd indicates and end of line
% and 0xa indicates a new stanza.
fprintf('********* LYRICS IN STANZAS ********* \n\n');
for i=1:length(lyrics)
    if strcmp(lyrics{i},'[0xd]')
        fprintf('\n');
    elseif strcmp(lyrics{i},'[0xa]')
        fprintf('\n');
    else
        fprintf('%s',lyrics{i});
    end
end

%% Instrumentation
% Program commands change the instrumentation for individual channels in
% tracks.  Each <http://www.midi.org/techspecs/gm1sound.php patch number>
% corresponds to a particular instrument.  My extensions allow you to read
% the patch commands out of an existing midi file and they allow you to
% specify a single patch per channel per track when writing midi files.
% You can listen to the original midi file - with the extension changed to
% .mid - <202.mid here> and the midi file with trumpet vocals 
% <vocals_with_trumpet.mid here>.  The vocals start about 6 seconds in.

% first get the note matrix with track information
nm = readmidi_java('202.kar',true);

% now get the program changes
changes = get_program_changes('202.kar');

% let's find out what the patch was for the vocal channel
vocal_patch = changes(changes(:,5) == 3,:);

% it's a piccolo, number 73
fprintf('Vocal patch #: %d\n', vocal_patch(1));

% now let's create a new .mid file where the vocals are on a trumpet (57)
writemidi_seconds(nm,'vocals_with_trumpet.mid',[3 vocal_patch(4) 57]);


%% Tempos
% Tempo commands change the lengths of beats.  The note matrix returned by
% readmidi_java takes these tempo changes into account.

tempos = get_tempos('202.kar');
% There are quite a lot of these changes
figure(1);
clf;
plot(tempos(:,3), tempos(:,1),'*-');
title('Tempo changes in 202.kar');
xlabel('Time (s)');
ylabel('Beats per minute');
ylim([0 max(ylim)]);

% 2010-05-03 Christine Smit csmit@ee.columbia.edu



