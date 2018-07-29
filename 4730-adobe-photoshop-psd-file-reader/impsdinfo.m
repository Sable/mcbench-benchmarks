function metadata = impsdinfo(filename)
%IMPSDINFO  Read metadata from a PSD file.
%    METADATA = IMPSDINFO(FILENAME) read the metadata from an Adobe
%    Photoshop PSD file.
%
%    See also IMFINFO, PSDREADHEADERS, READPSD.

%   Author: Jeff Mather
%   Copyright 1984-2004 The MathWorks, Inc.


% Open the file.
fid = fopen(filename, 'r', 'ieee-be');

if (fid < 0)
    error('impsdinfo:fileOpen', 'Could not open file (%s)', filename);
end

% Read the headers.
metadata = psdreadheaders(fid);

% Close the file.
fclose(fid);
