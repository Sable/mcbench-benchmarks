function h=abais(x)
L=length(x);
k=1;
i=1;
while i<=L
   h(k)=fix(x(i)/256);
   h(k+1)=mod(x(i),256);
   k=k+2;
   i=i+1;
end;
   