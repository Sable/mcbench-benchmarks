function [X,names]=elipsod
% [X,names]=elipsod defines ellipsoidal
% coordinates with 0 < lm < b,
% b < t < c, and c < e <infinity
syms e t lm real 
names=[lm,t,e];
b=1; c=2*b; b2=b^2; c2=c^2; cb=c2-b2;
x=e*t*lm/(b*c); 
y=sqrt((e^2-b2)*(t^2-b2)*...
    (b2-lm^2)/(b2*cb));
z=sqrt((e^2-c2)*(c2-t^2)*...
     (c2-lm^2)/(c2*cb));
X=[x;y;z];