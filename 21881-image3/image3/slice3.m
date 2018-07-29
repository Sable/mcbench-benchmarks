function h = slice3(vol, I2X, slicedim, sliceidx, handle)
% Display a slice from a volume in 3-D
% h = slice3(vol, I2X, slicedim, sliceidx, handle) 
%
% Vol is either a scalar or RGB volume, e.g. N x M x K or N x M x K x 3.
% I2X is a transformation matrix from volume coordinates to xyz 3-D world
% coordinates, similar to the transform used by image3.
%
%     [x y z 1]' = I2X * [i j k 1]'
%
% slicedim  is 1, 2 or 3 and corresponds to i, j and k.
% sliceidx  the index of the slice along slicedim
% handle    an optional handle to a previous slice to reuse
% h         the handle to the created slice.
%
% Example:
%
% load mri;
% T = [1 0 0 0;0 1 0 0;0 0 2.5 0];
% h1 = slice3(squeeze(D),T,1,64);
% h2 = slice3(squeeze(D),T,2,64);
% h3 = slice3(squeeze(D),T,3,14);
% colormap gray(88);
% view(30,45); axis equal; axis vis3d;
%
% SEE ALSO: image3, imagesc3
%
% Author: Anders Brun, anders@bwh.harvard.edu (2003)
% 

if ndims(vol) == 3         %Scalar mode
elseif ndims(vol) == 4     %RGB mode
else
  error('Only scalar and RGB images supported')
end

% Create the slice
if slicedim == 3 % k
  ij2xyz = I2X(:,[1 2]);
  ij2xyz(:,3) = I2X*[0 0 sliceidx 1]';
  sliceim = squeeze(vol(:,:,sliceidx,:));

elseif slicedim == 2 % j
  ij2xyz = I2X(:,[1 3]);
  ij2xyz(:,3) = I2X*[0 sliceidx 0 1]';
  sliceim = squeeze(vol(:,sliceidx,:,:));

elseif slicedim == 1 % i
  ij2xyz = I2X(:,[2 3]);
  ij2xyz(:,3) = I2X*[sliceidx 0 0 1]';
  sliceim = squeeze(vol(sliceidx,:,:,:));
else
    error('Slicedim should be 1, 2 or 3')
end


if nargin<5 || handle == 0
  h = image3(sliceim,ij2xyz);
else
  h = image3(sliceim,ij2xyz,handle);
end

