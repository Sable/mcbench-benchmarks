%This function check station and return stationvalue 
%This program write by Renoald
%Any questions or error in this program please email to Renoald@live.com
function [sta1,sta2,V,std]=station(file)
fid=fopen(file);
C=0;
while 1 
 tline = fgetl(fid);
    if ~ischar(tline),   break,   end
    di=findstr(tline,'S');  
    V=isempty(di);
    
    if V ~=1
        C=C+1;
        %disp(tline)
       S=textscan(tline,'%s %s %s %n %n');
      sta1(C)=S{1,2};
      sta2(C)=S{1,3};
      V1(C)=S{1,4};
      std1(C)=S{1,5};
    end
end   
   fclose(fid); 
   V=V1';
   std=std1';
end
