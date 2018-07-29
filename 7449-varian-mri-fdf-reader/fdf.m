function img = fdf
% m-file that can open Varian FDF imaging files in Matlab.
% Usage: img = fdf;
% Your image data will be loaded into img
%
% Shanrong Zhang
% Department of Radiology
% University of Washington
% 
% email: zhangs@u.washington.edu
% Date: 12/19/2004
% 
% Fix Issue so it is able to open both old Unix-based and new Linux-based FDF
% Date: 11/22/2007
%

warning off MATLAB:divideByZero;

[filename pathname] = uigetfile('*.fdf','Please select a fdf file');

[fid] = fopen([pathname filename],'r');

num = 0;
done = false;
machineformat = 'ieee-be'; % Old Unix-based  
line = fgetl(fid);
disp(line)
while (~isempty(line) && ~done)
    line = fgetl(fid)
    % disp(line)
    if strmatch('int    bigendian', line)
        machineformat = 'ieee-le'; % New Linux-based    
    end
    
    if strmatch('float  matrix[] = ', line)
        [token, rem] = strtok(line,'float  matrix[] = { , };');
        M(1) = str2num(token);
        M(2) = str2num(strtok(rem,', };'));
    end
    if strmatch('float  bits = ', line)
        [token, rem] = strtok(line,'float  bits = { , };');
        bits = str2num(token);
    end

    num = num + 1;
    
    if num > 41
        done = true;
    end
end

skip = fseek(fid, -M(1)*M(2)*bits/8, 'eof');

img = fread(fid, [M(1), M(2)], 'float32', machineformat);

img = img';
figure;
imshow(img, []); 
colormap(gray);
axis image;
axis off;
fclose(fid);

% end of m-code
