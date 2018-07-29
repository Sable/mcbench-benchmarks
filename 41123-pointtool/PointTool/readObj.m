%This function develop by Renoald Tang
%University Teknologi Malaysia, Photogrammetry and Laser scanning group
%for academic purpose
%Email:renoald@live.com
%This function read Obj file
function readObj(File)
[C,D]=num(File);
fprintf('Number_of_point:%d\n',C);
fprintf('Number_of_face:%d\n',D);
function [C,D]=num(File)
C=0;
D=0;
fid=fopen(File);
fid1=fopen('point','w');
fid2=fopen('face','w');
while 1
   tline = fgetl(fid); 
   ext1=findstr(tline,'#'); 
    if ~ischar(tline),   break,   end
    n1=isempty(ext1);
     if n1~=0 
         n=length(tline);
         if n > 0 
             V=tline(1,1);
              if V=='v'
             C=C+1;
             fprintf(fid1,'%s\n',tline(2:n));
             %disp(tline(2:n))
            %disp(C)
              end
         if V=='f'
             D=D+1;
            
             fprintf(fid2,'3 %s\n',tline(2:n));
             %disp(D)
         end
         end   
     end
end
fclose(fid);
fclose(fid1);
fclose(fid2);
p=dlmread('face');
n=length(p);
for i=1 : n
    p(i,2)=p(i,2)-1;
    p(i,3)=p(i,3)-1;
    p(i,4)=p(i,4)-1;
end
fid3=fopen('face','w');
for i=1 : n 
    fprintf(fid3,'%d %d %d %d\n',p(i,1),p(i,2),p(i,3),p(i,4));
end
fclose(fid3);

