function fusedImg= imagesFusion(imgCell, varargin)
%% imagesFusion
% Combine/Fuse/Mix images together with user defined weighting/opasity.
%
%% Syntax
% imagesFusion({img_1, img_2, img_3,... }); % user will be prompted for mask definition
% imagesFusion({img_1, img_2, img_3,... }, {mask_1, mask_2, mask_3,...});
%
%% Description
% This is a small function designed to fuse/blend images together. We have found it to be
%  handy in several cases- both for images and videos (see Example III for videos fusion).
%  It can be used for comparing several image processing methods, applied to an image.
%  While image processing algorithms are frequently evaluated by comparing resulting
%  images side  by side, via concatenation or subplot it results in large images. The
%  proposed function allows presenting several methods, each applied to a user defined
%  region of the image,  so several methods are evaluated on a single image. This is
%  expected to be even better for videos, where camera motion will result in scene
%  migrations between areas. We have found this function to be useful in generation of
%  test images for segmentation algorithms evaluation. Several texture images were
%  combined in a mosaic, subject to further segmentation. This function can be used for
%  combinations of different images, though we believe imagesMixture to be a more
%  appropriate function for this task. While having only a few inputs parameters, the
%  function allows the user to control the region of each image, and the inter-image
%  opacities, so both soft and sharp margins are possible.
%
%% Input arguments (defaults exist):
% imgCell-    a cell array of images, subject t blending. The images should be of same
%    dimentions (height, wifth and number of colors) and class. If images size and class
%    vary, all will be comnverted to maximal image dimanetions prior tp blending. This may
%    result in image impairment...
%
% The following inputs must be specified by a "inputName"- "inputValue" pairs.
%
% isDrawnMasks- a logicla flag enabling the generation of blendMatrixCell via user drawing
%    each missing region.
% blendMatrixCell- a cell array of blending matrixes. As in case of images, blending
%    matrixes are expected to be of same dimentions, though different cases are taken care
%    of. The matrixes values should be floating type with values [0:1]. Basing on those
%    values, new image will be blended into curren mosaic. By using value between 0 and 1
%    user can achieve soft meargins and varying image blendings. It is assumed that the
%    first image will be fully integarted into the mosaic (to avoid empty spots), though
%    this rule can be override, by explicit declaration of fisrt blendMatrixCell element.
%    In case of missing blending matrixes, an automated mask will be generated, or user
%    will be prompted to draw a mask, while previous mask will be presented for his
%    convinince. It is expected that the number of blendMatrixCell elements will be same
%    as number of input images or one less. In the later case, first image will be fully
%    utilised (it's blending matrix will be all ones).
% isDrawLine- a logical varibale drawing a line on regions bordres when enabled (true).
% lineWidth- the width (in pixels) of the line drawn when 'isDrawLine' is enabled.
%
%% Output arguments
%   fusedImg- a resuting image of same type as MAJORITY of inputa images, and of
%     dimentions of maximal image, incorpoating all input images (imgCell), blended
%     accourding to the blendMatrixCell.
%
%% Issues & Comments
% Get 'mask2poly' function (http://www.mathworks.com/matlabcentral/fileexchange/32112-mask2poly)
% and 'addMarkerLines2Img' function (http://www.mathworks.com/matlabcentral/fileexchange/37427-plot-on-an-image-addmarkerlines2img)
% to use 'isDrawLine' mode.
%
%% Example I
% img1=imread('peppers.png');
% img2=imread('cameraman.tif');
%
% fusedImg= imagesFusion({img1, img2});
% figure;
% imshow(fusedImg);
% title('Fusion based on a predefined mask');
%
% mask1=false( size(img1, 1), size(img1, 2) );
% mask1(:, round(size(img1, 2)/2):end )=true;
% softFilt=ones(1,25);
% softFilt=softFilt/sum(softFilt(:));
% maskSoftEdge=imfilter(double(mask1), softFilt, 'same', 'symmetric');
% fusedImg= imagesFusion({img1, img2}, 'blendMatrixCell', {maskSoftEdge});
% figure;
% imshow(fusedImg);
% title('Fusion based on a predefined mask with SOFT edges');
%
%% Example II
% img=imread('peppers.png');
%
% H = fspecial('disk', 20);
% blurred = imfilter(img, H, 'replicate');
%
% noisy = imnoise(img,'gaussian', 0, 0.005);
%
% fusedImg= imagesFusion({img, blurred, noisy}, 'isDrawnMasks', true,...
%  'isDrawLine', true, 'lineWidth', 2);
% figure;
% imshow(fusedImg);
% title('Fusion of "peppers" image [original, blurred, noised]');
%
%% Example III (fusion application to Videos)
% % note apply2VideoFrames must be avalible
% % ( http://www.mathworks.com/matlabcentral/fileexchange/32351-apply2videoframes )
% % no other input video files in Matlab default path was found
% matlabVfile1='rhinos.avi';
% matlabVfile2='xylophone.mpg';
% % generated via drawBlenMaskCellArray, and added to this contribution
% load('myMask.mat'); 
% % Use drawBlenMaskCellArray to generate ROI's applied to multiple images/videos
% outVideoFileFuse12=apply2VideoFrames('inVideo', {matlabVfile2, matlabVfile1},...
%    'isSaveAllFrames', false, 'hAppliedFunc', @imagesFusion, 'isCellInput', true,...
%    'PARAMS', 'blendMatrixCell', blendMaskCell);
% implay(outVideoFileFuse12);
%
%% See also
% - subplot
% - imagesMixture    % an alternative way to combine images
%    http://www.mathworks.com/matlabcentral/fileexchange/36749-images-blendingmixturephotomontage
% - concatVideo2D    % an alternatove way to compare videos
%    http://www.mathworks.com/matlabcentral/fileexchange/33951-concatenate-video-files-subplot-style
%
%% Revision history
% First version: Nikolay S. 2012-07-08.
% Last update:   Nikolay S. 2012-07-04.
%
% *List of Changes:*
% 2012-07-09
% - isDrawLine added- to enables lines drawing around regions.
% 2012-07-08
% - An automated mask generation sub function added.
% - Video example added.
%

%% Default variables
isDrawLine=false;
isDrawnMasks=false;
blendMatrixCell=[];
lineWidth=1;

%% Load uses params, overifding default ones
if nargin>1
   for iArg=1:2:length(varargin) % automatically get all input pairs and store in local vairables
      assignin_value(varargin{iArg}, varargin{iArg+1});
   end
end

%% local params
calcClass='double'; % numeric class used thorugth caculations/filtering etc...
% Can be replced by single, float32 etc, to improve speed
lineClr={'r', 'g', 'b', 'm', 'c', 'k', 'y'}; % colors for plotting lines around regions

%% Investigate inputs- dimentions and classes

imgH = cellfun('size', imgCell, 1);
imgW = cellfun('size', imgCell, 2);
imgClr = cellfun('size', imgCell, 3);
maxH=max(imgH);
maxW=max(imgW);
maxClr=max(imgClr);

%% find majority images class, to define output image class
imgClasses=cellfun(@class, imgCell, 'UniformOutput', false);
currTypes=unique(imgClasses);
classCount=0;
for iType=1:length(currTypes)
   currClassCount=sum(strcmpi(imgClasses, currTypes{iType}));
   if currClassCount>classCount
      classCount=currClassCount;
      commonClass=currTypes{iType};
   end
end

%% Take care of blendMatrixCell elements
nImages=length(imgCell);
if isempty(blendMatrixCell)
   if ~isDrawnMasks
      blendMatrixCell=generateBlenMasks(nImages, [maxH, maxW]);
   else
      blendMatrixCell={[]};
   end
end

nBlenMat=length(blendMatrixCell);
if nImages > nBlenMat % append with all ones blending- for the first image
   blendMatrixCell=cat(1, ones([maxH, maxW], calcClass), blendMatrixCell);
   nBlenMat=nBlenMat+1;
   if nImages > nBlenMat % if appending was not enougth, add empty cells
      tmpBlendMatrixCell=blendMatrixCell;
      blendMatrixCell=cell(1, nImages);
      blendMatrixCell(1:nBlenMat)=tmpBlendMatrixCell;
   end
   
   fusedImg=cast(imresize(imgCell{1}, [maxH, maxW]), calcClass); % init fusedImg with first image
   if size(fusedImg, 3)~=maxClr
      fusedImg=repmat(fusedImg, [1, 1, maxClr]);
   end
   iStartImg=2;
else
   fusedImg=zeros(maxH, maxW, maxClr, calcClass); % init fusedImg with zeros
   iStartImg=1;
end


for iImg=iStartImg:nImages
   % go thotugh all input images and blendign matrixes. Reshape is needed, and combine
   % together.
   %% bring blendMatrixCell elements to common size and type
   currBlendMat=blendMatrixCell{iImg};
   currBlendMat=min(currBlendMat, 1);
   currBlendMat=max(currBlendMat, 0);
   if isempty(currBlendMat) % if an empty mask are detected- fill the gap!
      currBlendMat=drawBlenMask(blendMatrixCell(1:(iImg-1)),[maxH, maxW]); 
      blendMatrixCell{iImg}=currBlendMat; % store to present during next drawings
   end
   if size(currBlendMat, 1)~=maxH || size(currBlendMat, 2)~=maxW
      % blend matrix must have appropriate dimentions (height width)
      currBlendMat=imresize(currBlendMat, [maxH, maxW], 'nearest');
   end
   if size(currBlendMat, 3)~=maxClr
      % blend matrix must have appropriate number of color dimentions
      currBlendMat=repmat(currBlendMat, [1, 1, maxClr]);
   end
   if ~strcmpi(class(currBlendMat), calcClass) % Convert blend matrix to float
      currBlendMat=cast(currBlendMat, calcClass);
   end
   
   %% bring imgCell images to common size and type
   currImg=imgCell{iImg};
   if size(currImg, 1)~=maxH || size(currImg, 2)~=maxW
      currImg=imresize(currImg, [maxH, maxW]); % resize image if needed
   end
   if size(currImg, 3)~=maxClr
      currImg=repmat(currImg, [1, 1, maxClr]); % convert to RGB if needed
   end
   if ~strcmpi(class(currImg), calcClass) % Convert blend matrix to float, if non-float
      currImg=cast(currImg, calcClass);
   end
   %
   %Fuse current image, using current blend matrix
   fusedImg=(1-currBlendMat).*fusedImg + currBlendMat.*currImg;
   if isDrawLine
      if exist('mask2poly', 'file')~=2
         warning('To use ''isDrawLine'' mode add mask2poly to Matlab path.');
      end
      if exist('addMarkerLines2Img', 'file')~=2
         warning('To use ''isDrawLine'' mode add addMarkerLines2Img to Matlab path.');
      end
      
      if exist('mask2poly', 'file')==2 && exist('addMarkerLines2Img', 'file')==2
         lineTraj=mask2poly(currBlendMat(:,:,1)>0, 'Inner', 'None');
         lineTraj=fliplr(lineTraj); % X-Y Cols-Raws issue
         fusedImg=addMarkerLines2Img( fusedImg, lineTraj , lineWidth,...
            lineClr{1+mod( iImg, length(lineClr) )} );
      end % if isDrawLine
   end % if isDrawLine
end % for iImg=iStartImg:nImages

% cast resulting image to class presnt in majotiry of input images
if ~strcmpi(commonClass, calcClass)
   fusedImg=cast(fusedImg, commonClass);
end


%% Servise functions

function currBlendMask=drawBlenMask(blendMaskCell, maskDim)
% generate user defined masks
nBlendMask=length(blendMaskCell);
prevMaskMat=zeros(maskDim, 'uint8');

for iMask=1:nBlendMask
   prevMaskMat(blendMaskCell{iMask}>0)=iMask;
end

figH=figure;
imshow(prevMaskMat, []);
% title({'Select ROI by left clicking mouse and moving the pointer around.',...
%    'Release to finish.'},...
%    'FontSize', 18, 'Color', [1,0,0]);
text(0.5, 0.9, {'Select ROI by left clicking mouse', 'and moving the pointer around.',...
   'Release to finish.'}, 'FontSize', 16, 'Color', [1,0,0],...
   'HorizontalAlignment', 'center', 'Units', 'normalized');

imfreehandH=imfreehand;
currBlendMask=createMask(imfreehandH);
delete(imfreehandH);
close(figH);

function blendMatrixCell=generateBlenMasks(nMasks, maskSize)
% generated automated mask- diivde image into "Pie" style slices.
x=linspace(-1, 1, maskSize(1));
y=linspace(-1, 1, maskSize(2));
[X,Y] = meshgrid(x,y);
Theta=mod(180+90+atan2(Y, X)/pi*180, 360); % make Y axis direction=0°,
% convert all values to be 0:360, and begin from left side
slsieRes=360/nMasks;
blendMatrixCell=cell(1, nMasks);
% maskMat=zeros(maskSize);
for iSlise=1:nMasks
   blendMatrixCell{iSlise}=Theta>(iSlise-1)*slsieRes & Theta<=iSlise*slsieRes;
   %    maskMat(blendMatrixCell{iSlise})=iSlise;
end

% figure;
% imshow(maskMat, []);