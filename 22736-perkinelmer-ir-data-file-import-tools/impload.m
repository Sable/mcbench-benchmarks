function [data, xAxis, yAxis, misc] = impload(filename)
% Reads intensity map data from PerkinElmer block structured files.
% This version is compatible with '1994' standard IMP files.
% IMP files have 2 constant data intervals.
%
% [data, xAxis, yAxis, misc] = impload(filename):
%   data: length(x) * length(y) 2D array
%   xAxis: vector for horizontal axis (e.g. micrometers)
%   yAxis: vector for vertical axis (e.g. micrometers)
%   misc: miscellanous information in name,value pairs

% Copyright (C)2007 PerkinElmer Life and Analytical Sciences
% Stephen Westlake, Seer Green
%
% History
% 2007-04-24 SW     Initial version

% Block IDs
DS3C2IData            = 5108;   % 3D DS: header info
DS3C2IPts             = 5109;   % 3D DS: point coordinates (CvCoOrdArray)
DS3C2IPtsCont         = 5110;   % 3D DS: point coordinates (continuator for large CvCoOrdArray)
DS3C2IHistory         = 5111;   % 3D DS: history record
DSet3DC2DIBlock       = 5112;   % 3D DS: the block containing all other 3d blocks.

fid = fopen(filename,'r');
if fid == -1
    error('Cannot open the file.');
    return
end

% Fixed file header of signature and description
signature = setstr(fread(fid, 4, 'uchar')');
if ~strcmp(signature, 'PEPE')
    error('This is not a PerkinElmer block structured file.');
    return
end
description = setstr(fread(fid, 40, 'uchar')');

% Initialize a variable so we can tell if we have read it.
xLen = int16(0);

% The rest of the file is a list of blocks
while ~feof(fid)
    blockID = fread(fid,1,'int16');
    blockSize = fread(fid,1,'int32');
    
    % feof does not go true until after the read has failed.
    if feof(fid)
        break
    end
    
    switch blockID
        case DS3C2IData % Dataset header
            len = fread(fid,1,'int16');
            alias = setstr(fread(fid, len, 'uchar')');
        
            xDelta = fread(fid, 1, 'double');
            yDelta = fread(fid, 1, 'double');
            x0 = fread(fid, 1, 'double');
            y0 = fread(fid, 1, 'double');
            xLen = fread(fid, 1, 'int32');
            yLen = fread(fid, 1, 'int32');
            
            len = fread(fid, 1, 'int16');
            xLabel = setstr(fread(fid, len, 'uchar')');
            len = fread(fid, 1, 'int16');
            yLabel = setstr(fread(fid, len, 'uchar')');
            len = fread(fid, 1, 'int16');
            zLabel = setstr(fread(fid, len, 'uchar')');

        case DS3C2IPts  % This contains the first block
            count = blockSize / 8;
            data = fread(fid, count, 'double');
            
        case DS3C2IPtsCont % Continuation blocks
            countCont = blockSize / 8;
            data(count + 1 : count + countCont) = fread(fid, countCont, 'double');
            count = count + countCont;
     
        otherwise               % unknown block, just seek past it
            fseek(fid, blockSize, 'cof');
    end
end
fclose(fid);

if xLen == 0
    error('The file does not contain spectral image data.');
    return
end

% Reshape the linear array we have read in and flip so the
% data is in the correct aspect for image(data) with 1,1 at the top.
data = flipud(transpose(reshape(data, xLen, yLen)));

% Expand the axes specifications into vectors
% The yAxis is reversed to match the flip.
xEnd = x0 + (xLen - 1) * xDelta;
yEnd = y0 + (yLen - 1) * yDelta;
xAxis = x0 : xDelta : xEnd;
yAxis = yEnd : -yDelta : y0;

% Return the other details as name,value pairs
misc(1,:) = {'xLabel', xLabel};
misc(2,:) = {'yLabel', yLabel};
misc(3,:) = {'zLabel', zLabel};
misc(4,:) = {'alias', alias};

