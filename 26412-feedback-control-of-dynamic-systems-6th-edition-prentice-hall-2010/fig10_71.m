%  Figure 10.71      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% fig10_71.m is a script to generate Fig. 10.71 the linear RTP response 
% LQG method with internal model
% RTP chamber demo Example
clf;
a=[-0.068208813989939 0.014929776357245 0.000000065782442;...
   0.045809672136430 -0.118134773528570 0.021802006306129;...
   0.000000433637498 0.046839194867347 -0.100884399149872];
b3=[0.37873508304055 0.110575403544586 0.022912893467038;...
   0.000000002974222 0.449046982554739 0.073572900808161;...
   0.000000027324116 0.000702342292121 0.417797228783230];
c3=eye(3,3);
d=0*eye(3,3);
sysp=ss(a,b3,c3,d);
[eol]=eig(a);
[zol]=tzero(sysp);
[zol22]=tzero(a,b3(:,2),c3(2,:),d(2,2));
% Combine 3 lamps into a single actuator
b=b3(:,1)+b3(:,2)+b3(:,3);
% Select center temperature
c=c3(2,:);
aa=[zeros(1,1) c;zeros(3,1) a];
bb=[zeros(1,1);b];
%
% weight temperature differences
q1hat=[eye(1,1) zeros(1,3);0 2 -1 -1; 0 -1 2 -1; 0 -1 -1 2]+1e-6*eye(4,4);
q1hat=diag([1 10 10 10])*q1hat;
q2hat=eye(1,1);
[kk,sric,ee]=lqr(aa,bb,q1hat,q2hat);
k1=kk(1,1);
ko=kk(:,2:4);
acl=[a-b*ko b;-k1*c zeros(1,1)];
bcl=[zeros(3,1);k1];
ccl=[c zeros(1,1)];
dcl=zeros(1,1);
[ecl]=eig(acl);
[zcl]=tzero(acl,bcl,ccl,dcl);
%CL DC gain
[cldcgain]=dcl-ccl*inv(acl)*bcl;
%CL Step Response
%[y,t]=step(acl,bcl,ccl,dcl);
%s1y=plot(y(:,:,1));
%grid;
%pause;
%Control effort
%cclu=[-ko eye(1,1)];
%dclu=[0];
%[uu,t]=step(acl,bcl,cclu,dclu);
%su=plot(uu(:,:,1));
%grid;
%pause
%Step in all channels
%t=0:.1:100;
%u=[25*ones(1,251) 25*ones(1,500)0*ones(1,250)];
%u10=[u'];
%sysc1=ss(acl,bcl,ccl,dcl);
%[yy1,t]=lsim(sysc1,u10,t);
%plot(t,yy1)
%grid
%pause;
%cclu=[-ko eye(1,1)];
%dclu=[0];
%syscl2=ss(acl,bcl,cclu,dclu);
%[uu1,t]=lsim(syscl2,u10,t);
%su=plot(uu1(:,:,1));
%grid;
%pause
% Estimator design
qe=eye(1,1);
re=0.001*eye(1,1);
[ll,pp,el]=lqe(a,b,c,qe,re);
ac=zeros(1,1);
bc=-k1;
cc=eye(1,1);
dc=-ko;
acle=[a, b*cc, -b*ko;
   bc*c, ac, zeros(1,3);
   ll*c, b*cc, a-ll*c-b*ko];
bcle=[zeros(3,1);-bc;zeros(3,1)];
ccle=[c, zeros(1,4)];
dcle=zeros(1,1);
[ecle]=eig(acle);
[zcle]=tzero(acle,bcle,ccle,dcle);
dcgain=dcle-ccle*inv(acle)*bcle;
t=0:.1:100;
R=[0:.1:25, 25*ones(1,500), 0*ones(1,250)];
R11=[R'];
R11=[R11 R11 R11 R11 R11 R11];
syscl=ss(acle,bcle,ccle,dcle);
[yy,t]=lsim(syscl,R,t);
figure(1);
plot(t,yy,'--','LineWidth',2);
grid on;
hold on;
plot(t,R11,'-');
xlabel('Time (sec)');
ylabel('Temperature (K)');
title('Fig. 10.71 (a) Internal model controller: temperature tracking response');
%grid
h_axes = findobj(get(gcf,'Children'),'Type','axes');
grey = [0.7,0.7,0.7];
set(h_axes,'xcolor',grey,'ycolor',grey, ...
    'GridLineStyle','-','MinorGridLineStyle','-', ...
    'Units','pixels');
grid on 
c11=copyobj(h_axes,gcf); 
set(c11,'color','none','xcolor','k', ...
    'xgrid','off','ycolor','k', ...
    'ygrid','off'); 
%legend('y')
%pause;
hold off;
cclu=[zeros(1,3), eye(1,1), -ko];
dclu=zeros(1,1);
syscu=ss(acle,bcle,cclu,dclu);
[uuu,t]=lsim(syscu,R,t);
figure(2);
plot(t(1:753,:),uuu(1:753,:),'LineWidth',2);
hold on;
plot(t(752:818,:),0*ones(67,3),'LineWidth',2);
hold on;
plot(t(753:818,:),uuu(753:818,:),'--','LineWidth',2);
hold on;
plot(t(819:1001,:),uuu(819:1001,:),'LineWidth',2);
xlabel('Time (sec)');
ylabel('Lamp voltage');
title('Fig. 10.71 (b) Internal model controller: control effort');
legend('u');
nicegrid;








