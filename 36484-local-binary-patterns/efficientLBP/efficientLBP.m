function LBP= efficientLBP(inImg, filtDims, isEfficent)
%% efficientLBP
% The function implements LBP (Local Binary Pattern analysis).
%
%% Syntax
%  LBP= efficientLBP(inImg);
%
%% Description
% The LBP tests the relation between pixel and it's neighbors, encoding this relation into
% a binary word. This allows detection of patterns/features.
%
%% Input arguments (defaults exist):
%  inImg- input image, a 2D matrix (3D color images will be converted to 2D intensity
%     value images)
%  filtDims- the used filetr dimentions (2D filter is supported). Utilisation on filter
%     other then [3x3] will result in non UINT8 LBP. Both filter dimantions should be odd
%     ( so filter center will be well defined). even dimentions will be converted to odd
%     ones.
%  isEfficent- when enabled (true by default), and efficient, convoution based LBP
%     calculation is performed. When disabled, pixel-wise (non efficient) implementation is
%     used. The later is easier to understand, for those interested in learning the LBP.
%
%% Output arguments
%   LBP-    LBP image UINT8/UINT16/UINT32/UINT64/DOUBLE of same dimentions 
%     [Height x Width] as inImg.
%
%% Issues & Comments
% - Currenlty, all neigbours are treated alike. Basically, we can use wighted/shaped
%     filter.
% - Neighbours are scanned column wise (reguler Matlab way), why it should be scanned
%     clock-wise/counter clock-wise direction. For general neighbrohood we should
%     implement snail ordering, which is currently unavalible...
%
%% Example
% img=imread('peppers.png');
% tic;
% LBP= efficientLBP(img, [2,3]); % note this filter dimentions aren't legete...
% effTime=toc;
% figure;
% subplot(1,2,1)
% imshow(img);
% title('Original image');
% 
% subplot(1,2,2)
% imshow(LBP);
% title('LBP image');
% 
% % verify pixel wise implementation returns same results
% tic;
% pixelWiseLBP=efficientLBP(img, [2,3], false);
% inEffTime=toc;
% fprintf('\nRun time ratio %.2f. Is equal result: %o.\n', inEffTime/effTime,...
%    isequal(LBP, pixelWiseLBP));
%
%% See also
%
%% Revision history
% First version: Nikolay S. 2012-08-27.
% Last update:   Nikolay S. 2012-05-01.
%
% *List of Changes:*
% 2012-08-28 - Neighbours were scanned column wise (regular Matlab way), while they should
%     be scanned clock-wise/counter clock-wise direction. A Helix/Snail indexing funtion
%     was written and added, to deal with this issue.
% 2012-08-27 - Chris Forne comment mentioned some erros found in the code. As I haven't
%  made any use fo the code, for the last few month, I haven't noticed the mentioned
%  issues, so many thanks goes to Chris for his sharp eye. Bugs fixes, and some
%  modification intorduced.
% 2012-05-01 - After writing down the primitove version, a filtering based miplementation
%  was proposed, improving run time by factor of 80-150..
%
if nargin<3
   isEfficent=true;
   if nargin<2
      filtDims=[3,3];
      if nargin==0
         error('Input image matrix/file name is missing.')
      end
   end
end

if ischar(inImg) && exist(inImg, 'file')==2 % In case of file name input- read graphical file
   inImg=imread(inImg);
end

if size(inImg, 3)==3
   inImg=rgb2gray(inImg);
end

inImgType=class(inImg);
isDoubleInput=strcmpi(inImgType, 'double');
if ~isDoubleInput
   inImg=double(inImg);
end
imgSize=size(inImg);

% verifiy filter dimentions are odd, so a middle element always exists
filtDims=filtDims+1-mod(filtDims,2); 

filt=zeros(filtDims, 'double');
nNeigh=numel(filt)-1;

if nNeigh<=8
  outClass='uint8';
elseif nNeigh>8 && nNeigh<=16
   outClass='uint16';
elseif nNeigh>16 && nNeigh<=32
   outClass='uint32';
elseif nNeigh>32 && nNeigh<=64
   outClass='uint64';   
else
   outClass='double';
end

iHelix=snailMatIndex(filtDims);
filtCenter=ceil((nNeigh+1)/2);
iNeight=iHelix(iHelix~=filtCenter);


if isEfficent
   %% Better filtering/concolution based attitude

   filt(filtCenter)=1;
   filt(iNeight(1))=-1;
   sumLBP=zeros(imgSize);
   for i=1:length(iNeight)
      currNieghDiff=filter2(filt, inImg, 'same');
      sumLBP=sumLBP+2^(i-1)*(currNieghDiff>0); % Thanks goes to Chris Forne for the bug fix

      if i<length(iNeight)
         filt( iNeight(i) )=0;
         filt( iNeight(i+1) )=-1;
      end
   end   
   if strcmpi(outClass, 'double')
      LBP=sumLBP;
   else
      LBP=cast(sumLBP, outClass);
   end
else % if isEfficent
   
   %% Primitive pixelwise solution
   filtDimsR=floor(filtDims/2); % Filter Radius
   iNeight(iNeight>filtCenter)=iNeight(iNeight>filtCenter)-1; % update index values.
   
   % Padding image with zeroes, to deal with the edges
   zeroPadRows=zeros(filtDimsR(1), imgSize(2));
   zeroPadCols=zeros(imgSize(1)+2*filtDimsR(1), filtDimsR(2));

   inImg=cat(1, zeroPadRows, inImg, zeroPadRows);
   inImg=cat(2, zeroPadCols, inImg, zeroPadCols);
   imgSize=size(inImg);

   neighMat=true(filtDims);

   neighMat( floor(nNeigh/2)+1 )=false;
   weightVec= (2.^( (1:nNeigh)-1 ));
   LBP=zeros(imgSize, outClass);
   for iRow=( filtDimsR(1)+1 ):( imgSize(1)-filtDimsR(1) )
      for iCol=( filtDimsR(2)+1 ):( imgSize(2)-filtDimsR(2) )
         subImg=inImg(iRow+(-filtDimsR(1):filtDimsR(1)), iCol+(-filtDimsR(2):filtDimsR(2)));
         % find differences between current pixel, and it's neighours
         diffVec=repmat(inImg(iRow, iCol), [nNeigh, 1])-subImg(neighMat);  
         LBP(iRow, iCol)=cast( weightVec*(diffVec(iNeight)>0),  outClass);   % convert to decimal. 
      end % for iCol=(1+filtDimsR(2)):(imgSize(2)-filtDimsR(2))
   end % for iRow=(1+filtDimsR(1)):(imgSize(1)-filtDimsR(1))
   
   % crop the margins resulting from zero padding
   LBP=LBP(( filtDimsR(1)+1 ):( end-filtDimsR(1) ),...
      ( filtDimsR(2)+1 ):( end-filtDimsR(2) ));
end % if isEfficent