%% Character Recognition Example (II):Automating Image Pre-processing

%% Read Image
I = imread('sample.bmp');
imshow(I)

%% Convert to grayscale image
Igray = rgb2gray(I);
imshow(Igray)

%% Convert to binary image
Ibw = im2bw(Igray,graythresh(Igray));
imshow(Ibw)

%% Edge detection
Iedge = edge(uint8(Ibw));
imshow(Iedge)

%% Morphology
% * *Image Dilation*
se = strel('square',2);
Iedge2 = imdilate(Iedge, se); 
imshow(Iedge2);
% * *Image Filling*
Ifill= imfill(Iedge2,'holes');
imshow(Ifill)

%% Blobs analysis
[Ilabel num] = bwlabel(Ifill);
disp(num);
Iprops = regionprops(Ilabel);
Ibox = [Iprops.BoundingBox];
Ibox = reshape(Ibox,[4 50]);
imshow(I)

%% Plot the Object Location
hold on;
for cnt = 1:50
    rectangle('position',Ibox(:,cnt),'edgecolor','r');
end


