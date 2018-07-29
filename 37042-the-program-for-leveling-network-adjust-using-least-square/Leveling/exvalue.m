%return leveling value
%This program write by Renoald
%Any questions or error in this program please email to Renoald@live.com
function [stn1,stn2,v,std]=exvalue(file)

fid=fopen(file);
C=0;
while 1 
  tline = fgetl(fid);
    if ~ischar(tline),   break,   end
    di=findstr(tline,'S');  
    V=isempty(di);
    if V ~=1
        C=C+1;
     S=textscan(tline,'%s %n %n %n %n');
     stn1(C)=S{1,2};
     stn2(C)=S{1,3};
     v(C)=S{1,4};
     std(C)=S{1,5};
    end
end
fclose(fid);