% run_exiftool_demo
% Demonstration of functions
%    getexif
%    putexif
% Peter Burns, 28 May 2013
%              22 July fixed minor mistake calling putexif

[f,p] = uigetfile({'*.jpg';'*.tif'}, ...
'Select image file');

% Read Exif data
exifdata = getexif([p,f]);
disp(exifdata)

dat = imread([p,f]);
imagesc(dat), axis image

%
% Do processing image data here ...
% (For this demo. we save the original data)
%

[f1,p1] = uiputfile({'*.jpg';'*.tif'},'Save as');

% Save image with original Exif data
status = putexif(dat,[p1,f1], [p,f]);

% Check
[exifdata1, nf1] = getexif([p,f]);
disp(exifdata1)
[exifdata2, nf2] = getexif([p1,f1]);
disp(exifdata2)
