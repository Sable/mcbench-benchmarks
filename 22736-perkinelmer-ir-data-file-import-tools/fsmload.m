function [data, xAxis, yAxis, zAxis, misc] = fsmload(filename)
% Reads in IR image data from PerkinElmer block structured files.
% This version is compatible with '1994' standard FSM files.
% FSM files have 3 constant data intervals.
%
% [data, xAxis, yAxis, zAxis, misc] = fsmload(filename):
%   data:  3D array, [Y, X, Z]
%   xAxis: vector for horizontal axis (e.g. micrometers)
%   yAxis: vector for vertical axis (e.g. micrometers)
%   zAxis: vector for wavenumber axis (e.g. cm-1)
%   misc: miscellanous information in name,value pairs

% Copyright (C)2007 PerkinElmer Life and Analytical Sciences
% Stephen Westlake, Seer Green
%
% History
% 2007-04-24 SW     Initial version

% Block IDs
DS4C3IData            = 5100;   % 4D DS: header info
DS4C3IPts             = 5101;   % 4D DS: point coordinates (CvCoOrdArray)
DS4C3IPtsCont         = 5102;   % 4D DS: point coordinates (continuator for large CvCoOrdArray)
DS4C3ITemp2DData      = 5103;   % 4D DS: temp block for storing part of component 2d dataset
DS4C3I2DData          = 5104;   % 4D DS: release sw block for storing ALL of component 2d data
DS4C3IFloatPts        = 5105;   % 4D DS: point coordinates (FloatArray)
DS4C3IFloatPtsCont    = 5106;   % 4D DS: point coordinates (continuator for large FloatArray)
DS4C3IHistory         = 5107;   % 4D DS: history record

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
        case DS4C3IData
            len = fread(fid,1,'int16');
            alias = setstr(fread(fid, len, 'uchar')');
        
            xDelta = fread(fid, 1, 'double');
            yDelta = fread(fid, 1, 'double');
            zDelta = fread(fid, 1, 'double');
            fread(fid, 1, 'double');      % zstart
            fread(fid, 1, 'double');      % zend    
            fread(fid, 1, 'double');      % min data value
            fread(fid, 1, 'double');      % max data value
            x0 = fread(fid, 1, 'double');
            y0 = fread(fid, 1, 'double');
            z0 = fread(fid, 1, 'double');
            xLen = fread(fid, 1, 'int32');
            yLen = fread(fid, 1, 'int32');
            zLen = fread(fid, 1, 'int32');            
            
            len = fread(fid, 1, 'int16');
            xLabel = setstr(fread(fid, len, 'uchar')');
            len = fread(fid, 1, 'int16');
            yLabel = setstr(fread(fid, len, 'uchar')');
            len = fread(fid, 1, 'int16');
            zLabel = setstr(fread(fid, len, 'uchar')');
            len = fread(fid, 1, 'int16');
            wLabel = setstr(fread(fid, len, 'uchar')');

            % matlab row 1 is the top, i.e. fsm row N.
            y = yLen;
            x = 1;
            
        case DS4C3IFloatPts         % the next spectrum
            data(y, x, :) = fread(fid, zLen, 'float');
            % set up the index for the next point
            x = x + 1;
            if x > xLen
                x = 1;
                y = y - 1;
            end
     
        otherwise               % unknown block, just seek past it
            fseek(fid, blockSize, 'cof');
    end
end
fclose(fid);

if xLen == 0
    error('The file does not contain spectral image data.');
    return
end

% Expand the axes specifications into vectors
% Y axis is reversed to match the image
xEnd = x0 + (xLen - 1) * xDelta;
yEnd = y0 + (yLen - 1) * yDelta;
zEnd = z0 + (zLen - 1) * zDelta;
xAxis = x0 : xDelta : xEnd;
yAxis = yEnd : -yDelta : y0;
zAxis = z0 : zDelta : zEnd;

% Return the other details as name,value pairs
misc(1,:) = {'xLabel', xLabel};
misc(2,:) = {'yLabel', yLabel};
misc(3,:) = {'zLabel', zLabel};
misc(4,:) = {'wLabel', wLabel};
misc(5,:) = {'alias', alias};

