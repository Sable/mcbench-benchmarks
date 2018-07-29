% Fig. 9.9  Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
% script to generate figure 9.9
% using the general simulation nonsim
clf;
N=0.4;
a=2.5;
r=0;
num=[1 1];
den=[1 0 0 ];
nf=1;
df=1;
hold on

for k=1:6
   r=r+2;
   sim('nonsim',30)
   plot(yn(:,1),yn(:,2))
end
title('Figure 9.9 Step responses of the nonlinear system')
xlabel('Time (sec)');
ylabel('y(t)');
gtext('r=2')
gtext('r=4')
gtext('r=6')
gtext('r=8')
gtext('r=10')
gtext('r=12')
nicegrid
hold off