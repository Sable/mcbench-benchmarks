%% Copyright 2013 The MathWorks, Inc.
% Read input image
I = imread('visionteam.jpg');
figure,imshow(I);

%% Detect upright people
peopleDetector = vision.PeopleDetector;
[bboxes, scores] = step(peopleDetector,I);
I_people = insertObjectAnnotation(I,'rectangle',bboxes,scores);
figure, imshow(I_people);

%% Try the other model
peopleDetector = vision.PeopleDetector('ClassificationModel','UprightPeople_128x64');
peopleDetector.WindowStride = [4 4];
peopleDetector.MinSize = [256 128];
[bboxes, scores] = step(peopleDetector,I);
I_people = insertObjectAnnotation(I,'rectangle',bboxes,scores);
figure, imshow(I_people);

%% Use PeopleDetector with video
peopleDetector = vision.PeopleDetector;
video = vision.VideoFileReader('viptrain.avi');
viewer = vision.VideoPlayer;
while ~isDone(video)
    image = step(video);
    [bboxes, scores] = step(peopleDetector,image);
    I_people = insertObjectAnnotation(image,'rectangle',bboxes,scores);
    step(viewer,I_people);
end

%% Detect Faces in the image
% Create a detector object
faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');   

% Detect faces
bbox = step(faceDetector, I); 

% Draw boxes around detected faces and display results              
shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[255 255 0]);
I_faces = step(shapeInserter, I, int32(bbox));
imshow(I_faces);

%% Use new object annotation function              
I_faces = insertObjectAnnotation(I,'rectangle',bbox,[1:size(bbox,1)]);
imshow(I_faces);

%% Detect Upper Bodies in the image
% Create a detector object 
bodyDetector = vision.CascadeObjectDetector('UpperBody'); 
bodyDetector.MinSize = [60 60];
bodyDetector.ScaleFactor = 1.05;

bbox_body = step(bodyDetector, I);

% Draw bounding boxes
I_body = insertObjectAnnotation(I,'rectangle',bbox_body,1:size(bbox_body,1));
figure, imshow(I_body);

%% Remove false detections by looking for face
bbox_face = zeros(size(bbox_body));
for i=1:length(bbox_body)
    Icrop = imcrop(I,bbox_body(i,:));
    bbox = step(faceDetector,Icrop);
    if ~isempty(bbox)
        bbox_face(i,:) = bbox + [bbox_body(i,1:2)-1 0 0];
    end
end
    
I_faces2 = insertObjectAnnotation(I,'rectangle',bbox_face,1:size(bbox_face,1));
figure, imshow(I_faces2);

%% Extract one face to use
Icrop = imcrop(I,bbox_body(1,:));
figure;imshow(Icrop);
bbox = step(faceDetector,Icrop);
hold on;rectangle('Position',bbox,'EdgeColor','y');

%% See how much we can rotate the image with the face still being detected
x = 10;
Irotate = imrotate(Icrop,x);
imshow(Irotate);
bbox = step(faceDetector, Irotate);
if bbox > 0
    hold on;rectangle('Position',bbox,'EdgeColor','y'); hold off;
end

