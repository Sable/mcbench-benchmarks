function [xh,x,t]=simobsv(G,H)
[y,t,x]=step(G);
G=ss(G); A=G.a; B=G.b; C=G.c; D=G.d; 
[y1,xh1]=step((A-H*C),(B-H*D),C,D,1,t);
[y2,xh2]=lsim((A-H*C),H,C,D,y,t);
xh=xh1+xh2;
