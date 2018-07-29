% Author : FUAT COGUN
% Date   : 16.07.2009
%
%
% Tracking the ball in a football match using Covariance Tracking Method.
%
% The application uses the algorithm introduced by the paper "Covariance Tracking Using Model Update
% Based On Riemannian Manifolds", F.Porikli, O.Tuzel, P.Meer
% 
%
% Function Files used:
% ====================
%
% findCovarianceMatrix.m, getVideoInfo.m, drawDetectionWindow.m, getScreenSize.m
%

clear all;
close all;
clc;

% Video Filename
videoFile = 'tv cam-9';

% Frame limit
videoFrameLimit = 70;

% Figure Position Offsets
positionOffset = 90;

% Adjusting Video Parameters
% ==========================

% Get the Video Information
[numOfFrames fps videoWidth videoHeight ratio] = getVideoInfo(videoFile);

% Determine max. frames to play
if (numOfFrames <= videoFrameLimit)
    maxFrame = numOfFrames;
else
    maxFrame = videoFrameLimit;
end

% Get Screen Width & Height
[screenWidth screenHeight] = getScreenSize();

% Read avi file and construct movie structure
mov = aviread(videoFile,1:maxFrame);

% Create the figure, set title & position
fig1 = figure;
x1 = positionOffset;
y1 = screenHeight - videoHeight - positionOffset;
set(fig1, 'Name', 'Original Video', 'NumberTitle', 'off', 'Position', [x1 y1 videoWidth videoHeight]) 

% Play the original video
movie(fig1, mov, 1, fps);

% constants
size = 16;
fastFactor = 4;
K = 2;
d = inf;

% for every frame in the video
for i = 1:maxFrame
    
    % RGB frame
    frameRGB = mov(i).cdata;      
    % My frame
    frameFS = frameRGB(:,:,3);   
    
    I = frameFS;
    
    if (i == 1)
        
        % initial position of the ball at the first frame:
        ballPositionX = 205;
        ballPositionY = 323;

        % calculate the Cov.Matr.
        CR = findCovarianceMatrix(I, ballPositionX, ballPositionY, size);
        Id = I;
        
        estPositionX = ballPositionX;
        estPositionY = ballPositionY;
        
    else
        
        % Determining the upper and lower limits of position around the last estimate position for candidate regions
        if estPositionY - K*fastFactor < 1
            downLimitY = 1;
        else 
            downLimitY = estPositionY - K*fastFactor;
        end
        
        if estPositionY + K*fastFactor > videoHeight - size + 1
            upLimitY = videoHeight - size + 1;
        else
            upLimitY = estPositionY + K*fastFactor;
        end
        
        if estPositionX - K*fastFactor < 1
            downLimitX = 1;
        else 
            downLimitX = estPositionX - K*fastFactor;
        end
        
        if estPositionX + K*fastFactor > videoWidth - size + 1
            upLimitX = videoHeight - size + 1;
        else
            upLimitX = estPositionX + K*fastFactor;
        end
        
                
        % search for all candidate regions:
        for y = downLimitY:fastFactor:upLimitY
            for x = downLimitX:fastFactor:upLimitX

                % construct the covariance matrix of candidate region
                CcR = findCovarianceMatrix(I,x,y,size);

                % distance metric
                v = eig(CR,CcR);        
                temp = sqrt(sum(log(v).^2));

                % decision
                if (temp < d)
                    d = temp;
                    estPositionX = x;
                    estPositionY = y;
                end         
            end
        end

        % call function to draw detection window
        Id = drawDetectionWindow(I, estPositionX, estPositionY, size);    
        
    end
    
    d = inf;
    
    % Display the estimate position for every frame
    fig4 = figure;
    x2 = 2*positionOffset + videoWidth;y2 = screenHeight - 2*videoHeight - 2*positionOffset;
    set(fig4, 'Name', 'Ball Estimated frame-by-frame', 'NumberTitle', 'off', 'Position', [x2 y2 videoWidth videoHeight])
    image(Id); colormap(gray(256));
   
end



