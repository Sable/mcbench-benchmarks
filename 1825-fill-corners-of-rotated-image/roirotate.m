function varargout = imregrotate(varargin)
%ROIROTATE Rotate & crop region of interest avoiding 'black corners'.
% 	B = ROIROTATE(A,ROI,ANGLE,METHOD) rotates the region of intererest ROI
% 	found in the image A by ANGLE degrees in a counter-clockwise direction, 
% 	using the specified interpolation method and gives the rotated 
% 	region as output in B cropped out of the original image.
% 	
% 	Usefulness
% 	----------
% 	ROIROTATE was designed to avoid the 'black corners' typical of
%   MATLAB's imrotate function, which are apearing from its behaviour
%   of padding by zeros the space outside the image borders prior to 
%   the rotation. This is possible if the image to be rotated is 
%   part of a bigger image - which is the definition of a 'region 
%   of interest' -, because there is enough information to fill 
%   the corners.
% 	
% 	Description
% 	-----------
% 	Apart of the first entry which is based on the IMCROP syntax, 
% 	all other are identical to the IMROTATE function.
% 	
%   ROI is a four-element vector with the form [xmin ymin width height];
%   these values are specified in spatial coordinates.
% 	
% 	xmin - starting pixel to be cut, x-th of the original image
% 	ymin - same on y-axis
% 	width - number of pixels to be cut minus one (width)
% 	height - same on height
% 	
% 	If you want to point the 5 pixel wide & 7 pixel heigh NW corner 
% 	of an image, replace R with [1,1,4,6].
% 	
%   Because ROI is specified in terms of spatial coordinates,
%   the WIDTH and HEIGHT of ROI do not always correspond exactly
%   with the size of the output image. For example, suppose ROI
%   is [20 20 40 30], using the default spatial coordinate
%   system. The upper left corner of the specified rectangle is
%   the center of the pixel (20,20) and the lower right corner is
%   the center of the pixel (50,60). The resulting output image
%   is 31-by-41, not 30-by-40, because the output image includes
%   all pixels in the input that are completely or partially
%   enclosed by the rectangle.
% 	
%         Note for IMCROP:
%         To cut the NW pixel only:
%             NWcornerPixel = imcrop(I, [1,1,0,0]);
%         
%         To cut the first top stripe of pixels:
%             topStripe = imcrop(I, [1,1,size(I,2)-1,0]);
% 	
% 	METHOD is a string that can have one of these values:
% 	
%        'nearest'  (default) nearest neighbor interpolation
%        'bilinear' bilinear interpolation
%        'bicubic'  bicubic interpolation
% 	
% 	If you omit the METHOD argument, ROIROTATE uses the default
% 	method of 'nearest'.
%
%   To rotate the image clockwise, specify a negative angle.
% 	
% 	Class Support
% 	-------------
% 	The input image can be of class uint8, uint16, or double.
%   The output image is of the same class as the input image.
% 	
% 	Example
% 	-------
%        I = imread('circuit.tif');
%        J = imrotate(imcrop(I,[60 80 100 90]),-21,'bilinear','crop');
%        [K x y w h] = roirotate(I,[60 80 100 90],-21,'bilinear');
%        figure, subplot(1,3,1), imshow(I), title('roi')
%        rectangle('Position',[60 80 100 90],'EdgeColor','red');
%        rectangle('Position',[x y w h],'EdgeColor','green');
%        subplot(1,3,2), imshow(J), title('imrotate')
%        subplot(1,3,3), imshow(K), title('roirotate')
%
% 	See also IMROTATE, IMCROP, IMRESIZE, IMTRANSFORM, TFORMARRAY.

%   Vlad Atanasiu - 06/05/2002
%   Revisions: 3  > 01/11/2008



% check image input data
[A,dim,x,y,width,height,ang,method] = parseInputs(varargin{:});

% calculate padding borders
padX = abs(ceil(height*sin(ang*pi/180)/2));
padY = abs(ceil(width*sin(ang*pi/180)/2));

% padding zeros if extended region of interest coordinates outside image
if x-padX < 1   % left
    A = [zeros(size(A,1),padX-x+1,dim) A];
end
if y-padY < 1   % top
    A = [zeros(padY-y+1,size(A,2),dim);...
            A];
end
if x+width+padX > size(A,2)   % right
    A = [A zeros(size(A,1),x+width+padX-size(A,2),dim)];
end
if y+height+padY > size(A,1)   % bottom
    A = [A;...
            zeros(y+height+padY-size(A,1),size(A,2),dim)];
end

% cut extended region
ROI = imcrop(A,[x-padX y-padY width+padX*2 height+padY*2]);

% rotate extended region
ROI = imrotate(ROI,ang,method,'crop');

% cut region
varargout{1} = imcrop(ROI,[padX padY width height]);

% gives extended region coordinates
if nargout == 5
    varargout{2} = x-padX;
    varargout{3} = y-padY;
    varargout{4} = width+padX*2;
    varargout{5} = height+padY*2;
end


% ------------------------------------------------

function [A,dim,x,y,width,height,ang,method] = parseInputs(varargin)
% Input checkings

% Defaults
method = 'n';

% Check number of input parameters
error(nargchk(3,4,nargin));
switch nargin
case 3,             % regrotate(A,reg,ang,)
    A = varargin{1};
	x = varargin{2}(1);
	y = varargin{2}(2);
	width = varargin{2}(3);
	height = varargin{2}(4);
    ang = varargin{3};
case 4,             % regrotate(A,reg,ang,method) 
    A = varargin{1};
	x = varargin{2}(1);
	y = varargin{2}(2);
	width = varargin{2}(3);
	height = varargin{2}(4);
    ang = varargin{3};
    method = varargin{4};
otherwise,
    error('Invalid number of input arguments.');
end

% Check validity of the input parameters 
if ischar(method),
    strings = {'nearest','bilinear','bicubic'};
    idx = strmatch(lower(method),strings);
    if isempty(idx),
        error(sprintf('Unknown interpolation method: %s',method));
    elseif length(idx)>1,
        error(sprintf('Ambiguous interpolation method: %s',method));
    else
        method = strings{idx};
    end  
else
    error('Interpolation method have to be a string.');  
end

if size(varargin{2},2) ~= 4
    error('Region of interest should be defined by 4 arguments.');  
end

% transforms the format of A into an image if it is a filename
if (isstr(A))
    A = imread(A);
end

% gets the dimensions of A
dim = ndims(A);
if dim == 2, dim=1; end

% modifies if needed the region of interest coordinates if outside image
if x < 1, x = 1; end
if y < 1, y = 1; end
if x > size(A,2)-1, x = size(A,2)-1; end
if y > size(A,1)-1, y = size(A,1)-1; end
if x+width > size(A,2)-1, width = size(A,2)-x-1; end
if y+height > size(A,1)-1, height = size(A,1)-y-1; end


