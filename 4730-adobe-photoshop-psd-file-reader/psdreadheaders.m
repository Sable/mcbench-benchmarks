function metadata = psdreadheader(fid)
%PSDREADHEADER  Read the metadata from an open PSD file.
%   METADATA = PSDREADHEADER(FID) fread metadata from an Adobe Photoshop
%   PSD file using the file handle FID, which must already be opened.

%   Author: Jeff Mather
%   Copyright 1984-2004 The MathWorks, Inc.

fids = fopen('all');

if (isempty(find(fid == fids)))
    error('psdreadheader:badFID', 'Bad file ID.');
end

% Read the PSD header.
metadata.FormatSignature = fread(fid, 4, 'uint8=>char');
if (~isequal(metadata.FormatSignature', '8BPS'))
    fclose(fid);
    error('impsdinfo:badSignature', 'Format signature mismatch (%s).', ...
          metadata.FormatSignature)
end

metadata.FormatVersion = fread(fid, 1, 'uint16=>uint16');
if (metadata.FormatVersion ~= 1)
    error('impsdinfo:badVersion', 'Bad PSD version number (%d).', ...
          metadata.FormatVersion)
end

fseek(fid, 6, 'cof');  % Reserved
metadata.NumSamples = fread(fid, 1, 'uint16');
metadata.Rows = fread(fid, 1, 'uint32');
metadata.Columns = fread(fid, 1, 'uint32');
metadata.BitsPerSample = fread(fid, 1, 'uint16=>uint16');
metadata.ColorMode = decodeColorMode(fread(fid, 1, 'uint16=>uint16'));

% Read color mode data, image resources, and layer/mask information.
blockLen = fread(fid, 1, 'uint32');
metadata.ColorModeData.Length = blockLen;
if (blockLen > 0)
    metadata.ColorModeData.Data = fread(fid, blockLen, 'uint8=>uint8');
else
    metadata.ColorModeData.Data = [];
end

blockLen = fread(fid, 1, 'uint32');
metadata.ImageResources.Length = blockLen;
if (blockLen > 0)
    metadata.ImageResources.Data = fread(fid, blockLen, 'uint8=>uint8');
else
    metadata.ImageResources.Data = [];
end

blockLen = fread(fid, 1, 'uint32');
metadata.LayersAndMasks.Length = blockLen;
if (blockLen > 0)
    metadata.LayersAndMasks.Data = fread(fid, blockLen, 'uint8=>uint8');
else
    metadata.LayersAndMasks.Data = [];
end

% Read the image data block.
metadata.Compression = fread(fid, 1, 'uint16');



function modeString = decodeColorMode(modeNum)
%DECODECOLORMODE  Convert a numeric color mode to a string.

switch (modeNum)
case 0
    modeString = 'Bitmap';
case 1
    modeString = 'Grayscale';
case 2
    modeString = 'Indexed color';
case 3
    modeString = 'RGB';
case 4
    modeString = 'CMYK';
case 7
    modeString = 'Multichannel color';
case 8
    modeString = 'Duotone';
case 9
    modeString = 'Lab';
otherwise
    modeString = modeNum;
end
