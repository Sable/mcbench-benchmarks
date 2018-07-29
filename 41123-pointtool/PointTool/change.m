function change(file)
[np,nf]=num(file);
fprintf('Number_of_point:%d\n',np);
fprintf('Number_of_face:%d\n',nf);
fid=fopen('OFF','w');
fprintf(fid,'OFF\n');
fprintf(fid,'%d %d 0\n',np,nf);
fid2=fopen(file);
H=0;
while 1 
    tline=fgetl(fid2);
    H=H+1;
    if ~ischar(tline) , break , end 
    if H > 1
        disp(tline)
        fprintf(fid,'%s\n',tline);
    end
    
end
fclose(fid2);
fclose(fid);
function [np,nf]=num(file)
fid=fopen(file);
C=0;
while 1 
    tline=fgetl(fid);
    C=C+1;
    if C==1
        num=textscan(tline,'%s %d %d %d'); 
        break;
    end
     if ~ischar(tline) , break , end 
   
        
   
   
end
fclose(fid);
np=num{1,2};
nf=num{1,3};

