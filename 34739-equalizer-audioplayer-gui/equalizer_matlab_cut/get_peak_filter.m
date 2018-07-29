function [b a]=get_peak_filter(g,Q,f,Fs)

A=10^(g/40);
w=2*pi*f/Fs;
sn=sin(w);
cs=cos(w);
al=sn/(2*Q);

b=[1+al*A   -2*cs   1-al*A];
a=[1+al/A   -2*cs   1-al/A];

b=b/a(1);
a=a/a(1);