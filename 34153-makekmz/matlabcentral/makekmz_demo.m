%
% this scripts illustrates the use of makekmz to generate kmz files
% for GoogleEarth overlay images
%
% For fun, two simple images (one in lat/lon, the other in
% northing/easting and rotated) are made to overlay the
% painted "Y" near Brigham Young University in Provo, UT  USA
% kmz files are created for each that can be viewed in GoogleEarth
%
% see makekmz.m for how to call it and the meaning of the various arguments

% Written by David Long 9 Dec 2011

%% first an example of a simple image overlay
disp('First example');

% read sample image
[img1 cmap]=imread('BYUblue.png');
% note that image is oriented so that when displayed using the default
% matlab image (i.e., axis ij) it appears with North upward, that is,
% low row indexes are more northly than southern indexes
img=double(img1);

% specify image corners
lat=[  40.248890   40.248890;   40.247699   40.247699];   
lon=[-111.621780 -111.619872; -111.621780 -111.619872];

% display sample image using default settings
figure(2);
image(img1); 
colormap(cmap);
axis image;
title('sample image');

% (optionally) create an alpha mask for image where image pixels are
% only visible where alpha==1
alpha=zeros(size(img));
alpha(img>0)=1;

% set color conversion range for this particular image and color table
% the input pixel values from imscale(1) to imscale(2) are scaled to 
% the range 0..255 to create the 8-bit image used in the kmz file
imscale=[0 256];

% call makekmz to create kmz file
% optional arguments are used to illustrate some capabilities
currentdir=pwd;
makekmz(img,lat,lon,'destdir',currentdir,'imname','BYUmountain', ...
	'scale',imscale,'fignum',1,'nameprefix','BYU on ','alpha',alpha ...
	 ,'cmap',cmap);

disp(' ');
disp('Second example');

%% the following example illustrates creating a segmented (tiled)
% overlay where the original image is rotated and embedded into a larger
% rectangular array

% read sample image
[img1 cmap]=imread('Yblue.png');
% note that image is oriented so that when displayed using the default
% matlab image (i.e., axis ij) it appears with North upward, that is,
% low row indexes are more northly than southern indexes
img=double(img1);

% specify image corners
% note that when rotation is employed, the (4,4) position is not used
lat=[   40.248585   40.248185;   40.248357   40.247956];   
lon=[ -111.620185 -111.620034; -111.621337 -111.621183];

% display sample image using default settings
figure(3);
image(img1); axis image;
colormap(cmap);
title('sample image')

% (optionally) create an alpha mask for image where image pixels are
% only visible where alpha==1
alpha=zeros(size(img));
alpha(img>0)=1;

% color conversion range for this particular image and color table
% the input pixel values from imscale(1) to imscale(2) are scaled to 
% the range 0..255 to create the 8-bit image used in the kmz file
imscale=[0 256];

% define a placemark name, location
% note: altitude=0 puts the placemark at the surface
Yname='The "Y"';
Yloc=[-111.621264 40.248165 0];

% call makekmz to create kmz file
% optional arguments are used to illustrate some capabilities
makekmz(img,lat,lon,'debug','destdir',currentdir,'imname','Ymountain', ...
	'scale',imscale,'fignum',4,'nameprefix','Y on ','alpha',alpha, ...
     	 'cmap',cmap,'RotAngle','maxsize',256, ...
	 'placemark','The "Y"',Yloc);

