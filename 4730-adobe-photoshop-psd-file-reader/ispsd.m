function tf = ispsd(filename)
%ISBMP Returns true for an Adobe Photoshop PSD file.
%   TF = ISPSD(FILENAME)

%   Author: Jeff Mather
%   Copyright 1984-2004 The MathWorks, Inc.

% Open the file.
fid = fopen(filename, 'r', 'ieee-be');

if (fid < 0)
    tf = false;
    return
end

FormatSignature = fread(fid, 4, 'uint8=>char');
if (~isequal(FormatSignature', '8BPS'))
    fclose(fid);
    tf = false;
    return
end

FormatVersion = fread(fid, 1, 'uint16=>uint16');
if (FormatVersion ~= 1)
    fclose(fid);
    tf = false;
    return
end

tf = true;
