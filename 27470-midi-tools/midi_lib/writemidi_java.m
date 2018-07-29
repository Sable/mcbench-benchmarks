function writemidi_java(nm, filename, tpq, tempo,...
    tsig1, tsig2, patches)
% Writes a midi file just as writemidi from the matlab midi 
% toolbox.  Please note that this function ignores the 6th & 
% 7th columns of nm, just like writemidi does.  Also note that 
% there can be only one tempo.
%
%   writemidi_java(nm, filename, tpq, tempo,...
%      tsig1, tsig2, patches);
%
% INPUTS:
%   nm - the note matrix, which has the same form as the note
%     matrix returned by readmidi_java.  It may optionally 
%     include an eighth column with the track numbers for each 
%     note.
%   filename - the name for the resulting midi file.
%   tpq (optional, default 120) - ticks per quarter note
%   tempo (optional, default 100) - beats per minute
%   tsig1, tsig2 (optional, default 4 & 4) - the time signature
%      specified as a fraction.  For example, 3/4 --> tsig1 = 3
%      and tsig2 = 4.
%   patches (optional, default empty) - the patches 
%      (instruments) for each channel.  You can specify a 
%      single instrument for each channel/track combinations.
%      patches should be an Nx3 matrix.  The first column is 
%      the channel, the second column is the track, and the
%      third column is the patch number.  (Note that if you
%      do not supply track numbers in nm, you should pass in
%      an Nx2 matrix without the track number column.)
% 
% NOTES:
%   (1) Channel numbers, track numbers, and midi patches begin
%       at 1.  So patch number 1 is the acoustic grand piano.
%
% 2010-05-03 Christine Smit csmit@ee.columbia.edu



if nargin < 3
    tpq = 120;
end
if nargin < 4
    tempo = 100;
    
end
if nargin < 5
    tsig1 = 4;
end
if nargin < 6
    tsig2 = 4;
end

if nargin < 7
    patches = zeros(0,3);
end

% tempo is in beats per minute, we need microseconds
% per quarter note
microseconds_per_minute = 1e6*60;
microseconds_per_quarter_note = (1/tempo)*...
    microseconds_per_minute;


% convert the denominator of the time signature
% into the correct number for the midi standard
tsig2 = log2(tsig2);

% now create the time signature array.  32 midi clocks per
% quarter note.  8 32nd notes per quarter note.
tsig = [tsig1 tsig2 32 8];


onsets = nm(:,1);
duration = nm(:,2);
channel = nm(:,3)-1; % midi actually starts with channel 0
pitch = nm(:,4);
velocity = nm(:,5);

% see if there is track information....
if size(nm,2) == 8
    % write it if there is...
    tracks = nm(:,8)-1;
    
else
    % otherwise put everything on track zero
    tracks = zeros(size(nm,1),1);
    % and specify that all the patches are for track zero
    patches = [patches(:,1) ones(size(patches,1),1)...
        patches(:,2)];
end    

% subtract 1 from the channels, tracks, and patch numbers so 
% that that they start at 0 instead of 1
patches = patches -1;

% now call the java code
import edu.columbia.ee.csmit.MidiKaraoke.write.SimpleMidiWriter;


SimpleMidiWriter.write(filename,onsets,duration, channel,...
    pitch, velocity, tracks,microseconds_per_quarter_note, ...
    tpq, tsig,patches);

end