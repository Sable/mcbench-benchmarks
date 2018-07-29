function [theata d3]=Inv_SCARA(O,R,a1,a2,d4)
 
alpha=atan2(R(1,2),R(1,1));
 
C2=((O(1,1)^2)+(O(2,1)^2)-(a1^2)-(a2^2))/(2*a1*a2);
 
S2=sqrt(1-(C2^2));
 
theata2=atan2(S2,C2);
 
theata1=(atan2(O(2,1),O(1,1)))-atan2((a2*sin(theata2)),(a1+a2*cos(theata2)));
 
theata4=theata1+theata2-alpha;
 
theata1=(theata1*180/pi);
theata2=(theata2*180/pi);
theata4=(theata4*180/pi);
 
theata=[theata1,theata2,theata4];
 
d3=d1-O(3,1)-d4;
