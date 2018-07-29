%% Create virtual array

%% bum file test
f=VirtualArray('dummy.bin');

%% Simeple 1D
f=VirtualArray('waferdata_uint8_2.bin');
f(1)
f(1:10)
f(1e9)

%% Specify Data type
f=VirtualArray('waferdata_uint8_2.bin','int8');
f(1)'
f(1:10)'
f(1e9)'
f(1e9:1e9+20)'
clear f

%% 2D full file
f=VirtualArray('waferdata_uint8_2.bin','uint8',10);
f(1:20)
f(1,2)
f(1:5,2)
clear f


%% 2D part file
f=VirtualArray('waferdata_uint8_2.bin','uint8',10,5);
f(1:20)
f(1,2)
f(1:5,2)
clear f

%% Specify num rows
f=VirtualArray('waferdata_uint8_2.bin','uint8',100);
f(1)
f(1:10)
f(1e9)
f(1e9:1e9+20)
f(1:3,4)
clear f

%% Specify num columns
f=VirtualArray('waferdata_uint8_2.bin','uint8',100,5);
clear f





%% Access elements 1:5
f(1:5)'

%% Access elements 1,000,001:1,000,005
f(1e6+(1:5))'

%% Access elements 3,000,000,001:3,000,000,005
f(3e9+(1:5))'