function [ header ] = ffawritesubset( filename, header, data )
%
%
%   Writes out an the specified data to a .ffa file.
%
%   The return header will contain the raw header string written
%   and the numvoxels field will indicate the number actually written

if nargin ~= 3
    disp('Wrong number of arguments')
    return
end


if isempty(filename)
    disp('A filename must be specified')
    return
end


fid = fopen( filename, 'w' );

%
%   Write the header information
%
header.raw = [];

TAB = char(9);
SEMICOLON = char(59);
LINEFEED = char(10);
ENDHEADER = 'ENDHEADER.';
MAGIC = hex2dec( 'abc2' );

header.raw = [ 'FFAID:' TAB num2str(header.ffaid) SEMICOLON LINEFEED ];
header.raw = [ header.raw 'SIGNFLAG:' TAB num2str(header.signflag) TAB SEMICOLON LINEFEED ];
header.raw = [ header.raw 'FLOATFLAG:' TAB num2str(header.floatflag) TAB SEMICOLON LINEFEED ];
header.raw = [ header.raw 'DATABITS:' TAB num2str(header.databits) TAB SEMICOLON LINEFEED ];
header.raw = [ header.raw 'VOXELBITS:' TAB num2str(header.voxelbits) TAB SEMICOLON LINEFEED ];
header.raw = [ header.raw 'NUMDIMS:' TAB num2str(header.numdims) TAB SEMICOLON LINEFEED ];
header.raw = [ header.raw 'SIZE[]:' TAB num2str(header.size(1)) TAB SEMICOLON LINEFEED ...
                TAB num2str(header.size(2)) TAB SEMICOLON LINEFEED TAB num2str(header.size(3)) TAB SEMICOLON LINEFEED ];
            
header.raw = [ header.raw 'ORIGIN[]:' TAB num2str(header.origin(1)) TAB SEMICOLON LINEFEED ...
                TAB num2str(header.origin(2)) TAB SEMICOLON LINEFEED TAB num2str(header.origin(3)) TAB SEMICOLON LINEFEED ];
            
header.raw = [ header.raw 'LABEL[]:' TAB header.label.x TAB SEMICOLON LINEFEED TAB header.label.y ...
                TAB SEMICOLON LINEFEED TAB header.label.z TAB SEMICOLON LINEFEED ];

header.raw = [ header.raw 'SCALE[]:' TAB num2str(header.scale(1)) TAB SEMICOLON LINEFEED TAB num2str(header.scale(2)) TAB ...
                SEMICOLON LINEFEED TAB num2str(header.scale(3)) TAB SEMICOLON LINEFEED ];
            
header.raw = [ header.raw 'UNITNAME[]:' TAB header.unitname.x TAB SEMICOLON LINEFEED TAB header.unitname.y TAB ...
                SEMICOLON LINEFEED TAB header.unitname.z TAB SEMICOLON LINEFEED ];

            
len = length( header.raw );
diff = 589 - len;

while ( diff > 0 )
    header.raw = [ header.raw LINEFEED ];
    diff = diff - 1;
end
header.raw = [ header.raw ENDHEADER LINEFEED ];
hdrcount = fwrite(fid, header.raw, 'char');
   

%
%   Write the magic number
%
fwrite(fid, MAGIC, 'int32');


%
%   Write the data
%
precision = ffahdr2precision( header );

%data = fliplr(data);

if (header.scale(1) < 0)
  data = flipdim(data,1);
end

if (header.scale(2) < 0)
  data = flipdim(data,2);
end

if (header.scale(3) < 0)
  data = flipdim(data,3);
end

for i=1:1:header.size(3)
    disp(i);
    d = reshape(data(:,:,i),[1 numel(data(:,:,i))]);
    fwrite(fid, d, precision );
end

header.numvoxels= numel(data);

fclose(fid);










