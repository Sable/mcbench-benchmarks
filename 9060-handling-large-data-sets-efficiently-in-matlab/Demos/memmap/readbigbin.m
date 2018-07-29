filename='waferdata.bin';

%% Open
fid=fopen(filename,'rb');
NumRows=1e3;

%% Write Header
a=fread(fid,20*NumRows,'*uint8' );
a=reshape(a,20,NumRows);

%% Close
fclose(fid);
disp('Finished');
