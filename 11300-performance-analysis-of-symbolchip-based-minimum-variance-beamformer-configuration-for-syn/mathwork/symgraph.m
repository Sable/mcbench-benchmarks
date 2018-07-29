y1=user1sym();
y2=user3sym();
y3=user5sym();
y4=user7sym();
y5=user10sym();
y6=user12sym();
%//SYMBOL BASED CONFIGURATION\\
u1=[y1,y2,y3,y4,y5,y6];
v1=[1,3,5,7,10,12];

%// CHIP BASED CONFIGURATION\\
u2=[s1,s2,s3,s4,s5,s6];
v2=[1,3,5,7,10,12];
plot(u1,v1,'r-+',u2,v2,'g-*');
grid on;
legend('u1,v1','u2,v2');
title('simulation for No of users vs BER in  SYMBOL BASED & CHIP BASED ');
 xlabel('NUMBER USERS');
 ylabel('BER');
