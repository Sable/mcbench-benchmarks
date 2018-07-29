%This function develop by Renoald Tang
%University Teknologi Malaysia, Photogrammetry and Laser scanning group
%for academic purpose
%Email:renoald@live.com
%This function write Off file
function WriteOFF(file)
fid=fopen(file,'w');
fprintf(fid,'OFF\n');
p=dlmread('face');
f=dlmread('point');
n=length(p);
n1=length(f);
fprintf(fid,'%d %d 0\n',n1,n);
fid1=fopen('point');
while 1
    tline = fgetl(fid1);
    if ~ischar(tline),   break,   end
    disp(tline)
    fprintf(fid,'%s\n',tline);
end
fclose(fid1);
CC=dlmread('face');
n=length(CC);
for i=1 : n 
    C1=renum(CC(i,:));
    fprintf(fid,'%s\n',num2str(C1));
end 
fclose(fid);
disp('File is finish convert')