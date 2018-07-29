%This function develop by Renoald Tang
%University Teknologi Malaysia, Photogrammetry and Laser scanning group
%for academic purpose
%Email:renoald@live.com
%This function read Off file
function readOFF(file)
[np,nf]=value(file);
fprintf('Number_of_point:%d\n',np);
fprintf('Number_of_face:%d\n',nf);
ext(file,np);


%return number of face and point
function [np,nf]=value(file)
C=0;
fid=fopen(file);
while 1
    tline = fgetl(fid);
    C=C+1;
    if C==2 
        
      num=textscan(tline,'%d %d %d'); 
        break;
    end
    if ~ischar(tline),   break,   end
    
end
fclose(fid);
np=num{1,1};
nf=num{1,2};
function ext(file,n)
C=0;
K=0;
fid=fopen(file);
fid1=fopen('point','w');
fid2=fopen('face','w');
while 1 
    tline=fgetl(fid);
    C=C+1;
     if ~ischar(tline) , break , end 
    if C > 2 
       K=K+1; 
       if K <=n
           fprintf(fid1,'%s\n',tline);
       else
           fprintf(fid2,'%s\n',tline);
       end
        
    end
   
end
fclose(fid);
fclose(fid1);
fclose(fid2);%return and extract face and point value
%disp(K)
