%% Copyright 2012 The MathWorks, Inc.
% Create a detector object
faceDetector = vision.CascadeObjectDetector;   

% Read input image
I = imread('visionteam.jpg');

% Detect faces
bbox = step(faceDetector, I); 

% Create a shape inserter object to draw bounding boxes around detections
shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[255 255 0]); 

% Draw boxes around detected faces and display results              
I_faces = step(shapeInserter, I, int32(bbox));    
figure, imshow(I_faces), title('Detected faces');  
%%
% Create a detector object 
bodyDetector = vision.CascadeObjectDetector('UpperBody'); 
bodyDetector.MinSize = [60 60];
bodyDetector.ScaleFactor = 1.05;

% Read input image and detect upper body
bbox_body = step(bodyDetector, I);

% Draw bounding boxes
shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[255 255 0]);
I_body = step(shapeInserter, I, int32(bbox_body));
figure, imshow(I_body);
%%
bbox_face = zeros(size(bbox_body));
for i=1:length(bbox_body)
    Icrop = imcrop(I,bbox_body(i,:));
    bbox = step(faceDetector,Icrop);
    bbox_face(i,:) = bbox + [bbox_body(i,1:2)-1 0 0];
end
    
I_faces2 = step(shapeInserter, I, int32(bbox_face));
figure, imshow(I_faces2);
%%
Icrop = imcrop(I,bbox_body(1,:));
figure;imshow(Icrop);
bbox = step(faceDetector,Icrop);
hold on;rectangle('Position',bbox,'EdgeColor','y');
%%
x = 5;
Irotate = imrotate(Icrop,x);
imshow(Irotate);
bbox = step(faceDetector, Irotate);
if bbox > 0
    hold on;rectangle('Position',bbox,'EdgeColor','y'); hold off;
end