function [imgw, imgwr, map] = interp2d(X, Y, img, Xwr, Ywr, outH, outW, interp)
% Description:
% Interpolation of the warped grid using nearest neighbor and inverse
% distance weighted interpolation
%
% Inputs:
% X,Y - mesh grid of input image
% Xwr, Ywr - warped grid
% img - input image
% outH, outW - output warped image dimensions
% interp.method - interpolation mode('nearest', 'invdist', 'none')
% interp.radius - Max radius for nearest neighbor interpolation or
%                 Radius of inverse weighted interpolation
% interp.power - power for inverse weighted interpolation
%
% Output:
% imgw - interpolated image (warp+interpolate)
% imgwr - warped image with holes
% map - Map of the canvas with 0 indicating holes and 1 indicating pixel
%
% Author: Fitzgerald J Archibald
% Date: 23-Apr-09

%% initialization
color = size(img,3);
imgwr=zeros(outH,outW,color); % output image
% window dimension for filling
maxhw = fix((interp.radius-1)/2);
% input image params
color = size(img,3);
imgH  = size(img,1);
imgW  = size(img,2);

%% Round warping coordinates
% rounding warped coordinates
Xwi = round(Xwr);
Ywi = round(Ywr);

% Bound warped coordinates to image frame
Xwi = max(min(Xwi,outH),1);
Ywi = max(min(Ywi,outW),1);

% Convert 2D coordinates into 1D indices
fiw = sub2ind([outH,outW],Xwi,Ywi); % warped coordinates
fip = sub2ind([imgH,imgW],X,Y); % input

%% Warped image construction with holes
% Note: This mapping doesn't treat 2 or more points (from source image)
%     mapping to same point (on warped image) differently than 1-1 mapping.
o_r=zeros(outH,outW);
for colIx = 1:color,
    img_r=img(:,:,colIx);
    o_r(fiw)=img_r(fip);
    imgwr(:,:,colIx)=o_r;
end


%% Filling of holes

% Create a binary image with 0s for holes and 1s for mappings
map=zeros(outH,outW);
map(fiw)=1;

% Fill holes
if strcmp(interp.method,'nearest') % Median of nearest neigbor filling
    imgw = nearestInterp(imgwr, map, maxhw); % fill

elseif strcmp(interp.method,'invdist')% inverse distance weighted interpolation
    imgw = idwMvInterp(imgwr, map, maxhw, interp.power); % fill
else
    imgw = imgwr;
end

return;

