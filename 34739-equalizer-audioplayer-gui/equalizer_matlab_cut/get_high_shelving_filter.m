function [b a]=get_high_shelving_filter(g,Q,f,Fs)

A=10^(g/40);
w=2*pi*f/Fs;
sn=sin(w);
cs=cos(w);
al=sn/(2*Q);
bt=sqrt(A)/Q;

b=A*[(A+1)+(A-1)*cs+bt*sn,...
   -2*((A-1)+(A+1)*cs),...
   (A+1)+(A-1)*cs-bt*sn];



a=[(A+1)-(A-1)*cs+bt*sn,...
   2*((A-1)-(A+1)*cs),...
   (A+1)-(A-1)*cs-bt*sn];



b=b/a(1);
a=a/a(1);