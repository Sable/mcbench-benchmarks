function [A,BW2] = bwarean_demo(BW)
% BWAREAN_DEMO shows multiple shapes area count performed by BWAREAN_DEMO.M
%	 BW: a binary image or 2d matrix
%	  A: count areas of shapes in image
%	BW2: image with colorcoded shapes by area

% Vlad Atanasiu - 01/03/2005
% Revisions: 1  > 13/03/2005

% Load image
if nargin < 1
	BW = imread('textsample.png');
end

% Remove shapes connected to the image border
BW = imclearborder(BW);

% Get area count for shapes in image
[A,BW2] = bwarean(BW);

% Image with area values mapped to a given number of colors.
cm = [	1	0	0
		1	.5	0
		1	1	0
		0	1	0
		0	1	1
		0	.75	1
		0	0	1];
bkgd = [0 0 0];
BW2 = ceil( size(cm,1) * ( BW2-min(A)+1 ) / max(A) );

% Display image
figure
image(BW2+1)	% adds 1 to make the background visible
axis image, axis off
colormap([bkgd;cm]), colorbar
imwrite(BW2+1,[bkgd;cm],'bwarean.tif','tif')

% Area histogram
figure
% clustering
subplot(122);
[n,xout] = hist(A,size(cm,1));
bar(xout,n,'BarWidth',1)
set(findobj(gca,'Type','patch'),...
	'FaceColor','none','EdgeColor','r')
title('Clustered')
xlabel(['Area'])
ylabel(['Shapes'])
xlim([min(A),max(A)])
ylim([0,max(n)])
axis square

% no clustering
subplot(121);
[n,xout] = hist(A,size(A,1));
bar(xout,n,'BarWidth',1)
set(findobj(gca,'Type','patch'),...
	'FaceColor','b','EdgeColor','b')
title('No clustering')
xlabel(['Area (min: ',num2str(min(A)),', max: ',num2str(max(A)),')'])
ylabel(['Shapes (total: ',num2str(sum(n)),')'])
xlim([min(A),max(A)])
ylim([0,max(n)])
axis square

