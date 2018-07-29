function [data, xAxis, yAxis, misc] = impload(filename)
% Reads PerkinElmer vis image files files.
% This version is compatible with single image files.
%
% [data, xAxis, yAxis] = visload(filename):
%   data: length(x) * length(y) 2D array
%   xAxis: vector for horizontal axis (e.g. micrometers)
%   yAxis: vector for vertical axis (e.g. micrometers)

% Copyright (C)2007 PerkinElmer Life and Analytical Sciences
% Stephen Westlake, Seer Green
%
% History
% 2007-04-29 SW     Initial version


% Read the bitmap
data = imread(filename, 'bmp');;

fid = fopen(filename,'r');
if fid == -1
    error('Cannot open the file.');
    return
end

% Fixed file header of signature and description
signature = setstr(fread(fid, 2, 'uchar')');
if ~strcmp(signature, 'BM')
    error('This is not a PerkinElmer vis file.');
    return
end
fseek(fid, 0, 'bof');


% Read the trailer
fseek(fid, -4 * 8, 'eof');

% YAxis is reversed to suit image()
xAxis(1) = fread(fid, 1, 'double');     % x1
yAxis(2) = fread(fid, 1, 'double');     % y1 
xAxis(2) = fread(fid, 1, 'double');     % x2
yAxis(1) = fread(fid, 1, 'double');     % y2

fclose(fid);

