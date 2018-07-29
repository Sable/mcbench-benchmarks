function [X, map] = readpsd(filename)
%READPSD  Read image from an Adobe Photoshop PSD file.
%    X = READPSD(FILENAME) read an image from an Adobe Photoshop PSD
%    file.
%
%    Notes:
%    ------
%    This only reads pixel data from the base layer of the image.
%    Additional layers are not read.  Adjustments in adjustment layers
%    are not computed.
%
%    Only uncompressed and packbits compressed files are supported.
%
%    See also IMREAD, PSDREADHEADERS, IMPSDINFO.

%   Author: Jeff Mather
%   Copyright 1984-2004 The MathWorks, Inc.


% Open the file.
fid = fopen(filename, 'r', 'ieee-be');

if (fid < 0)
    error('impsdinfo:fileOpen', 'Could not open file (%s)', filename);
end

% Read the headers.
metadata = psdreadheaders(fid);

% Read the image.
if (metadata.Compression)
    
    % Create the output buffer with the right datatype.
    if (metadata.BitsPerSample == 1)
        
        X(metadata.Columns,metadata.Rows,metadata.NumSamples) = logical(0);
        
    elseif (metadata.BitsPerSample == 8)
        
        X(metadata.Columns,metadata.Rows,metadata.NumSamples) = uint8(0);
        
    elseif (metadata.BitsPerSample == 16)
        
        X(metadata.Columns,metadata.Rows,metadata.NumSamples) = uint16(0);
        
    end
        
    % Read compressed data.
    scanlineLengths = fread(fid, metadata.Rows * metadata.NumSamples, ...
                            'uint16');
    
    for p = 1:numel(scanlineLengths)
        
        idx = (p - 1) * metadata.Columns + 1;
        X(idx:(idx + metadata.Columns - 1)) = ...
            decodeScanline(fid, scanlineLengths(p), metadata);
        
    end
   
else
    
    % Read the uncompressed pixels.
    numPixels = metadata.NumSamples * metadata.Rows * metadata.Columns;
    X = fread(fid, numPixels, ...
                          sprintf('*ubit%d', metadata.BitsPerSample));

end

% Reshape the pixels.
X = reshape(X, [metadata.Columns, metadata.Rows, metadata.NumSamples]);
X = permute(X, [2 1 3]);

% Close the file.
fclose(fid);

% Colormaps aren't supported yet.
map = [];



function buffer = decodeScanline(fid, scanlineLength, metadata)
%READRLE  Read and decode an RLE scanline.

buffer(metadata.Columns, 1) = uint8(0);
count = 1;

fpos = ftell(fid);
while ((ftell(fid) - fpos) < scanlineLength)
    
    lengthByte = fread(fid, 1, 'uint8');
    
    if (lengthByte <= 127)
        
        % Read lengthByte + 1 values.
        idxStart = count;
        idxEnd = idxStart + lengthByte;
        buffer(idxStart:idxEnd) = fread(fid, lengthByte + 1, 'uint8=>uint8');

    elseif (lengthByte >= 129)
        
        % Copy the next byte (257 - lengthByte) times.
        idxStart = count;
        idxEnd = idxStart + 257 - lengthByte - 1;
        runVal = fread(fid, 1, 'uint8=>uint8');
        buffer(idxStart:idxEnd) = runVal;
        
    end
    
    count = idxEnd + 1;
    
end
