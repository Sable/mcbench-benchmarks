function I2= iir(filename,f,varargin)
%IIR Increases the resolution of an image by interpolation
% B= IIR(inputfile,f) returns the image stored in file 'inputfile' with 
% resolution increased by factor f in both dimensions. 'filename' must be a 
% valid graphic file (jpg, gif, tiff, etc.). It can be grayscale or color. 
% Parameter 'f' is the size increase ratio, so to increase by 50% 
% use f= 1.5, to double size (in each dimension) use f= 2.
%
% Additional parameters:
% B= IIR(A,f,'Display','off') eliminates display of both images, the original 
% and the modified. Deafult 'on'
%
% B= IIR(A,f,'Method',method) Allows to choose between five methods of 
% interpolation: linear, spline, pchip, cubic or v5cubic. 'method' must 
% be a string character. Default 'linear'
%
% Example:
% B= iir('myimage.jpg',2,'Method','cubic');
%
% Last modified: Sep. 2010

% Defaults
method= 'linear';
displ= 'on';
f= max(f,1);
npass= 1;

% Extract optional arguments
for j= 1:2:length(varargin)
	switch varargin{j}
		case 'method'
			method= varargin{j+1};
		case 'display'
			displ= varargin{j+1};
		otherwise
			error('Unknown parameter name');
	end
end

% Read image file
I= imread(filename);

% -------------------------------------------
% Do the math 
% Sizes and new image array
nrow= ceil(size(I,1)+ size(I,1)*(f-1)/npass);
ncol= ceil(size(I,2)+ size(I,2)*(f-1)/npass);
I2= uint8(zeros(nrow,ncol,size(I,3)));

% Loop through rows & cols
for j= 1:size(I,1)
	for c= 1:size(I,3)
		I2(j,:,c)= expand(double(I(j,:,c)),ncol,method);  
	end
end
for j= 1:size(I2,2)
	for c= 1:size(I,3)
		I2(:,j,c)= expand(double(I2(1:size(I,1),j,c)),nrow,method);
	end
end


% Plot final images
if strcmp(displ,'on')
	if size(I,3) == 1
		figure(1), imagesc(I); colormap(gray); axis image, axis off
		figure(2), imagesc(I2);colormap(gray); axis image, axis off
	else
		figure(1), image(I); axis image, axis off
		figure(2), image(I2);axis image, axis off
	end
end


% ##################################################
% Support function
% ##################################################

function yy= expand(y,ndot,method)

x = 1:length(y);
xx = linspace(1,length(y),ndot);
switch method
	case 'linear'
		yy = uint8(interp1(y,xx,'linear'));
	case 'spline'
		yy = uint8(interp1(y,xx,'spline'));
	case 'pchip'
		yy = uint8(interp1(y,xx,'pchip'));
	case 'cubic'
		yy = uint8(interp1(y,xx,'cubic'));
	case 'v5cubic'
		yy = uint8(interp1(y,xx,'v5cubic'));
end
