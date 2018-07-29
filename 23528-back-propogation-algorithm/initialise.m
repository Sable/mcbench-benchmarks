function [W,B,delw]=initialise(l,no)

for k=1:l-1
     for i=1:no(k)
         for j=1:no(k+1)
             W(i,j,k)=rand-0.5;
             delw(i,j,k)=0;
         end;
     end;
 end;
 disp('initial Weight Matrix W= ');
 disp(W);
 
for k=2:l
    for i=1:no(k)
          B(i,k)=rand;
          delb(i,k)=0;
     end
end
%disp('Initial bias matrix is')
%disp(B);
 
