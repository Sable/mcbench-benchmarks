%  This script demonstrates the use of the MTM_PWC function for moving
%  shadow detection in video. The script works with the SZTAKI Benchmark
%  Set ([Online] http://web.eee.sztaki.hu/~bcsaba/FgShBenchmark.htm) but
%  can be easily converted to work with any video dataset.

%  Written by: Elad Bullkich, Idan Ilan, Yair Moshe
%  Signal and Image Processing Laboratory (SIPL)
%  Department of Electrical Engineering
%  Technion - Israel Institute of Technology
%
%  $Revision 1.1        $Date: 6/17/2012

% Reference:
% E. Bullkich, I. Ilan, Y. Moshe, Y. Hel-Or, and H. Hel-Or, "Moving Shadow
% Detection by Nonlinear Tone-Mapping," Proc. of 19th Intl. Conf. on
% Systems, Signals and Image Processing (IWSSIP 2012), Vienna, April 2012.
% [Online]  http://sipl.technion.ac.il/~yair/

%% initializations
videoPath = 'Highway\RawData';                                    % path for input video sequence
foregroundPath = 'Highway\ForegroundMasks'; % path for ground-truth foreground masks
shadowPath= 'Highway\ShadowMasks';                       % path for ground-truth shadow masks
outputPath = 'Highway\results';                                 % path for writing detected shadows

L = 56;                            % window size
binSize = 10;            % bin size (used to compute bin boundaries)
direction = 'P2W';  % 'P2W' for pattern-to-window MTM, 'W2P' for window-to-pattern MTM

filesList = dir([videoPath '\*.jpg']);
framesNum = size(filesList, 1) - 1;    % number of frames in the sequence
bgFramesRange = [1, framesNum];         % range of frames used to build background model

% build vector of increasing values representing bin boundaries
alpha = [[0:binSize:255] 256];
if sum(alpha == 255)
    alpha(end - 1) = [];
end

%% read video sequence
for curFrameNum = 1:framesNum
    fileName = [videoPath '\' num2str(curFrameNum, '%04d') '.jpg'];
    curFrame = imread(fileName);
    sequence(:, :, curFrameNum) = curFrame(:, :, 2);    % use green layer in RGB color space
end

%% compute background model
background = double(getBackground(sequence, bgFramesRange));

%% apply MTM and threshold
for curFrameNum = 1:framesNum
    % read foreground mask
    objectFilename = [foregroundPath '\' num2str(curFrameNum, '%04d') ' copy.jpg'];
    shadowFilename = [shadowPath '\' num2str(curFrameNum, '%04d') ' copy.jpg'];
    if (~exist(objectFilename, 'file')) | (~exist(shadowFilename, 'file'))    
        continue;    % if no ground-truth masks available, ignore this frame
    end
    objectMask = im2bw(imread(objectFilename), 0.5);
    shadowMask = im2bw(imread(shadowFilename), 0.5);
    foregroundMask = objectMask | shadowMask;
    
    % apply MTM
    curFrame = sequence(:, :, curFrameNum);
    if strcmp(direction, 'P2W')
        distMap = MTM_PWC(curFrame, background, foregroundMask, L, alpha);
    elseif  strcmp(direction, 'W2P')
        distMap = MTM_PWC(background, curFrame, foregroundMask, L, alpha);
    end
    
    % threshold distance map
    level = thresh(distMap);
    foreground = im2bw(distMap, level);
    
    % save detected shadow to output path
    imwrite(uint8(255*(foregroundMask-foreground)), [outputPath '\' num2str(curFrameNum, '%04d') '.png'], 'png');
end