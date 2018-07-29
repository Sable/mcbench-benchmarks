y1=user1sym();
y2=user3sym();
y3=user5sym();
y4=user7sym();
y5=user10sym();
y6=user12sym();
%//SYMBOL BASED CONFIGURATION\\
u1=[y1,y2,y3,y4,y5,y6];
v1=[1,3,5,7,10,12];
plot(u1,v1,'r-*');
grid on;
title('simulation for No of users vs BER in  SYMBOL BASED  ');
 xlabel('NUMBER USERS');
 ylabel('BER');
