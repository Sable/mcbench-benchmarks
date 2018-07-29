function [img_lut] = imlut(img, lut, kind, order)
%IMLUT - applies 1D or 3D LUT (color lookup table) to image
%
% Syntax:  [img_lut] = imlut(img,lut,kind,order)
%
% Inputs:
%    img - the image on which the lut shall be applied, format double,
%            uint8 or uint16
%    lut - the color lookup table (either 1D or 3D)
%    kind - a string '1D' or '3D' specifying whether a 1D LUT or 3D LUT is
%           used
%    order - order of LUT entries. We differentiate between 'standard'
%           (default) and 'inverse' order. Examples:
%            Standard Order         Inverse Order
%                R G B                   R G B
%                0 0 0                   0 0 0
%                1 0 0                   0 0 1
%                2 0 0                   0 0 2
%                0 1 0                   0 1 0
%                1 1 0                   0 1 1
%                2 1 0                   0 1 2
%                0 2 0                   0 2 0
%                 ...                     ...
%                2 2 2                   2 2 2
%
% Outputs:
%    img_lut - image after colors are changed according to LUT,
%              format double, uint8 or uint16 depending on LUT values
%
% Example: 
%    img = imread('path_to_image');
%    lut = dlmread('path_to_lut.cube', ' ', 4, 0);
%    [img_lut] = imlut(img, lut, '3D', 'standard')
%    imshow(img_lut)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: dlmread,  imread

% Author: Christopher Haccius
% Telecommunications Lab, Saarland University, Germany
% email: haccius@nt.uni-saarland.de
% August 2013; Last revision: 09-August-2013

img = im2double(img);       % convert input image to double precision

[m,n,o] = size(img);        % get size of input image
img_lut = zeros(m,n,o);     % asign output image

[g,~] = size(lut);          % get length of lut

if strcmp(order,'inverse')  % set order of 3D LUT cube
    o = [1 2 3 2 1 3 2 1 3];% for reordering to 'inverse'
else                        % or 'standard' LUT order
    o = [2 3 1 2 1 3 2 3 1];
end


% if 1D LUT is used for color lookup
if strcmp(kind,'1D')
    a = linspace(0,1,g);% create 1D scale size of color LUT
    img_lut(:,:,1) = interp1(a,lut(:,1),img(:,:,1));
                        % interpolate red component
    img_lut(:,:,2) = interp1(a,lut(:,2),img(:,:,2));
                        % interpolate green component
    img_lut(:,:,3) = interp1(a,lut(:,3),img(:,:,3));
                        % interpolate blue component
    
% if 3D LUT is used for color lookup
elseif strcmp(kind,'3D')
    d = uint8(g^(1/3));             % calculate size of color cube
    
    [a,b,c] = meshgrid(linspace(0,1,d));
                                    % create 3D grid size of color cube
    
    lutR = reshape(lut(:,1),d,d,d); % reshape red component of lut for 3D
    lutR = permute(lutR,[o(1) o(2) o(3)]);
                              % permute cube dimensions according to order
    lutG = reshape(lut(:,2),d,d,d); % respape green component of lut for 3D
    lutG = permute(lutG,[o(4) o(5) o(6)]);
                              % permute cube dimensions according to order
    lutB = reshape(lut(:,3),d,d,d); % reshape blue component of lut for 3D
    lutB = permute(lutB,[o(7) o(8) o(9)]);
                              % permute cube dimensions according to order

    img_lut(:,:,1) = interp3(a,b,c,lutB, ...
            img(:,:,1),img(:,:,2),img(:,:,3)); % interpolate red comp
    img_lut(:,:,2) = interp3(a,b,c,lutG, ...
            img(:,:,1),img(:,:,2),img(:,:,3)); % interpolate green comp
    img_lut(:,:,3) = interp3(a,b,c,lutR, ...
            img(:,:,1),img(:,:,2),img(:,:,3)); % interpolate blue comp
    
% if neither 1D nor 3D given, display warning and return input image
else
    disp('Warning: Only 1D or 3D is allowed as LUT option!');
    disp('Original image is returned.');
    img_lut = img;  % return unchanged image
end

if max(max(max(img_lut)))>255       % if new image is of type uint16
    img_lut = uint16(img_lut);      % convert type to uint16
elseif max(max(max(img_lut)))>1     % if new image is of type uint8
    img_lut = uint8(img_lut);       % convert type to uint8
end