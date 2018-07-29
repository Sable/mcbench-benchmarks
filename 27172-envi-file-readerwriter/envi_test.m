%test script
clearvars

D=rand(2,3,4)+j*rand(2,3,4);
info=enviinfo(D);
enviwrite(D,info,'a.dat');

[D2,info2]=enviread('a.dat');

isequal(D,D2)
isequal(info,info2)

info3=info2;
info3.header_offset=10000;
D3=D2;
enviwrite(D3,info3,'a3.dat');

[D3a,info3a]=enviread('a3.dat');

isequal(D3,D3a)
isequal(info3,info3a)




