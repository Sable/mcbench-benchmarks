%This function check benmark and return benmark value 
%This program write by Renoald
%Any questions or error in this program please email to Renoald@live.com
function [ben,V]=benmark(file)
fid=fopen(file);
C=0;
while 1 
 tline = fgetl(fid);
    if ~ischar(tline),   break,   end
    di=findstr(tline,'B');  
    V=isempty(di);
    
    if V ~=1
        C=C+1;
        %disp(tline)
       S=textscan(tline,'%s %s %n');
      ben(C)=S{1,2};
      V1(C)=S{1,3};
    end
end   
   fclose(fid); 
   V=V1';
end
