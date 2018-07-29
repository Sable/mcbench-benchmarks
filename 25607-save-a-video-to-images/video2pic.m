function video2pic( videoFile, outputPath, picFormat )
%VIDEO2PIC converts viedo frames into pictures.
%   This function uses mmreader to read videos. Thus video format supported
%   by system can be converted to pictures. Output file name follows the
%   format: VideoName_FrameNumber.PicSuffix.
%
%   VIDEO2PIC input parameters interactively.
%   VIDEO2PIC( VIDEOFILE, OUTPUTPATH, PICFORMAT ) runs as a
%   function.
%
%   videoFile: full path of video to convert.
%   outputPath: pictures will be saved under outputPath/videoname/.
%   picFormat: check 'help imwrite'
%
%	Shiquan Wang @ CASIA
%	sqwang@nlpr.ia.ac.cn
%   http://www.cbsr.ia.ac.cn/users/sqwang/
%	revised on 2009/10/19


%% Initialization
if nargin < 1
    videoFile = input('Input full video path:', 's');
    outputPath = input('Input video output path[Default is under the video path]:', 's');
    if isempty(outputPath)
        outputPath = videoFile(1, 1:find(videoFile=='\', 1, 'last')-1);
    end
    picFormat = input('Input output pic format[JPG by default]:');
    if isempty(picFormat)
        picFormat = 'JPG';
    end
end

%% Main part
videoObject = mmreader(videoFile);
numFrames = get(videoObject, 'numberOfFrames');
fileName = get(videoObject, 'Name');
% bitsPerPix = get(videoObject, 'BitsPerPixel');
% H = get(videoObject, 'Height');
% W = get(videoObject, 'Width');
% bytesPerFrame = bitsPerPix*H*W/8;
outputPath = fullfile(outputPath, fileName(1, 1:find(fileName=='.', 1, 'last')-1));
numOrder = max(4, size(int2str(numFrames), 2));
mkdir(outputPath);

indexFrame = [1 1];
frameLimit = 100; % This can be set a larger value with enough memory.
while indexFrame(1, 1) <= numFrames
%     memorynow = memory;
%     memoryMax = memorynow.MaxPossibleArrayBytes;
%     frameLimit = floor(memoryMax/bytesPerFrame*0.8);
    indexFrame(1, 2) = min(numFrames, indexFrame(1, 1) + frameLimit);
    frameAll = read(videoObject, indexFrame);
    
    for i = indexFrame(1, 1):1:indexFrame(1, 2)    %save frames to pic        
        imgFrame = frameAll(:,:,:,i - indexFrame(1, 1) + 1);
        saveFormat = strcat('%s\\%s_%0', int2str(numOrder), 'd.%s');
        picName = sprintf(saveFormat, outputPath, fileName, i, picFormat);
        imwrite(imgFrame, picName);
        disp(picName); % This output can be turned off.
    end
    indexFrame(1, 1) = indexFrame(1, 2) + 1;
end

end

