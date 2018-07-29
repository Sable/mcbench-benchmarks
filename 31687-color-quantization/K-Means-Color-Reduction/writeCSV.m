%Program for creating CSV File

%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/

%Program Description
%This program generates a CSV file containing the colors in the output image.
%The CSV format is as follows
%PaletteNumber  R   G   B

function writeCSV(out_map, OutCSVName)

s = size(out_map);
fid = fopen(OutCSVName,'w');
for i=1:s(1)
    fprintf(fid,'%d,',i); %Palette No.
    for j=1:s(2)
        fprintf(fid,'%d,',double(out_map(i,j)));
    end
    fprintf(fid,'\n');
end
fclose(fid);