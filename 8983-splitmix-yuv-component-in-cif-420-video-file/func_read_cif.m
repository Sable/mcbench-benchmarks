function func_read_cif
% Objective: read CIF 4:2:0 video file and show the Y component
% continuously.
%
% Jing Tian
% Contact: scuteejtian@hotmail.com
% This program is written in 2005 during my postgraduate studying in 
% NTU, Singapore.

in_file_name = 'test.cif';
nFrame = 10;

[fid message]= fopen(in_file_name,'rb');
if length(strfind(in_file_name, '.qcif')) == 0
    nRow = 288;
    nColumn = 352;
else
    nRow = 288 / 2;
    nColumn = 352 / 2;
end

for i = 1: nFrame
    %reading Y component 
	img_y = fread(fid, nRow * nColumn, 'uchar');
    img_y = reshape(img_y, nColumn, nRow);
    img_y = img_y';
    imshow(uint8(img_y));
    
    %reading U component    
    img_u = fread(fid, nRow * nColumn / 4, 'uchar');
    img_u = reshape(img_u, nColumn/2, nRow/2);
    img_u = img_u';

    %reading V component
    img_v = fread(fid, nRow * nColumn / 4, 'uchar');
    img_v = reshape(img_v, nColumn/2, nRow/2);
    img_v = img_v';

end

fclose(fid);
disp('ok');
