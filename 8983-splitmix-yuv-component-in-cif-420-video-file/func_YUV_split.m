function func_YUV_split
% Objective: extract YUV components from the CIF 4:2:0 video file, that is,
% split CIF file into three files, i.e., .Y, .U, .V.
%
% Jing Tian
% Contact: scuteejtian@hotmail.com
% This program is written in 2005 during my postgraduate studying in 
% NTU, Singapore.

in_file_name = 'test.cif'
nFrame = 10;

[fid1 message]= fopen(in_file_name,'rb');

if length(strfind(in_file_name, '.qcif')) == 0
    nRow = 288;
    nColumn = 352;
    in_file_name2 = strrep(in_file_name, '.cif', '.Y');
    [fid2 message]= fopen(in_file_name2,'w');
    in_file_name3 = strrep(in_file_name, '.cif', '.U');
    [fid3 message]= fopen(in_file_name3,'w');
    in_file_name4 = strrep(in_file_name, '.cif', '.V');
    [fid4 message]= fopen(in_file_name4,'w');
else
    nRow = 288 / 2;
    nColumn = 352 / 2;
    in_file_name2 = strrep(in_file_name, '.qcif', '.Y');
    [fid2 message]= fopen(in_file_name2,'w');
    in_file_name3 = strrep(in_file_name, '.qcif', '.U');
    [fid3 message]= fopen(in_file_name3,'w');
    in_file_name4 = strrep(in_file_name, '.qcif', '.V');
    [fid4 message]= fopen(in_file_name4,'w');
end

for i = 1: nFrame
    %reading Y component 
	img_y = fread(fid1, nRow * nColumn, 'uchar');
    img_y = reshape(img_y, nColumn, nRow);
    img_y = img_y';
    %reading U component  
    img_u = fread(fid1, nRow * nColumn / 4, 'uchar');
    img_u = reshape(img_u, nColumn/2, nRow/2);
    img_u = img_u';
    %reading V component
    img_v = fread(fid1, nRow * nColumn / 4, 'uchar');
    img_v = reshape(img_v, nColumn/2, nRow/2);
    img_v = img_v';
    %writing file
	count = fwrite(fid2, img_y', 'uchar');
	count = fwrite(fid3, img_u', 'uchar');
	count = fwrite(fid4, img_v', 'uchar');    
end

fclose(fid1);
fclose(fid2);
fclose(fid3);
fclose(fid4);

disp('ok');