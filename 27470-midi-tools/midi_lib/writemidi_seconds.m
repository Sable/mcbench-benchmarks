function writemidi_seconds(nm, filename, patches)
% Writes a midi file with the time (in seconds) found in nm.
%
%   writemidi_seconds(nm, filename {,patches})
%
% INPUTS:
%   nm - the note matrix.  The time in seconds (6th & 7th columns)
%     will be used rather than the time in beats (1st & 2nd columns)
%   filename - the name of the resulting midi file
%   patches (optional, default empty) - the patches 
%      (instruments) for each channel.  You can specify a 
%      single instrument for each channel/track combinations.
%      patches should be an Nx3 matrix.  The first column is 
%      the channel, the second column is the track, and the
%      third column is the patch number.  (Note that if you
%      do not supply track numbers in nm, you should pass in
%      an Nx2 matrix without the track number column.) 
%
% 2010-05-03 Christine Smit csmit@ee.columbia.edu



% set the tempo to 60 beats/minute = 1 beat/second
tempo = 60;
% set 500 ticks/quarter note
tpq = 500;
% set the time signature to something...
tsig1 = 4;
tsig2 = 4;

% Now that 1 beat = 1 second, set the beats to the seconds values
nm(:,1) = nm(:,6);
nm(:,2) = nm(:,7);

% And write...
if nargin < 3
    writemidi_java(nm,filename,tpq,tempo);
else
writemidi_java(nm,filename,tpq,tempo,tsig1,tsig2,...
    patches);
end