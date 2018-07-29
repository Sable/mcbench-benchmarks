function [im]=mrgb2gray(im,met)
% MRGB2GRAY - convert RGB images to grayscale
%
% im = mrgb2gray(M,met);
%
% M - image matrix or filename. The size of the image should be
% MxNx3 when it is loaded by imread.
%
% MET - method for conversion. Should be one of
%
%       'default'   - uses a weight of [0.3 0.59 0.11] for the R, G and
%                     B respectively
%       'max'       - uses the maximum value of the R, G or B for
%                     each pixel
%       'mean'      - uses the mean of the RGB for each pixel. This
%                     corresponds to using a weight of 
%                     [0.33 0.33 0.33] 
%       'median'    - as above except it uses the median value
%       'min'       - as above except it uses the minimum value
%       'desat'     - computes (max(R,G,B)+min(R,G,B))/2 for each
%                     pixel. This produces a lower contrast image.
%
% MET can also be a 1x3 array with weights. 
%
% examples: 
%           im=mrgb2gray(im,'max');
%           im=mrgb2gray(im); 
%           im=mrgb2gray(im,[0.3 0.5 0.2]); 
%           im=mrgb2gray('filename.jpg');
%           im=mrgb2gray('filename.jpg',[0.25 0.60 0.15]);
%           im=mrgb2gray('filename.jpg','desat');
%
% See also: rgb2gray, isrgb, misrgb
%

% version 0.22 - bug fix: under 'mean' changed occurence of 'min' to 'mean'
% version 0.21 - cleanup of code
% 24.08.2006
%
% version 0.2 - first released version
% J.K.Sveen@damtp.cam.ac.uk, 2004, August 27.
% Distributed under the terms of the GNU GPL:
% http://www.gnu.org/copyleft/gpl.html

if nargin==1
  met='default';
end

if ischar(im)
  im=imread(im);
end

[sx,sy,sz]=size(im);

if sz~=3
  disp('Error. This image is not RGB. Aborting.'); return
end

wasuint=isa(im,'uint8');
im=double(im);
if ~ischar(met)
  T=met(:);
  im=reshape(im,sx*sy,sz); %put image in an M*N by 3 array
  im=im*T; % multiply the weights
  im=reshape(im,sx,sy); % reshape the image back to correct size
else
  switch lower(met)
   case {'default','gimp','standard'}
    
    T=[0.3 0.59 0.11]'; % weights for the individual colors. These are
			% apparently the same weights as used in GIMP: 
			%
			% http://gimp-savvy.com/BOOK/index.html?node54.html

    im=reshape(im,sx*sy,sz); %put image in an M*N by 3 array
    im=im*T; % multiply the weights, 0.3*R, 0.59*G, 0.11*B
    im=reshape(im,sx,sy); % reshape the image back to correct size	
   case {'max','Max'}
    im=reshape(im,sx*sy,sz); %put image in an M*N by 3 array
    im=max(im,[],2); %rotate image and take mean of all columns, then
                  %rotate back. We now have an M*N by 1 array
    im=reshape(im,sx,sy); % reshape the image back to size M by N
   case {'mean','average'}
    im=reshape(im,sx*sy,sz); %put image in an M*N by 3 array
    im=mean(im,2);
    im=reshape(im,sx,sy); % reshape the image back to correct size  
   case {'median'}
    im=reshape(im,sx*sy,sz); %put image in an M*N by 3 array
    im=median(im,2);
    im=reshape(im,sx,sy); % reshape the image back to correct size   
   case {'min'}
    im=reshape(im,sx*sy,sz); %put image in an M*N by 3 array
    im=min(im,[],2); 
    im=reshape(im,sx,sy); % reshape the image back to correct size   
   case {'desat','desaturate'}
    im=reshape(im,sx*sy,sz); %put image in an M*N by 3 array
    im=(max(im,[],2) + min(im,[],2))/2;
    im=reshape(im,sx,sy); % reshape the image back to correct size       
   otherwise 
    disp('Unknown method. Check your input.'); return
  end
end

if wasuint % change back to uint8 if that was the input
  im=uint8(im);
end
