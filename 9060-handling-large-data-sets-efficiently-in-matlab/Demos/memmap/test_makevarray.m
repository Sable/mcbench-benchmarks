%% Create function pointer
%f=makevarray('waferdata_uint8_2.bin','uint8');
f=VirtualArray('waferdata_uint8_2.bin','uint8',100,5)

%% Access elements 1:5
f(1:5)'

%% Access elements 1,000,001:1,000,005
f(1e6+(1:5))'

%% Access elements 3,000,000,001:3,000,000,005
f(3e9+(1:5))'