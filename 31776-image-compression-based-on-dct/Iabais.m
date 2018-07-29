function h=Iabais(x)
L=length(x);
k=1;
i=1;
while i<=L/2
   h(i)=x(k)*256+x(k+1);
     k=k+2;
   i=i+1;
end;
   