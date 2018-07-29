function [rtab,info]=routh0(den)
info=[]; 
vec1=den(1:2:length(den)); nrT=length(vec1);
vec2=den(2:2:length(den)-1); 
rtab=[vec1; vec2, zeros(1,nrT-length(vec2))];
for k=1:length(den)-2, 
   alpha(k)=vec1(1)/vec2(1); 
   for i=1:length(vec2),
       a3(i)=rtab(k,i+1)-alpha(k)*rtab(k+1,i+1);
   end
   if sum(abs(a3))==0
      a3=polyder(vec2);
      info=[info,'All elements in row ',...
            int2str(k+2) ' are zeros;'];
   elseif abs(a3(1))<eps
      a3(1)=1e-6; 
      info=[info,'Replaced first element;'];
   end 
   rtab=[rtab; a3, zeros(1,nrT-length(a3))];
   vec1=vec2; vec2=a3;
end
