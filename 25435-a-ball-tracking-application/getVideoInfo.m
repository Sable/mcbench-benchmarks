% Author : FUAT COGUN
% Date   : 16.07.2009
%
%
% Gets the video information of the specified video file.
% 
%
% Inputs  : -Name of the video file                             (String)
% ======
%
% Outputs : -Number of frames in video file                     (Integer)
% =======   -Frames per Second                                  (Integer)
%           -Width of the video                                 (Integer)
%           -Height of the video                                (Integer)
%           -Width-to-Height ratio                              (Double)

function [numOfFrames fps videoWidth videoHeight ratio] = getVideoInfo(videoFile)

    info = aviinfo(videoFile);
    numOfFrames = info.NumFrames;
    fps = info.FramesPerSecond;
    videoWidth = info.Width;
    videoHeight = info.Height;
    ratio = videoWidth/videoHeight;
    