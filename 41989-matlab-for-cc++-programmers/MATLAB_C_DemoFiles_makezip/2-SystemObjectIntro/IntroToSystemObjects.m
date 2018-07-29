%% Introduction to Video Processing
% 
% This demo introduces the basics of video processing
% using system objects and Computer Vision System
% Toolbox.
%
% Copyright 2012-2013 MathWorks, Inc.

%% Initialize Objects
% The much of the functionality of system toolboxes
% lie in the system objects.  System objects are 
% an implementation of an algorithm.  They are designed
% to be configured once and used again and again -
% ideal for streaming systems, as in this case video.
%
% Below we create the system objects we will use in
% the main portion of the demo.

%%
% File Reader
hReader = vision.VideoFileReader('viplanedeparture.avi');

% Video Player
hPlayer = vision.VideoPlayer;

%% Display First Frame
frame = step(hReader);

step(hPlayer, frame);

%% Loop Entire Video
while ~isDone(hReader)
    frame = step(hReader);
    
    step(hPlayer, frame);
end

%% Reset Reader to Start of File
% Resetting the Video File Reader returns the reader
% to the beginning of the file, enabling us to rerun
% the core of algorithm if so desired.
reset(hReader);

%% Release Resources
% Close any open file handles or open devices.  
% This is automatically called when a system 
% object goes out of scope.
release(hReader);
