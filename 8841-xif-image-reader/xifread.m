function [X, meta] = xifread(filename, debug)

%xifread version 0.3 - Reads HDILab/ATL xif ultrasound data files.
%Written by Bo Lind - bolind@ikol.dk
%
%Usage: [X, meta] = xifread('myfile.xif');
%or:    [X, meta] = xifread('myfile.xif', 1); for verbose mode
%
%Where meta is an (optional) struct with the following fields:
%
%scanlines   Number of scanlines
%samples     Number of samples per scanline
%frames      Number of frames
%framerate   Frame rate
%width       Width in mm
%height      Height in mm
%
%Note, X is a three-dimensional matrix of type uint8, to save memory.
%Convert to double if needed.

%Check number of arguments. One is required, the filename, if number two
%evaluates to true, verbose/debug mode info will be printed.
if (nargin < 1)
    error('xifread: Bad number of arguments.');
elseif (nargin == 1)
    debug = 0;
elseif (nargin > 1)
    debug = 1;
end

%Open file.
FID = fopen(filename, 'r');

%Abort if error opening file (does not exist, etc.)
if (FID == -1)
    error('Error opening file: %s, aborting...', filename);
end

%Run through the XML header, reading in scanlines, samples etc.
s = [];
while (size(strfind(s, '#SOH')) == 0)
    s = fgets(FID);
        if (strfind(s, 'echoNumLines'))
        s = fgets(FID);
        s = fgets(FID);
        meta.scanlines = str2num(cell2mat(regexp(s, '(\d+)', 'match')));
    end
    if (strfind(s, 'echoNumDisplaySamples'))
        s = fgets(FID);
        s = fgets(FID);
        meta.samples = str2num(cell2mat(regexp(s, '(\d+)', 'match')));
    end
    if (strfind(s, 'numFrames'))
        s = fgets(FID);
        s = fgets(FID);
        meta.frames = str2num(cell2mat(regexp(s, '(\d+)', 'match')));
    end
    if (strfind(s, 'frameRate'))
        s = fgets(FID);
        s = fgets(FID);
        meta.framerate = str2num(cell2mat(regexp(s, '(\d+)', 'match')));
    end
    if (strfind(s, 'echoScan_linearWidth'))
        s = fgets(FID);
        s = fgets(FID);
        %Different regexp, as we need to match a decimal number.
        meta.width = str2num(cell2mat(regexp(s, '(\d+\.\d+)', 'match')));
    end
    if (strfind(s, 'echoDepth_twodDepth'))
        s = fgets(FID);
        s = fgets(FID);
        %Same as above.
        meta.height = str2num(cell2mat(regexp(s, '(\d+\.\d+)', 'match')));
    end
end

if (debug)
    fprintf('numLines: %d\n', meta.scanlines);
    fprintf('numDisplaySamples: %d\n', meta.samples);
    fprintf('numFrames: %d\n', meta.frames);
    fprintf('frameRate: %d\n', meta.framerate);
    fprintf('echoScan_linearWidth: %d\n', meta.width);
    fprintf('echoDepth_twodDepth: %d\n', meta.height);
end

%Read throuh C-style header.
s = [];
while (size(strfind(s, '#EOH')) == 0)
    s = fgets(FID);
end

%Now filepointer is at start of data. We simply read them in.
%Initializing X first, to allocate memory in a sane fashion.
X = uint8(zeros(uint16([meta.samples, meta.scanlines, meta.frames])));
for i = 1:meta.frames
    X(:,:,i) = fread(FID, [meta.samples, meta.scanlines], 'uchar');
end

fclose(FID);