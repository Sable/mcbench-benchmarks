%This function develop by Renoald Tang
%University Teknologi Malaysia, Photogrammetry and Laser scanning group
%for academic purpose
%Email:renoald@live.com
%This function read Ply file

function readPly(file)
nv=numvert(file);
fprintf('Number_of_point:%d\n',nv);
nh=numhead(file);
fprintf('Number of end line:%d\n',nh);
nf=numface(file,nh);
fprintf('Number_of_face:%d\n',nf);
value(nh,file,nv)



%return number of vertext
function nv=numvert(file)
C=0;
fid=fopen(file);
while 1
    tline = fgetl(fid);
    C=C+1;
    if C==4 
        
      num=textscan(tline,'%s %s %d'); 
        break;
    end
    if ~ischar(tline),   break,   end
    
end
fclose(fid);
nv=num{1,3};
%return number of face
function nf=numface(file,nh)
nh=nh-2;
C=0;
fid=fopen(file);
while 1
    tline = fgetl(fid);
    C=C+1;
     if ~ischar(tline),   break,   end
    
    if C==nh
       
      num=textscan(tline,'%s %s %d'); 
        break;
    end
   
    
end
fclose(fid);
nf=num{1,3};
%return the number of end_hearder
function nh=numhead(file)
C=0;
fid=fopen(file);
while 1
    tline = fgetl(fid);
    C=C+1;
    map1=findstr(tline,'end_header');
  b1=isempty(map1);
  if b1==0
      nh=C;
    
      break;
  end
    
    if ~ischar(tline),   break,   end
    
end
fclose(fid);
function value(nh,file,n)
%[K1,R]=check(file);
C=0;
K=0;
fid=fopen(file);
fid1=fopen('point','w');
fid2=fopen('face','w');
while 1 
    tline=fgetl(fid);
    C=C+1;
     if ~ischar(tline) , break , end 
    if C > nh
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
