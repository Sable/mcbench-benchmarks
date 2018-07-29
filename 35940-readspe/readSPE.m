% readSPE.m
function image = readSPE(dirPath, filename)
% readSPE.m  Read princeton instrument *.SPE image file
%
% image = readSPE(filename)
%       = readSPE(dirPath, filename)
%
% where: image - 3D array of image(s)
%     filename - path and filename (string)
%      dirPath - optional directory path (string)
% 
% Image is returned as a 3D array, where each image is the first 2
% dimensions, and successive images are stored along the 3rd dimension.
%
% The image is stored as it is shown in WinVIEW; the first two dimensions 
% are stored as [pixel,stripe]
% 
% returns -1 if unsuccessful, though if any of the low level access
% functions error out, this method will just fail with their error
% descriptions. Only the uint16 pixel datatype feature has been tested, so
% be more cautious than usual if using other datatypes.
%
% There is far more information stored in the SPE header (4100 bytes).
% This simple method only pulls the information that is required for the 
% author's data processing. For further documentation of the header byte 
% structure, seek the sources I used:
%  
%  Matt Clarke's Python Script Description:
%   http://www.scipy.org/Cookbook/Reading_SPE_files
%
%  Stuart B. Wilkins's Python Code:
%   https://pyspec.svn.sourceforge.net/svnroot/pyspec/trunk/pyspec/ccd/files.py 
%
%  ImageJ's plugin to import SPE files, written in Java:
%   http://rsbweb.nih.gov/ij/
%  

% Author: Carl Hall
% Date: June 2012

% Modification History
%  April 2012 - Original Code
%   June 2012 - Modified to maintain output array as same datatype as SPE
%               file

%% SPE Header byte Structure (not fully checked)
% 
% Offset    Bytes    Type     Description
% 0x0000    2        int      Controller Version
% 0x0002    2        int      Logic Output
% 0x0004    2        int      AppHiCapLowNoise
% 0x0006    2        int      dxDim
% 0x0008    2        int      timingMode
% 0x000A    4        float    Exposure
% 0x000E    2        int      vxDim
% 0x0010    2        int      vyDim
% 0x0012    2        int      dyDim
% 0x0014    10       string   Date
% 0x0024    4        float    DetTemperature
% 0x0028    2        int      DectectorType
% 0x002A    2        int      xDim
% 0x002C    2        int      TriggerDiode
% 0x002E    4        float    DelayTime
% 0x0032    2        int      ShutterControl
% 0x0034    2        int      AbsorbLive
% 0x0036    2        int      AbsorbMode
% 0x0038    2        int      canDoVirtualChip
% 0x003A    2        int      thresholdMinLive
% 0x003C    4        float    threshholdMin
% 0x0040    2        int      thresholdMaxLive
% 0x0042    4        float    threshholdMax
% 0x006C    2        int      Data Type
% 0x00AC    7        string   Time
% 0x00BC    2        int      ADCOffset
% 0x00BE    2        int      ADCRate
% 0x00C0    2        int      ADCType
% 0x00C2    2        int      ADCRes
% 0x00C4    2        int      ADCBitAdj
% 0x00C6    2        int      Gain
% 0x00C8    80       string   Comments
% 0x0118    80       string   Comments
% 0x0168    80       string   Comments
% 0x01B8    80       string   Comments
% 0x0208    80       string   Comments
% 0x0258    2        int      GeometricOps
% 0x0290    2        int      ydim
% 0x05A6    2        uint32   zdim
% 0x05D0    2        int      NumROIExperiment
% 0x05D2    2        int      NumROI
% 0x05D4    60       int[]    allROI    
% 
% 0x1004    ...      datatype   Image Data

%% Start of Code

% parse optional input
if nargin>1
    filename = strcat(dirPath,filename);
else
    filename = dirPath;
end

% Open the file
fd = fopen(filename,'r');
if(fd < 0)
    error('Could not open file, bad filename')
end

% Get the image dimensions:
stripDim = getData(fd, '2A', 'uint16');     %first dim
pixelDim = getData(fd, '290', 'uint16');    %second dim
nDim = getData(fd, '5A6', 'uint32');        %third dim

% Get the pixel data type
dataType = getData(fd, '6C', 'uint16');

% Get the image
fseek(fd, hex2dec('1004'), 'bof');

image = zeros([pixelDim,stripDim,nDim]);
switch dataType
    case 0     % single precision float (4 bytes)
        image = single(image);      %maintain datatype in function output
        for i=1:nDim
            image(:,:,i) = fread(fd, [stripDim,pixelDim], 'float32')';
        end
    
    case 1    % long int (4 bytes)
        image = int32(image);
        for i=1:nDim
            image(:,:,i) = fread(fd, [stripDim,pixelDim], 'int32')';
        end
    
    case 2    % short int (2 bytes)
        image = int16(image);
        for i=1:nDim
            image(:,:,i) = fread(fd, [stripDim,pixelDim], 'int16')';
        end
    
    case 3    % short unsigned int (2 bytes)
        image = uint16(image);
        for i=1:nDim
            image(:,:,i) = fread(fd, [stripDim,pixelDim], 'uint16')';
        end

    otherwise
        image = -1;
end
end

%% 
% getData() reads one piece of data at a specific location
% 
function data = getData(fd, hexLoc, dataType)
% Inputs: fd - int    - file descriptor
%     hexLoc - string - location of data relative to beginning of file
%   dataType - string - type of data to be read
%
fseek(fd, hex2dec(hexLoc), 'bof');
data = fread(fd, 1, dataType);
end