function [rtab,msg]=relrouth(den,ss)
n=length(den)-1; rpoly=1; rden=den(n+1);
for i=1:n
   rpoly=conv(rpoly,[1,ss]);
   rden=[0,rden]+den(n+1-i)*rpoly;
end
[rtab,msg]=routh(rden); 
