function func_YUV_mix
% Objective: mix YUV components to generate the CIF 4:2:0 video file, that
% is, split CIF file into three files, i.e., .Y, .U, .V.
%
% Jing Tian
% Contact: scuteejtian@hotmail.com
% This program is written in 2005 during my postgraduate studying in 
% NTU, Singapore.

in_file_name1 = 'test.Y';
in_file_name2 = 'test.U';
in_file_name3 = 'test.V';
in_file_name4 = 'test_combined.cif';
nFrame = 10;

[fid1 message]= fopen(in_file_name1,'rb');
[fid2 message]= fopen(in_file_name2,'rb');
[fid3 message]= fopen(in_file_name3,'rb');
[fid4 message]= fopen(in_file_name4,'w');

if length(strfind(in_file_name4, 'qcif')) == 0
    nRow = 288;
    nColumn = 352;
else
    nRow = 288 / 2;
    nColumn = 352 / 2;
end

for i = 1: nFrame
    %reading Y component 
	img_y = fread(fid1, nRow * nColumn, 'uchar');
    %reading U component  
    img_u = fread(fid2, nRow * nColumn / 4, 'uchar');
    %reading V component
    img_v = fread(fid3, nRow * nColumn / 4, 'uchar');

    %writing file
	count = fwrite(fid4, img_y, 'uchar');
	count = fwrite(fid4, img_u, 'uchar');
	count = fwrite(fid4, img_v, 'uchar');        
end

fclose(fid1);
fclose(fid2);
fclose(fid3);
fclose(fid4);

disp('ok');