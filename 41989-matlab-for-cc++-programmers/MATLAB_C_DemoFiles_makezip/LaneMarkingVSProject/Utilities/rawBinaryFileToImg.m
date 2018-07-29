function img = rawBinaryFileToImg(filename)
% rawBinaryFileToImg read image from raw binary file
%
%   Inputs:
%       filename    name of binary image file to read
%
%   Outputs:
%       img         a grayscale uint8 image
%
%   Binary File format
%       count   type        meaning
%   =========================================
%       1       uint16      image width  (m)
%       1       uint16      image height (n)
%       m*n     uint8       pixel values
%
%
% This code is provided for example purposes only.
%
% Copyright 2011 MathWorks, Inc.
%

%% Check inputs
if nargin < 1
    error('Please supply a binary image filename to read.');
end

if exist(filename, 'file') ~= 2
    error('Invalid filename, file does not exist.');
end



%% Open File
FID = fopen(filename, 'r');

%% Read Dimensions

[row, count] = fread(FID, 1, 'uint16');

if count < 1
    error('Unable to read number of rows.');
end

[col, count]= fread(FID, 1, 'uint16');

if count < 1
    error('Unable to read number of columns.');
end

%% Verify Size of Image
if row < 1 || col < 1
    error('Invalid image dimensions supplied');
end

%% ReadImage Data
[img count] = fread(FID, [row col], '*uint8');

if count < (row*col)
    error('Unable to read entire image.');
end

%% Close File
fclose(FID);

end