function [T1 T2 T4 d3]=Scara_Inverse(X,Y,Z,d1,d2,a1,a2)
 
rsqr=((X^2+Y^2-a1^2-a2^2)/(2*a1*a2));
 
theata2=acos(rsqr);
theata1=atan2(Y,X)-atan2(a2*sin(theata2),a1+a2*cos(theata2));
 
T2=theata2*180/pi;
T1=theata1*180/pi;
d3=(d1-(Z)-d2);
T4=0;