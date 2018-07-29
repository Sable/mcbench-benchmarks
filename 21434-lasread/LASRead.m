
function outfile = LASRead (infilename,outfilename,nFields)
% LASREAD reads in files in LAS 1.1 format and outputs comma delimited text files
%
% INPUT
% infilename:   input file name in LAS 1.1 format 
%               (for example, 'myinfile.las') 
% outfilename:  output file name in text format 
%               (for example, 'myoutfile.txt')
% nFields:      default value of 1 outputs X, Y and Z coordinates of the 
%               point - [X Y Z]. 
%               A value of 2 gives Intensity as an additional attribute - [X Y Z I].
%               A value of 3 gives the Return number and the Number of returns 
%               in addition to the above - [X Y Z I R N].                
%           
% OUTPUT
% outfile:      the output matrix
% 
% EXAMPLE
% A = LASRead ('infile.las', 'outfile.txt', 3)
%
% Cici Alexander
% September 2008 (updated 26.09.2008)

% Open the file
fid =fopen(infilename);

% Check whether the file is valid
if fid == -1
    error('Error opening file')
end

% Check whether the LAS format is 1.1
fseek(fid, 24, 'bof');
VersionMajor = fread(fid,1,'uchar');
VersionMinor = fread(fid,1,'uchar');
if VersionMajor ~= 1 || VersionMinor ~= 1
    error('LAS format is not 1.1')
end

% Read in the offset to point data
fseek(fid, 96, 'bof');
OffsetToPointData = fread(fid,1,'uint32');

% Read in the scale factors and offsets required to calculate the coordinates
fseek(fid, 131, 'bof');
XScaleFactor = fread(fid,1,'double');
YScaleFactor = fread(fid,1,'double');
ZScaleFactor = fread(fid,1,'double');
XOffset = fread(fid,1,'double');
YOffset = fread(fid,1,'double');
ZOffset = fread(fid,1,'double');

% The number of bytes from the beginning of the file to the first point record
% data field is used to access the attributes of the point data
%
c = OffsetToPointData;

% If nfields is not given, the default value is taken as 1
%
if nargin == 2
    nFields = 1;
end

% Read in the X coordinates of the points
%
% Reads in the X coordinates of the points making use of the 
% XScaleFactor and XOffset values in the header.
fseek(fid, c, 'bof');
X1=fread(fid,inf,'int32',24);
X=X1*XScaleFactor+XOffset;

% Read in the Y coordinates of the points
fseek(fid, c+4, 'bof');
Y1=fread(fid,inf,'int32',24);
Y=Y1*YScaleFactor+YOffset;

% Read in the Z coordinates of the points
fseek(fid, c+8, 'bof');
Z1=fread(fid,inf,'int32',24);
Z=Z1*ZScaleFactor+ZOffset;

if nFields > 1
% Read in the Intensity values of the points
fseek(fid, c+12, 'bof');
Int=fread(fid,inf,'uint16',26);

if nFields >2
% Read in the Return Number of the points. The first return will have a
% return number of one, the second, two, etc.
fseek(fid, c+14, 'bof');
Rnum=fread(fid,inf,'bit3',221);

% Read in the Number of Returns for a given pulse.
fseek(fid, c+14, 'bof');
fread(fid,1,'bit3');
Num=fread(fid,inf,'bit3',221);

end
end

%Write out the file with X, Y and Z coordinates, Intensity, Return Number 
% and Number of Returns depending on the fields specified in the input 
if nFields == 1
outfileheader = ['X' 'Y' 'Z'];
outfile = [X Y Z];
elseif nFields == 2
outfileheader = ['X' 'Y' 'Z' 'I'];
outfile = [X Y Z Int]; 
elseif nFields == 3
outfileheader = ['X' 'Y' 'Z' 'I' 'R' 'N'];
outfile = [X Y Z Int Rnum Num];
end

dlmwrite(outfilename,outfileheader);
dlmwrite(outfilename,outfile, '-append','precision','%.2f','newline','pc');
