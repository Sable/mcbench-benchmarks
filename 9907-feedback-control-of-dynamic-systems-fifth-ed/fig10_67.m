%  Figure 10.67      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% fig10_67.m is a script to generate Fig. 10.67 the linear RTP response 
% PI controller
% RTP chamber demo Example
clf;
a=[-0.068208813989939 0.014929776357245 0.000000065782442;...
   0.045809672136430 -0.118134773528570 0.021802006306129;...
   0.000000433637498 0.046839194867347 -0.100884399149872];
b3=[0.37873508304055 0.110575403544586 0.022912893467038;...
   0.000000002974222 0.449046982554739 0.073572900808161;...
   0.000000027324116 0.000702342292121 0.417797228783230];
c3=eye(3,3);
d3=0*eye(3,3);

% Combine 3 lamps into a single actuator
b=b3(:,1)+b3(:,2)+b3(:,3);
% Select center temperature
c=c3(2,:)
%
d=[0];
% PI controller
ac=[0];
bc=[1.0];
cc=[0.0527];
dc=[1];
sysG=ss(a,b,c,d);
sysD=ss(ac,bc,cc,dc);
sysL=series(sysD,sysG);
sysH=tf(1,1);
sysCL=feedback(sysL,sysH);

%CL Step Response
t=0:.1:100;
R=[0:.1:25, 25*ones(1,500), 0*ones(1,250)];
R11=[R'];
[yy,t]=lsim(sysCL,R11,t);
plot(t,yy,'--');
grid;
hold on;
plot(t,R11,'-');
xlabel('Time (sec)');
ylabel('Temperature (K)');
title('Fig. 10.67 (a) PI controller: temperature tracking response');
%legend('y')
pause
hold off
% Control effort
sysCLu=feedback(sysD,sysG);
[uuu,t]=lsim(sysCLu,R11,t);
plot(t(1:753,:),uuu(1:753,:));
hold on;
plot(t(752:818,:),0*ones(67,3));
hold on;
plot(t(753:818,:),uuu(753:818,:),'--');
hold on;
plot(t(819:1001,:),uuu(819:1001,:));
xlabel('Time (sec)');
ylabel('Lamp voltage');
title('Fig. 10.67 (b) PI controller :control effort');
legend('u')
grid;
hold off;









