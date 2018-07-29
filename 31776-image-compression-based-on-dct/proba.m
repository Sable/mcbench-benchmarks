function [sim,vfreq]=proba(x)
L=length(x);
xmax=max(x);
vect=0:xmax;
k=1;
Nb=0;
for j=1:xmax+1
    for i=1:L
        if vect(j)==x(i)
            Nb=Nb+1;
        end;
    end;
     sim(k)=vect(j);
        vfreq(k)=Nb+1;
        k=k+1;
         Nb=0;
       
   end;


