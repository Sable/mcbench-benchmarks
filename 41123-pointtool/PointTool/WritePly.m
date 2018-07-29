%This function develop by Renoald Tang
%University Teknologi Malaysia, Photogrammetry and Laser scanning group
%for academic purpose
%Email:renoald@live.com
%This function read Write Ply file
function WritePly(file)
fid=fopen(file,'w');
f=dlmread('face');
p=dlmread('point');
nn=length(p);
nnn=length(f);
L=10;
%h = waitbar(0,'Writing Comment','name','file saving');
fprintf(fid,'ply\n');
%waitbar(1/L,h,'1 % finish');
fprintf(fid,'format ascii 1.0\n');
%waitbar(2/L,h,'2 % finish');
fprintf(fid,'comment VCGLB generated\n');
%waitbar(3/L,h,'3 % finish');
fprintf(fid,'element vertex %d\n',length(p));
%waitbar(4/L,h,'4 % finish');
fprintf(fid,'property float x\n');
%waitbar(5/L,h,'5% finish');
fprintf(fid,'property float y\n');
%waitbar(6/L,h,'6 % finish');
fprintf(fid,'property float z\n');
%waitbar(7/L,h,'7 % finish');
fprintf(fid,'element face %d\n',length(f));
%waitbar(8/L,h,'8 % finish');
fprintf(fid,'property list uchar int vertex_indices\n');
%waitbar(9/L,h,'9 % finish');
fprintf(fid,'end_header\n');
%waitbar(10/L,h,'10 % finish');
%close(h)
PP=0;
fid1=fopen('point');
while 1
    tline = fgetl(fid1);
    PP=PP+1;
    if ~ischar(tline),   break,   end
    %chr=strcat(num2str(PP+10/L) ,'% finish');
    %waitbar(PP+10/L,h,chr);
    disp(tline)
    fprintf(fid,'%s \n',tline);

end
fclose(fid1);
CC=dlmread('face');
n=length(CC);
for i=1 : n 
    C1=renum(CC(i,:));
    fprintf(fid,'%s\n',num2str(C1));
     %cjj=strcat(num2str(C1) ,'% finish');
    %waitbar(i+nn/L,h,cjj);
end 


fclose(fid);
disp('File is finish convert');
