function videoOut   = slitscan(varargin)
% Process video simulating a slit-scan camera.
% SYNTAX
% videoOut          = slitscan(videoIn, nLinesPerScan, direction, nLoops,...
%                               displayVideo, saveVideo)
% INPUTS
% fileName          File name of the video to modify 
% nLinesPerScan     Number of lines per scan. The less lines the smoother video
%                   is. Default is 5.
% direction         Is the direction the delay increases in. 
%                   'BottomToTop' means that the bottom line is behind the top
%                   by a number of frames equal to the height of the clip.
%                   'TopToBottom' means that the top line is behind the bottom
%                   by a number of frames equal to the height of the clip.
%                   Default is 'TopToBottom'.
% nLoops            Number of times to repeat original video. Default is 1.
% displayVideo      Open a figure where the slit-scan video is played. Default
%                   true.
% saveVideo         Save the modified video as a new file '_slitscan' is added 
%                   to the file name. Default false.
% OUTPUT 
% videoOut          Video structure
%_______________________________________________________________________________
% Copyright (C) 2013 Edgar Guevara Codina
%_______________________________________________________________________________

%% Inputs handling
% only want 1 optional input at most
numVarArgs          = length(varargin);
if numVarArgs       > 6
    error('slitscan:TooManyInputs', ...
        'requires at most 6 optional input: fileName nLinesPerScan direction nLoops displayVideo saveVideo');
end
% set defaults for optional inputs ()
optArgs             = {[] 5 'TopToBottom' 1 true false};
% now put these defaults into the optArgs cell array, and overwrite the ones
% specified in varargin.
optArgs(1:numVarArgs)...
                    = varargin;
% Place optional args in memorable variable names
[fileName nLinesPerScan direction nLoops displayVideo saveVideo]...
                    = optArgs{:};
if isempty(fileName)
    [fileName,pathName,~] ...
                    = uigetfile( ...
{'*.avi;*.mpg;*.wmv;*.asf;*.asx;*.mp4;*.m4v;*.mov;*.ogg','Video Files (*.avi,*.mpg,*.wmv,*.asf,*.asx,*.mp4,*.m4v,*.mov,*.ogg)';
   '*.*',  'All Files (*.*)'}, ...
   'Pick a video file');
    fileName        = fullfile(pathName,fileName);
end

%% Read video file
videoObj            = mmreader(fileName);
videoInfo           = mmfileinfo(fileName);
nFrames             = videoObj.NumberOfFrames;
vidHeight           = videoInfo.Video.Height;
vidWidth            = videoInfo.Video.Width;
vidFrames           = read(videoObj);
frameRate           = videoObj.FrameRate;
% Preallocate structure movIn
movIn(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);
% Read one frame at a time.
for iFrames         = 1:nFrames
    movIn(iFrames)...
        .cdata      = vidFrames(:,:,:,iFrames);
    movIn(iFrames)...
        .colormap   = [];
end

%% Playback original movie
if displayVideo
    % Create a figure
    hf              = figure;
    set(hf, 'Name', fileName)
    % Resize figure based on the video's width and height
    set(hf, 'position', [10 15 vidWidth vidHeight])
    % Playback movie once at the video's frame rate
    movie(hf, movIn, 1, frameRate);
end

%% Slit-scan processing
videoIn             = repmat(movIn,[1 nLoops]);
nFrames             = numel(videoIn);
% cleanup
clear movIn
% circular buffer (FIFO). Size of buffer depends on images resolutions and lines
% per scan
bufferSize          = round(vidHeight/nLinesPerScan);
% Calculate vertical position
topIdx              = 1:nLinesPerScan:vidHeight-nLinesPerScan;
bottomIdx           = topIdx + nLinesPerScan;
switch direction
    case 'TopToBottom'
        % Do nothing
    case 'BottomToTop'
        topIdx      = fliplr(topIdx);
        bottomIdx   = fliplr(bottomIdx);
    otherwise
        % Do nothing
end
% Initialize buffer
if bufferSize       > nFrames
    bufferSize      = nFrames;
end
circBuff            = videoIn(1:bufferSize);
% Initialize output
videoOut            = videoIn;
clc
fprintf('Slit-scanning processing...\n');
for lastFrame       = 1:nFrames;
    thisBuffer      = rem(lastFrame, bufferSize);
    % Extract n number of lines from previous images. Use extracted lines to
    % construct the slit scan image, by placing them in the relevent vertical
    % location
    for iBuffer     = 1:thisBuffer,
        videoOut(lastFrame).cdata(topIdx(iBuffer):bottomIdx(iBuffer),:,:)...
                    = circBuff(iBuffer).cdata(topIdx(iBuffer):bottomIdx(iBuffer),:,:);
    end
    % Update circular buffer (FIFO)
    circBuff        = [circBuff(2:end) videoOut(lastFrame)];
end
fprintf('Slit-scanning done!\n');

%% Playback modified movie
if displayVideo
    hf              = figure;
    set(hf, 'Name', 'Slit-scan video')
    set(hf, 'position', [10 15 vidWidth vidHeight])
    movie(hf, videoOut, 1, frameRate);
end

%% Save processed video file
if saveVideo
    [pathName, fileName ,fileExt]...
                    = fileparts(fileName);
    fileName        = fullfile(pathName,[fileName '_slitscan' fileExt]);
    fprintf('Saving video as %s...\n',fileName);
    movie2avi(videoOut, fileName);
    fprintf('Saving video done!...\n');
end

% EOF
