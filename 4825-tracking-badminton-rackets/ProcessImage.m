function Proc = ProcessImage(strImageName,tolerance,imgObjectR,imgObjectG,imgObjectB,imageCount)
% **********************************************************************************
% *
% * ProcessImage(strImageName,tolerance,imgObjectR,imgObjectG,imgObjectB)
% * 
% * strImageName    = name of the initial image in the sequence
% * tolerance       = variation from the given referance colors 
% * imgObjectR      = red referance color
% * imgObjectG      = green referance color
% * imgObjectB      = blue referance color
% * imageCount      = number of images in the sequence


% * This Program can identify a badminton racket from a sequence of images. Initial image name, 
% * reference color and a tolerance to reference color values are given. It is assumed that the 
% * racket is of the reference color. Images must be in the same folder and they should be named like 
% * image1, image2, .. image39, image40 etc. The program then track the racket and pant it with red.
% *
% * Usage
% * >> ProcessImage('image1.bmp',39,255,255,255,40)
% * to track 40 images starting from image1.bmp tolerance is 39 tracking
% * color is white RGB (255,255,255)
% * 
% * 
% *
% *     Author - I. Janaka Prasad Wijesena
% *     
% **********************************************************************************

% is the image name properly given
if ~ischar(strImageName)
    Proc='ERROR using ProcessImage: strImageName must be a string !!!';
    return, 
end

% is the tolerance properly given
if ~isnumeric(tolerance)
    Proc='ERROR using ProcessImage: tolerance must be a integer !!!';
    return,         
end

if ~isnumeric(imgObjectR) || ~isnumeric(imgObjectG) || ~isnumeric(imgObjectB)
    Proc='ERROR using ProcessImage: RGB values not given properly';
    return,         
end

if ~isnumeric(imageCount)
    Proc='ERROR using ProcessImage: image count must be a integer !!!';
    return,         
end

% read the image to imgOriginal
imgOriginalRGB = imread(strImageName);

% convert to YCbCr Color Space since we are dealing with video streams ...
%imgOriginalYCBCR = rgb2ycbcr(imgOriginalRGB);

% ok now show it
%figure, imshow(imgOriginalRGB) , title('Original Image');

% now construct RGB matrices from the image
imgOriginalR = double(imgOriginalRGB(:,:,1));
imgOriginalG = double(imgOriginalRGB(:,:,2));
imgOriginalB = double(imgOriginalRGB(:,:,3));

% size of the image ...
imageSize = size(imgOriginalR);

diffRVal = abs(minus(imgOriginalR,imgObjectR));
diffGVal = abs(minus(imgOriginalG,imgObjectG));
diffBVal = abs(minus(imgOriginalB,imgObjectB));

newImage = (diffRVal<tolerance) & (diffGVal<tolerance) & (diffBVal<tolerance);

%figure, imshow(newImage), title('Detected Objects');

% remove hole in the image 
holeRemovedImage = imfill(newImage, 'holes');

% show that image 
%figure, imshow(holeRemovedImage), title('Holes Removed');

% Determine the Number of Objects in the Image
% page 47 of vision book has the algorithm we shall use it in C++ program
[labeled,numObjects] = bwlabel(holeRemovedImage,8);% Label components.


%figure, imshow(labeled) , title('Labeled Image');


itemHolder = 1:numObjects; % this will hold the items found

retID = -1;

% now we are going to travel the image
for i = 1:numObjects
   
    outPut = ImagePropertiesInitial(i,labeled);
    
    retID = outPut(1);
    
    
    if retID > 0 
        break;    
    end
end


topY            = outPut(6);
bottomY         = outPut(7);
leftX           = outPut(8);
rightX          = outPut(9);

originalMajor   = outPut(3);
originalMinor   = outPut(4);


boundPad        = 20;


% rate of change
rateTopY        = 0;
rateBottomY     = 0;
rateLeftX       = 0;
rateRightX      = 0;

% bounds
% ********* please note ALL bounds must be > 0
boundTopY       = topY - boundPad;
boundBottomY    = bottomY + boundPad;
boundLeftX      = leftX - boundPad;
boundRightX     = rightX + boundPad;



% now create bat only image
for imageCount = 2:imageCount
    
    % load the next image
    img = imread(['image',int2str(imageCount),'.bmp']);  
    
    % show it if you must ...
    %figure, imshow(img) , title(int2str(imageCount));
    
    %--------------------------------------------------------------------------------------------------------------
        
    % now construct RGB matrices from the image
    imgOriginalR = double(img(:,:,1));
    imgOriginalG = double(img(:,:,2));
    imgOriginalB = double(img(:,:,3));


    diffRVal = abs(minus(imgOriginalR,imgObjectR));
    diffGVal = abs(minus(imgOriginalG,imgObjectG));
    diffBVal = abs(minus(imgOriginalB,imgObjectB));

    newImage = (diffRVal<tolerance) & (diffGVal<tolerance) & (diffBVal<tolerance);   

      
    extractedImage = newImage(boundTopY:boundBottomY,boundLeftX:boundRightX);
    
    % show it 
    %figure, imshow(extractedImage) , title(int2str(imageCount));
    
    [labeled,numObjects] = bwlabel(extractedImage,8);% Label components.
    
    % size of the image ...
    imageSize = size(labeled);
    
    %--------------------------------------------------------------------------------------------------------------
    
    
    itemHolder = 1:numObjects; % this will hold the items found

    retID = -1;

    % now we are going to travel the image
    for i = 1:numObjects
   
        outPut = ImageProperties(i,labeled);
    
        retID = outPut(1);
    
        if retID > 0 
            break;    
        end
    end
    
    % ok. we now have the bat... now we must use the results for adujest
    % the bounding rect

    if retID > 0

        
        % now create bat only image
        for m = 1:imageSize(1)
            for n = 1:imageSize(2)
                if labeled(m,n) == retID                
                    img(m+boundTopY,n+boundLeftX,1) = 255;                    
                    img(m+boundTopY,n+boundLeftX,2) = 0;                    
                    img(m+boundTopY,n+boundLeftX,3) = 0;                    
                end
            end
        end         
        
        newTopY         = boundTopY + outPut(6);
        newBottomY      = boundTopY + outPut(7);
        newLeftX        = boundLeftX + outPut(8);
        newRightX       = boundLeftX + outPut(9);

           newTopY        
        newBottomY      
        newLeftX       
        newRightX       
        
        % rate of change
        rateTopY        = newTopY - topY;
        rateBottomY     = newBottomY - bottomY;
        rateLeftX       = newLeftX - leftX;
        rateRightX      = newRightX - rightX;

        
        
        topY            = newTopY;
        bottomY         = newBottomY;
        leftX           = newLeftX;
        rightX          = newRightX;

        boundTopY       = topY - boundPad + rateTopY;
        boundBottomY    = bottomY + boundPad + rateBottomY;
        boundLeftX      = leftX - boundPad + rateLeftX;
        boundRightX     = rightX + boundPad + rateRightX;        
        
        
        figure, imshow(img) , title(int2str(imageCount));
        
    end
    
    
    %--------------------------------------------------------------------------------------------------------------
    
end




