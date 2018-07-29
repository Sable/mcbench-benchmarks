%LZW DEMO 1


%   $Author: Giuseppe Ridino' $
%   $Revision: 1.0 $  $Date: 10-May-2004 14:16:08 $


% string to compress
str = '/WED/WE/WEE/WEB/WET';

% pack it
[packed,table]=norm2lzw(uint8(str));

% unpack it
[unpacked,table]=lzw2norm(packed);

% transfor it back to char array
unpacked = char(unpacked);

% test
isOK = strcmp(str,unpacked)

% show new table elements
strvcat(table{257:end})