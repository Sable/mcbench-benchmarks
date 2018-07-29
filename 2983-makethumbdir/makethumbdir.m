function makethumbdir(maxsize, keepfrac)

% Syntax: MAKETHUMBDIR(MAXSIZE, KEEPFRAC)
%
% The user is prompted to select any image in the folder to be "thumbnailed." The mfile
% will then create thumbnails for all MATLAB-writeable image types having the same extension
% as the selected image and residing in the selected directory, and store them in a thumbnail
% folder within that directory. Thumbnails will have the same name as their parent images,
% although their paths will necessarily be different.
%
% ARGUMENTS:
%
% Two OPTIONAL ARGUMENTS, as follows:
%
% MAXSIZE is the maximum size of the thumbnail, in kB. The default value of MAXSIZE is 32 (kB).
% Note that some image writing algorithms produce images that are further compressed;
% maxsize is a target for the number of bytes in an uncompressed version of the thumbnail image;
% thumbnails will not be larger than maxsize, but they may be considerably smaller.
%
% KEEPFRAC (which, if it is provided, must be a positive integer greater than 1) determines
% the number of rows and columns maintained from the original image. A thumbnail for a
% "2-dimensional" (eg., indexed or grayscale) image should approach 1/keepfrac^2 times
% the size of its parent image, or 3/keepfrac^2 for "3-dimensional" (eg., truecolor or RGB)
% images. For example, if the value is set to 8, a thumbnail for a grayscale image will
% approach 1/64th the size of the parent image.
% BY DEFAULT, the value is set dynamically for each parent image to target a thumbnail
% that is no larger than MAXSIZE kB. However, if KEEPFRAC is provided, MAXSIZE is ignored.
%
% The program supports all image file types writeable by MATLAB:
% JPEG, TIFF, BMP, PNG, HDF, PCX, or XWD.
% The user will be presented with a uigetfile dialog box in which to select a single image
% to thumbnail. All images of the same extension/type in the same folder will be similarly
% thumbnailed.
%
% EXAMPLE: makethumbdir %Creates a default series of thumbnails of maximum 32 kB.
%          makethumbdir(64) %May be of higher resolution, with images possibly ranging
%                up to 64 kB.
%          makethumbdir([],4) %Writes thumbnails comprising every 4th row and column
%          makethumbdir(64,4) %Writes thumbnails comprising every 4th row and column
%                (first argument is ignored)
%
% Written by Brett Shoelson (shoelson@helix.nih.gov; shoelson@hotmail.com).
% Last update 1/31/03.
% Tested under R12.1 and R13.

if ~nargin
    maxsize = 32;
    keepfrac = -1;
elseif nargin == 1
	keepfrac = -1;
elseif nargin > 2
    error('Too many input arguments.');
end
maxsize = maxsize*1e3;
if ~isa(keepfrac, 'numeric') | floor(keepfrac) ~= keepfrac | (keepfrac < 0 & keepfrac ~= -1) | keepfrac == 1
    error('keepfrac must be a positive integer greater than 1.');
end
if keepfrac == -1
	dynamicfrac = 1;
else
	dynamicfrac = 0;
end

% Get the name and location of data set to be thumbnailed
[filename, path1] = uigetfile({'*.jpg;*.tif;*.bmp;*.png;*.hdf;*.pcx;*.xwd'},'Select an image for "thumbnailing."');
if ~filename
	return
end
[pathstr, name, ext] = fileparts(fullfile(path1, filename));
imtype = lower(ext(2:end));
if strcmp(imtype,'tiff')
	imtype = 'tif';
elseif strcmp(imtype,'jpeg')
	imtype = 'jpg';
end

cd(path1);
mylist = dir(['*', ext]);
numims = length(mylist);
path2 = [path1 [imtype 'Thumbnails']];

status = mkdir([imtype 'Thumbnails']);
if status == 2
   error([imtype 'Thumbnail directory already exists in this folder. Delete folder, if desired, and re-issue makethumbnaildirectory command.']);
elseif status == 0
   error('mkdir failed.');
end

for imnum = 1:numims
   fprintf('Creating thumbnail for image %i of %i.\n',imnum,numims);
   fname = [path2 '\' getfield(mylist, {imnum}, 'name')];
   k1 = imread(getfield(mylist,{imnum},'name'));
   if dynamicfrac == 1
       s = whos('k1');
       keepfrac = max(ceil(sqrt(s.bytes/maxsize)),1);
   end
   thumb = makethumb(k1, keepfrac);
   imwrite(thumb, fname , imtype);
end

function thumb = makethumb(k, keepfrac)
rows = 1 : keepfrac : size(k,1);
cols = 1 : keepfrac : size(k, 2);
thumb = k(rows, cols, :);
