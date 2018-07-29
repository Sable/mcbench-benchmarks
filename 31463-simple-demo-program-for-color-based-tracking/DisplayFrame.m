%% DISPLAYFRAME updates the image frame on the video player
% hp : handle to video.VideoPlayer
% vF : new frame
% fi : frame index
% fps: frame per second
%
% PManandhar: I have commented out the text insertion code here because it
% was too slow in my system.
function DisplayFrame(hp, vF, fi, fps)
% tf = fi/fps;
% Hti = video.TextInserter(sprintf('%d: %fs', fi, tf));
% Hti.Color = [255 255 255];
% Hti.FontSize = 12;
% Hti.Location = [10 10];
% videoFrame = step(Hti, vF);
% step(hp, videoFrame);

step(hp, vF);
