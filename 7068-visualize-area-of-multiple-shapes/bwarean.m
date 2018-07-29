function [A,BW2] = bwarean(BW,method,conn)
% BWAREAN returns the area of each individual shape in a binary image
%
%	INPUT
%   -------
%	BW: a binary image or 2d matrix
% 	method: 'analog' | 'digital' (default)
% 		The 'digital' method measures the area of a shape as the total number
% 		of its pixels, while 'analog' adds half pixels to pairs of diagonaly
% 		positioned pixels, considering that the digital shape is only an
% 		approximation of the digitized shape. 'Digital' is faster than
% 		'analog'. For further information see the BWAREA function in the
% 		Image Processing Toolbox Help.
% 	conn: 4 | 8 (default)
% 		Connectivity of pixels in order to determine if pixels
% 		belong to the same shape. See BWLABEL.
%
% 	OUTPUT 
%   -------
% 	A: a vector (n-by-1) giving the area of each shape in the image
% 		The index of the entries correspond to the labeling order
% 		of shapes as given by the BWLABEL function.
%	BW2: image with shapes labeled by their area values
%
%   Use
%   -------
% 	1) 'Analog' area measurement of multiple shapes
% 	This is an extension of the Image Processing Toolbox functions 
% 	BWAREA and REGIONPROPS. On one hand BWAREA allows for two types 
% 	of area measurements ('digital', or sum of pixels and 'analog'), 
% 	but cumulates into a single value the areas of all non-connected
% 	shapes in an image; while on the other hand REGIONPROPS gives the 
% 	area of all shapes individualy, but expressed only in the 'digital' 
% 	mode. The present function - BWAREAN - provides individual 
% 	measurements of both types.
% 
% 	2) Area visualization
% 	In addition to its use as a measuring tool, BWAREAN helps the 
% 	visualization of the results by generating an image in which each 
% 	shape is labeled with the value of its area (similar to BWLABEL).
% 
%   Requirements
%   -------
%   Image Processing Toolbox.
%
%   See also BWAREA, BWLABEL, BWLABELN, REGIONPROPS.
%
%   Example
%   -------
%	Note: 
% 	Type BWAREAN_DEMO; at Matlab prompt with image file textsample.png 
% 	in the working directory or run the following example.
%
% 	% Load image
% 	BW = imread('textsample.png');
% 
% 	% Remove shapes connected to the image border
% 	BW = imclearborder(BW);
% 
% 	% Get area count for shapes in image
% 	[A,BW2] = bwarean(BW);
% 
% 	% Image with area values mapped to a given number of colors.
% 	cm = [	1	0	0
% 			1	.5	0
% 			1	1	0
% 			0	1	0
% 			0	1	1
% 			0	.75	1
% 			0	0	1];
% 	bkgd = [0 0 0];
% 	BW2 = ceil( size(cm,1) * ( BW2-min(A)+1 ) / max(A) );
% 
% 	% Display image
% 	figure
% 	image(BW2+1)	% adds 1 to make the background visible
% 	axis image, axis off
% 	colormap([bkgd;cm]), colorbar
% 	imwrite(BW2+1,[bkgd;cm],'bwarean.tif','tif')
% 
% 	% Area histogram
% 	figure
% 	% clustering
% 	subplot(122);
% 	[n,xout] = hist(A,size(cm,1));
% 	bar(xout,n,'BarWidth',1)
% 	set(findobj(gca,'Type','patch'),...
% 		'FaceColor','none','EdgeColor','r')
% 	title('Clustered')
% 	xlabel(['Area'])
% 	ylabel(['Shapes'])
% 	xlim([min(A),max(A)])
% 	ylim([0,max(n)])
% 	axis square
% 
% 	% no clustering
% 	subplot(121);
% 	[n,xout] = hist(A,size(A,1));
% 	bar(xout,n,'BarWidth',1)
% 	set(findobj(gca,'Type','patch'),...
% 		'FaceColor','b','EdgeColor','b')
% 	title('No clustering')
% 	xlabel(['Area (min: ',num2str(min(A)),', max: ',num2str(max(A)),')'])
% 	ylabel(['Shapes (total: ',num2str(sum(n)),')'])
% 	xlim([min(A),max(A)])
% 	ylim([0,max(n)])
% 	axis square

% Vlad Atanasiu - 01/03/2005
% Revisions: 1  > 13/03/2005

% parse inputs
if nargin < 3
    conn = 8;
end
if nargin < 2
    method = 'digital';
end

% vector containing the area of each shape
A = [];
% image with each shape labeled with its area value
BW2 = zeros(size(BW));

% identify each individual shape by a number
[L,n] = bwlabeln(BW,conn);

% measure areas
if isequal(method,'digital')			% area = sum of pixel
	% measure areas
	A = regionprops(L, 'Area');
	A = [A.Area]';
	if nargout > 1
		% replace labels with area values
		A = [0;A];
		BW2 = A(L+1)-1;
		A = A(2:end);
	end
else									% 'anti-aliased' area
	% display waitbar
	global waitbarHandle;
	waitbarHandle = waitbar(0,'Please wait...');
	set(waitbarHandle,...
		'Name','BWAREAN: Measuring shape areas in image.');

	for k = 1:n
		A = [A; bwarea(ismember(L,k))];
		if nargout > 1
			% add area values to output image
			BW2 = BW2 + (L==k)*A(end);
		end
		% increment waitbar
		waitbar(k/n,waitbarHandle,[num2str(floor(k*100/n)),'%']);
		drawnow;
	end
	close(waitbarHandle);
end

