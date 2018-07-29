%This function develop by Renoald Tang
%University Teknologi Malaysia, Photogrammetry and Laser scanning group
%for academic purpose
%Email:renoald@live.com
%This function read Write XYZ file
function WriteXYZ(file)
fid=fopen(file,'w');
p=dlmread('point');
n=length(p);
for i=1 : n 
    disp(i)
    fprintf(fid,'%.5f %.5f %.5f\n',p(i,1),p(i,2),p(i,3));
end
fclose(fid);

