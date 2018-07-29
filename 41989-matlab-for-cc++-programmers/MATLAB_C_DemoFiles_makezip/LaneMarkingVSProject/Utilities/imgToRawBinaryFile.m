function imgToRawBinaryFile(img, filename)
% imgToRawBinaryFile writes image to a raw binary file
%
%   Inputs:
%       img         a grayscale uint8 image
%       filename    name of binary file to write
%
%   Binary File format
%       count   type        meaning
%   =========================================
%       1       uint16      image width  (m)
%       1       uint16      image height (n)
%       1       uint16      color planes (p)
%       m*n*p   uint8       pixel values
%
%
% This code is provided for example purposes only.
%
% Copyright 2011-12 MathWorks, Inc.
%

%% Check inputs
if nargin < 2
    error('Please supply an image, and a filename to write.');
end

if ~isa(img, 'uint8')
    error('Only uint8 images are currently supported');
end

%% Get Size of Image
[row, col, plane] = size(img);

if plane > 3
    error('Only single channel or true-color images are currently supported.');
end

if row > intmax('uint16') || col > intmax('uint16')
    error(['Largest image dimension is ' num2str(intmax('uint16')) '.']);
end

%% Open File
FID = fopen(filename, 'w');

%% Write Dimensions
fwrite(FID, row,   'uint16');
fwrite(FID, col,   'uint16');
fwrite(FID, plane, 'uint16');

%% Write Image Data
fwrite(FID, img, 'uint8');

%% Close File
fclose(FID);

end