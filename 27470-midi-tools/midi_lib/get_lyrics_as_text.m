function [lyrics info] = get_lyrics_as_text(file_name)
% Returns the lyrics in midi file
%
%   [lyrics info] = get_lyrics(file_name)
%
% INPUTS:
%   file_name - the name of the midi file
%
% OUPUTS:
%   lyrics - an Nx1 cell array where each cell contains a text translation
%     of the ascii bytes from a lyric command.  Non-printable characters
%     are written in hexadecimal inside square brackets (for example, a
%     lyric command containing a carriage return character would be printed
%     as '[0xd]'
%   info - an Nx3 matrix.  Each row of the matrix contains additional
%     information about each cell element of lyrics.  The columns are:
%       1 - time in beats of the command
%       2 - time in seconds of the command
%       3 - track number of the command
%
% 2010-05-03 Christine Smit csmit@ee.columbia.edu



import edu.columbia.ee.csmit.MidiKaraoke.read.*;
import java.io.File;
import javax.sound.midi.*;

midiFile = File(file_name);
seq = MidiSystem.getSequence(midiFile);

% first parse the file
lyricsInMidi = LyricsViewParser.parse(seq);
% now get out the individual lyrics
lyricInTrack = lyricsInMidi.getLyrics();
N = length(lyricInTrack);
lyrics = cell(1,N);
info = zeros(N,3);

% and compile the information
for i=1:N
    lyrics{i} = char(lyricInTrack(i).getText());
    info(i,1) = lyricInTrack(i).getTicks();
    info(i,2) = lyricInTrack(i).getSeconds();
    info(i,3) = lyricInTrack(i).getTrackNumber();
end

% get the number of ticks/quarter note, which I assume is the
% 'beat' in the nm
ticksPerQuarterNote = seq.getResolution();

% convert the first column on info from ticks to beats
info(:,1) = info(:,1)./ticksPerQuarterNote;

% add 1 to the tracks
info(:,3) = info(:,3) + 1;

end