function h=imsurf(imageIn,upperLeftPoint3,normal,imXDirVec,scale,varargin)
%function h=imsurf(imageIn,upperLeftPoint3,normal,imXDirVec,scale,varargin)
%Plot an image in a 3d plane. The position and scale of the image are controlled by the input
%parameters.
%
%The plane is defined by its normal direction vector (normal), the coordinate of the upper left hand
%corner of the image in the coordinates of the final plot (upperLeftPoint3) and the direction of the
%positive x direction (imXDirVec).
%
%The normal and the imXDirVec have to be orthogonal, if they aren't orthogonal, the function will
%change the imXDirVec vector to make it orthogonal to the normal, in the plane of the two original
%vectors. If they're parallel or zero, the function will fail to draw the image plane.
%
%The scale is defined by scale. For example a scale of 0.4 will make an
%input image of size 200x100 plot to a surface of size 80x40 in the current
%axes.
%
%The normal is defined as coming out of the screen in usual viewing.
%
%varargin are paramater value pairs suitable for surface
%
%imageIn can be a monochrome MxNx1 matrix, or a full colour MxNx3, or a
%monochrome and alpha MxNx2 matrix, or a full colour and alpha
%(transparency) MxNx4 matrix. Ideally imageIn is a uint8 class matrix,
%using the range of values from 0 to 255 (the alpha part, imageIn(:,:,end),
%also uses the full range of 0 to 255 in this case) or it is a matrix of
%class double, where all elements are in the range 0 to 1. 
%
%Author: M Arthington
%Date: 29/08/2010
%Updated: 11/02/2013 to include transparency
%
%Example 1:
% myIm=load('mandrill');
% figure;
% imsurf(myIm.X);
% axis equal
% colormap(gray)
%Example 2:
% myIm=load('mandrill');
% figure;
% hold on;
% imsurf(myIm.X,[],[-1  0 0],[0 -1 0],0.1);
% imsurf(myIm.X,[],[-1 -1 0],[1 -1 0],0.2);
% imsurf(myIm.X,[],[0  -1 0],[1  0 0],0.3);
% axis equal
% view([-35 35]);
% colormap(myIm.map);
%Example 3:
% myIm=load('mandrill');
% figure;
% hold on;
% im=myIm.X;
% imsurf(im,[],[-1  0 0],[0 -1 0],0.1);
% alphaChannel=repmat(linspace(0,1,size(myIm.X,1))',1,size(myIm.X,2));
% imAlpha = im;
% imAlpha(:,:,2)=alphaChannel;
% imsurf(imAlpha,[],[-1 -1 0],[1 -1 0],0.2);
% imsurf(im,[],[0  -1 0],[1  0 0],0.3);
% axis equal
% view([-35 35]);
% colormap(myIm.map);


if ~(exist('imageIn','var') && ~isempty(imageIn))
	error('imageIn is required as the first input to imsurf');
else
	%If the image is a uint16 then it needs to be made into a double or uint8 to be used by surf
	if isa(imageIn,'uint16')
		imageIn = image2double(imageIn);
	end
	
	if size(imageIn,3)==4
		doAlpha=1;
		alpha=imageIn(:,:,4);
		imageIn=imageIn(:,:,1:3);
	elseif size(imageIn,3)==2
		doAlpha=1;
		alpha=imageIn(:,:,2);
		imageIn=imageIn(:,:,1);
	else
		doAlpha=0;
	end
	if doAlpha
		alpha=image2double(alpha);
			
		%Check that alpha has correct range
		if isa(alpha,'double') && max(alpha(:))>1
			disp('Scaling alpha values so that all transparencies are shown. Transparencies should have range 0 to 1 if class is double.');
			alpha=alpha/max(alpha(:));
		end
	else
		doAlpha=0;
	end
	
	%Check that imagein has correct range
	if isa(imageIn,'double')
		if max(imageIn(:))>1
			disp('Scaling input image so that all colours are shown. Image should have range 0 to 1 if class is double.');
			imageIn=imageIn/max(imageIn(:));
		end
		imageIn = uint8(255*imageIn);%imageIn has to be uint8 so that it works with alpha mapping
	end


end

if ~(exist('upperLeftPoint3','var') && ~isempty(upperLeftPoint3))
	upperLeftPoint3 = [0 0 0];
end
if ~(exist('normal','var') && ~isempty(normal))
	normal = [0 0 1];
end
if ~(exist('imXDirVec','var') && ~isempty(imXDirVec))
	imXDirVec = [1 0 0];
end
if ~(exist('scale','var') && ~isempty(scale))
	scale = 1;
end

if dot(normal,imXDirVec) ~=0
	information(3,'Making imXDirVec normal to normal');
	imXDirVec = cross(normal,cross(imXDirVec,normal));
end

R=rotationMatrixFromTwoVectors([0 0 1]',-normal);
R2=rotationMatrixFromTwoVectors(R*[1 0 0]',imXDirVec(:));

x = [0 1; 0 1]*size(imageIn,2);
y = [0 0; 1 1]*size(imageIn,1);
z = [0 0; 0 0];

xyz = R2*R*[x(:)';y(:)';z(:)'];
x = xyz(1,:);
x = reshape(x,2,2);
y = xyz(2,:);
y = reshape(y,2,2);
z = xyz(3,:);
z = reshape(z,2,2);

clear xyz
x = x*scale + upperLeftPoint3(1);
y = y*scale + upperLeftPoint3(2);
z = z*scale + upperLeftPoint3(3);



if doAlpha
	h=surface('XData',x,'YData',y,'ZData',z,'CData',imageIn,'alphadata',alpha,'FaceAlpha', 'texturemap','FaceColor','texturemap','EdgeColor','none','alphadatamapping','none',varargin{:});
else
	h=surface('XData',x,'YData',y,'ZData',z,'CData',imageIn,'FaceColor','texturemap','EdgeColor','none',varargin{:});
end

%Store input parameters in userdata
u.upperLeftPoint3=upperLeftPoint3;
u.normal=normal;
u.imXDirVec=imXDirVec;
u.scale=scale;
set(h,'userData',u);
end
function [R,theta]=rotationMatrixFromTwoVectors(vStart,vEnd)
%function [R,theta]=rotationMatrixFromTwoVectors(vStart,vEnd)
%Find the matrix R such that vEnd = R*vStart;
%theta is returned in radians
%Author: M Arthington
%Date: 18/07/2010
%Adapted from: ANGLEAXIS2MATRIX
% Copyright (c) 2008 Peter Kovesi
% School of Computer Science & Software Engineering
% The University of Western Australia
% pk at csse uwa edu au
% http://www.csse.uwa.edu.au/

if numel(vStart) ==2
	vStart(3) = 0;
end
if numel(vEnd) ==2
	vEnd(3) = 0;
end

vStartN = vStart/norm(vStart);
vEndN = vEnd/norm(vEnd);

t = cross(vStartN,vEndN);

theta = acos(dot(vStartN,vEndN));

if all(roundDecPlace(t,5)==0) && theta>eps
	
	%Find an orthogonal vector to the start vector
	t = cross(vStartN,vStartN([2 3 1]));
	while all(~logical(t)) || any(isnan(t))
		t = cross(vStartN,rand(3,1));
	end
	t = theta*t/norm(t);
end
if theta < eps   % If the rotation is very small...
	t = [0 0 0];
	R = [ 1   -t(3) t(2)
		t(3) 1   -t(1)
		-t(2) t(1) 1
		];
	return
end

t = theta*t/norm(t);

% Otherwise set up standard matrix, first setting up some convenience
% variables
t = t/theta;
x = t(1);
y = t(2);
z = t(3);

c = cos(theta); s = sin(theta); C = 1-c;
xs = x*s;   ys = y*s;   zs = z*s;
xC = x*C;   yC = y*C;   zC = z*C;
xyC = x*yC; yzC = y*zC; zxC = z*xC;

R = [ x*xC+c   xyC-zs   zxC+ys
	xyC+zs   y*yC+c   yzC-xs
	zxC-ys   yzC+xs   z*zC+c
	];
end
function [n] = roundDecPlace(input,decPlace)
%function [n] = roundDecPlace(input,decPlace)
%Round a number, input, to a specified number of decimal places, decPlace.
%Works up to 15 significant figures
%This function is matricised (it works on elements of matrices)

tenToDecPlace = 10^decPlace;
n = input.*tenToDecPlace;
n = round(n);

n = n./tenToDecPlace;
end
function im=image2double(im)
%Simple im2double

if ~isa(im,'double')
	if isa(im, 'uint8')
		r=2^8-1;
	elseif isa(im, 'uint16')
		r = 2^16-1;
	end
	im = double(im) / r;
end
end
