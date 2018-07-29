%% Copyright 2012 The MathWorks, Inc.
%% Face Tracking
% Open video file
videoFileReader = vision.VideoFileReader('MWface.avi');

% Read video frame
videoFrame = step(videoFileReader);

% Detect the face
faceDetector = vision.CascadeObjectDetector('MaxSize',[150 150]);
faceBBox     = step(faceDetector,videoFrame);

% Display results
figure; subplot(1,2,1);imshow(videoFrame); hold on; 
rectangle('Position',faceBBox(1,:),'LineWidth',2,'EdgeColor',[1 1 0])
[hueChannel,~,~] = rgb2hsv(videoFrame);
subplot(1,2,2);imshow(hueChannel);hold on;
rectangle('Position',faceBBox(1,:),'LineWidth',2,'EdgeColor',[0 1 0])

%% Find a better object for tracking
% Detect the nose
noseDetector = vision.CascadeObjectDetector('Nose');
noseBBox     = step(noseDetector,videoFrame);

% Display results
figure; subplot(1,2,1);imshow(videoFrame); hold on; 
rectangle('Position',noseBBox(1,:),'LineWidth',2,'EdgeColor',[1 1 0])
subplot(1,2,2); imshow(hueChannel); hold on; 
rectangle('Position',noseBBox(1,:),'LineWidth',2,'EdgeColor',[0 1 0])

%% Set up tracking loop
% Create a tracker object.
tracker = vision.HistogramBasedTracker;

% Initialize the tracker histogram 
initializeObject(tracker, hueChannel, noseBBox(1,:));
% figure;bar(tracker.ObjectHistogram);

%%
% Create a video player object for displaying video frames.
videoInfo    = info(videoFileReader);
videoPlayer  = vision.VideoPlayer('Position',[300 300 videoInfo.VideoSize+30]);
boxInserter  = vision.ShapeInserter('BorderColor','Custom',...
    'CustomBorderColor',[255 255 0]);

% Track the face over successive video frames until the video is finished.
while ~isDone(videoFileReader)
    videoFrame = step(videoFileReader);        % Extract the next video frame
    [hueChannel,~,~] = rgb2hsv(videoFrame);    % RGB -> HSV

    % Track using the Hue channel data
    [bbox, ~, score] = step(tracker, hueChannel);

    % Insert a bounding box around the object being tracked
    videoOut = step(boxInserter, videoFrame, bbox);
    % Display the annotated video frame using the video player object
    step(videoPlayer, videoOut);

end

%% Now try to reacquire the face when it reappears
release(tracker);
reset(videoPlayer);
initializeObject(tracker, hueChannel, noseBBox(1,:));

% Track the face over successive video frames until the video is finished.
reset(videoFileReader);
while ~isDone(videoFileReader)
    videoFrame = step(videoFileReader);        % Extract the next video frame
    [hueChannel,~,~] = rgb2hsv(videoFrame);    % RGB -> HSV

    % Track using the Hue channel data
    [bbox, ~, score] = step(tracker, hueChannel);

    % Determine if face is still in the scene using score value
    if score > 0.4
        videoOut = step(boxInserter, videoFrame, bbox);
    else 
        videoOut = videoFrame;
        faceBBox = step(faceDetector,videoFrame);     % Find face again
        if ~isempty(faceBBox)
            release(noseDetector);
            noseBBox = step(noseDetector,imcrop(videoFrame,faceBBox(1,:)));
            noseBBox(1:2) = noseBBox(1:2) + faceBBox(1:2);
            release(tracker);
            initializeObject(tracker, hueChannel, noseBBox(1,:));
        end
    end
    % Display the annotated video frame using the video player object
    step(videoPlayer, videoOut);

end
% Release resources
release(videoFileReader);
release(videoPlayer);