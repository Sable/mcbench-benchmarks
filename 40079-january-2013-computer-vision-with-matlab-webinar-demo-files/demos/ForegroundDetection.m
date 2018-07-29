%% Copyright 2013 The MathWorks, Inc.

video = vision.VideoFileReader('singleball.avi');
player = vision.DeployableVideoPlayer('Location', [10,100]);

while playControls
    while ~isDone(video)
        step(player,step(video));
    end
    reset(video);
end
delete(player);
%% Detect the ball in the video

fgDetector = vision.ForegroundDetector(...
    'NumTrainingFrames', 10, 'InitialVariance', 0.05);
blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', true, ...
    'MinimumBlobArea', 70, 'CentroidOutputPort', true);
player = vision.DeployableVideoPlayer('Location', [10,100]);
fgPlayer = vision.DeployableVideoPlayer('Location', player.Location + [500 120]);
reset(video);
while playControls
    while ~isDone(video)
        image = step(video);
        I = rgb2gray(image);
        fgMask = step(fgDetector,I);
        fgMask = bwareaopen(fgMask,25);
        [~, detection] = step(blobAnalyzer,fgMask);
        step(fgPlayer,fgMask);
        if ~isempty(detection)
            position = detection(1,:);
            position(:,3) = 10;
            combinedImage = insertObjectAnnotation(image,'circle',position,'Ball');
            step(player,combinedImage);
        else
            step(player, image);
        end
        step(fgPlayer,fgMask);
    end
    reset(video);
end
delete(player);
delete(fgPlayer);

%% Track the ball in the video
% Pick kalman filter parameters for use with configureKalmanFilter 
kalmanFilter = [];
if 1
    motionModel = 'ConstantAcceleration';
    initialEstimateError = 100*ones(1,3);
    motionNoise = [25, 10, 10];
    measurementNoise = 25;
else
    motionModel = 'ConstantVelocity';
    initialEstimateError = 1000*ones(1,2);
    motionNoise = [25, 10];
    measurementNoise = 25;
end

%% Set up loop for tracking
player = vision.DeployableVideoPlayer('Location', [10,100]);
fgPlayer = vision.DeployableVideoPlayer('Location', player.Location + [500 120]);
isTrackInitialized = false;
isObjectDetected = false;

reset(video);
while playControls
    while ~isDone(video)
        image = step(video);
        I = rgb2gray(image);
        % Detect the ball
        fgMask = step(fgDetector,I);
        fgMask = bwareaopen(fgMask, 25);
        [~, detection] = step(blobAnalyzer,fgMask);
        step(fgPlayer,fgMask);
        
        % Track the ball
        if size(detection,1) > 0
            detection = detection(1,:); % only use the largest object
            isObjectDetected = true;
        else
            isObjectDetected = false;
        end
        
        if ~isTrackInitialized
            if isObjectDetected
                kalmanFilter = configureKalmanFilter(motionModel,...
                    detection, initialEstimateError, motionNoise, ...
                    measurementNoise);
                isTrackInitialized = true;
                trackedLocation = correct(kalmanFilter, detection);
                label = 'Initial';
                position = [detection 10];
                combinedImage = insertObjectAnnotation(image,'circle',position,label);
                step(player,combinedImage);
            else
                trackedLocation = [];
                label = '';
                step(player,image);
            end
        else
            if isObjectDetected
                predict(kalmanFilter);
                trackedLocation = correct(kalmanFilter,detection);
                label = 'Corrected';            
            else % ball is missing
                trackedLocation = predict(kalmanFilter);
                label = 'Predicted';
            end
            position = [trackedLocation 10];
            combinedImage = insertObjectAnnotation(image,'circle',position,label);
            step(player,combinedImage);                
        end
        step(fgPlayer,fgMask);

    end
    reset(video);
    isTrackInitialized = false;
    isObjectDetected = false;
end
delete(player);
delete(fgPlayer);
%%
release(video);
