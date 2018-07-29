function [data, wAxis, dAxis, xAxis, yAxis, misc] = lscload(filename)
% Reads in IR image data from PerkinElmer block structured files.
% This version is compatible with '1994' standard LSC files.
%
% [data, wAxis, dAxis, xAxis, yAxis, misc] = lscload(filename):
%   data:  2D array, [W, D]     wavelength x distance
%   wAxis: vector of e.g. wavenumbers
%   dAxis: vector of distance along line
%   xAxis: vector for stage x positions (e.g. micrometers)
%   yAxis: vector for stage y positions (e.g. micrometers)
%   misc: miscellanous information in name,value pairs

% Copyright (C)2007 PerkinElmer Life and Analytical Sciences
% Stephen Westlake, Seer Green
%
% History
% 2007-05-01 SW     Initial version

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
dLen = int32(0);
qLen = int32(0);

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
        
            dDelta = fread(fid, 1, 'double');       % distance delta
            angle = fread(fid, 1, 'double');        % angle (radians)
            wDelta = fread(fid, 1, 'double');       % wavenumber delta
            fread(fid, 1, 'double');      % zstart
            fread(fid, 1, 'double');      % zend    
            fread(fid, 1, 'double');      % min data value
            fread(fid, 1, 'double');      % max data value
            x0 = fread(fid, 1, 'double');           % stage x0
            y0 = fread(fid, 1, 'double');           % stage y0
            w0 = fread(fid, 1, 'double');           % wavenumber start
            dLen = fread(fid, 1, 'int32');          % distance points
            qLen = fread(fid, 1, 'int32');          % should be 1
            wLen = fread(fid, 1, 'int32');          % wavelength points            
            
            len = fread(fid, 1, 'int16');
            dLabel = setstr(fread(fid, len, 'uchar')');
            len = fread(fid, 1, 'int16');
            setstr(fread(fid, len, 'uchar')');
            len = fread(fid, 1, 'int16');
            wLabel = setstr(fread(fid, len, 'uchar')');
            len = fread(fid, 1, 'int16');
            zLabel = setstr(fread(fid, len, 'uchar')');

            % imshow row 1 is the top, i.e. fsm row N.
            d = dLen;
            
        case DS4C3IFloatPts         % the next spectrum
            data(d, :) = fread(fid, wLen, 'float');
            if d == 0
                error('There are too many data points.');
                return
            end
            % set up the index for the next point
            d = d - 1;
     
        otherwise               % unknown block, just seek past it
            fseek(fid, blockSize, 'cof');
    end
end
fclose(fid);

if dLen == 0
    error('The file does not contain spectral image data.');
    return
end
if qLen ~= 1
    error('The file does not contain line scan data.');
    return
end

% d0 is implicitly 0
dEnd = (dLen - 1) * dDelta;
wEnd = w0 + (wLen - 1) * wDelta;

% Calculate end stage positions from angle and hypoteneuse
xEnd = x0 + dEnd * cos(angle);
yEnd = y0 + dEnd * sin(angle);
xDelta = dDelta * cos(angle);
yDelta = dDelta * sin(angle);

% Expand the axes specifications into vectors
% D axis is reversed to match the image data
xAxis = x0 : xDelta : xEnd;
yAxis = y0 : yDelta : yEnd;
dAxis = dEnd : -dDelta : 0;
wAxis = w0 : wDelta : wEnd;

% Return the other details as name,value pairs
misc(1,:) = {'dLabel', dLabel};
misc(2,:) = {'wLabel', wLabel};
misc(3,:) = {'zLabel', zLabel};
misc(4,:) = {'alias', alias};
misc(5,:) = {'angle', angle};


