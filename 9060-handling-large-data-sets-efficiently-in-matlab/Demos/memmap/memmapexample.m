%% Map with default settings
% Homogeneous uint8 binary file
m=memmapfile('waferdata_uint8.bin')

%% Notice Data size==file size
fileinfo=dir('waferdata_uint8.bin');
fileinfo.bytes

%% We can access the file like it is an array
m.Data(1:20)' % First few elements

%% Copy a piece an make it look like it was stored
a=reshape(m.Data(1:100),20,5)'; 

%% Access some in the middle
m.Data(2^20:2^20+20)' % some in the middle

%% We can map the first 1MB
m.repeat=2^20 % Only one megabyte

%% Or the second MB
m.offset=2^20 %only one megabyte

%% Write to it
m.writable=true
m.Data(5)=100;
m.Data(1:20)' 

%% Treat as n ND array
m=memmapfile('waferdata_uint8.bin','format',{'uint8' [20 100] 'x'},'repeat',20*1000)
% See it defaults to mapping the whole file as uint 8
A=m.Data;

%% Change format
m.format={'uint8' [1 4] 'headerbits';...
          'uint8' [4 9] 'middle';...
          'uint8' [7 1] 'tail'};
A=m.Data
m.Data(1).headerbits