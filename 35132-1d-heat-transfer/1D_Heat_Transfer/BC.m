function [pl,ql,pr,qr]=BC(xl,ul,xr,ur,t)
global T0 T1

ql=0;
pl=ul-T0;
qr=0;
pr=ur-T1;
