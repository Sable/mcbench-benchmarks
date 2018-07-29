function [rtnData, headData] = isfread (filename)
% isfread - will read the .ISF files produced by TEK TDS oscilloscopes
%
% useage:   [rtnData, headData] = isfread ('filename')
% where:    rtnData     - is a struct with the x and y data returned in 
%                         rtnData.x and rtnData.y respectively 
%           headData    - is a struct with all the header data returned in
%                         different fields
%           'filename'  - is a string with the name of the file to be
%                         extracted
%
% Example:  filename = 'TEK00000.ISF';
%           [data, header] = isfread (filename);
%           plot(data.x,data.y)
%
% The returned data is pre scaled using the information contained in the
% header of the ISF file.
%
% * Written 17/8/2004 by John Lipp - CCLRC Rutherford Appleton Laboratory *


fileID = fopen(filename,'r');

% read ASCII header
header_tmp = fread(fileID,267)';
header = char(header_tmp);

headData = parseHead(header);

% read binary data
inData = fread(fileID, headData.NR_PT, 'int16');

lowerXLimit = headData.XZERO;
upperXLimit = ((headData.NR_PT-1)* headData.XINCR  + headData.XZERO);
rtnData.x = [lowerXLimit:headData.XINCR:upperXLimit]';

rtnData.y = headData.YMULT*(inData-headData.YOFF);




% parseHead - used to parse and convert the header data into a more
% useful structure.
function headData = parseHead(header)

[headData.TYPE,rem] = strtok(header,':') ;

[headData.BYT_NR, rem] = getNextNum(rem); 
[headData.BIT_NR, rem] = getNextNum(rem); 
[headData.ENCDG,rem] = getNextStr(rem) ;
[headData.BN_FMT,rem] = getNextStr(rem) ;
[headData.BYT_OR,rem] = getNextStr(rem) ;
[headData.NR_PT, rem] = getNextNum(rem);
[headData.WFID,rem] = getNextStr(rem) ;
[headData.PT_FMT,rem] = getNextStr(rem) ;
[headData.XINCR, rem] = getNextNum(rem);
[headData.PT_OFF, rem] = getNextNum(rem);
[headData.XZERO, rem] = getNextNum(rem);
[headData.XUNIT,rem] = getNextStr(rem) ;
[headData.YMULT, rem] = getNextNum(rem);
[headData.YZERO, rem] = getNextNum(rem);
[headData.YOFF, rem] = getNextNum(rem); 
[headData.YUNIT,rem] = getNextStr(rem) ;
[headData.CURVE,rem] = getNextStr(rem) ;


function [rtnNum, remStr] = getNextNum (string)
[junk,rem] = strtok(string,' ');
[tmp, remStr] = strtok(rem,';') ;
rtnNum = str2num(tmp);

function [rtnStr, remStr] = getNextStr(string)
[junk,rem] = strtok(string,' ');
rem = strtrim(rem);             % remove padding white space
[rtnStr,remStr] = strtok(rem,';') ;