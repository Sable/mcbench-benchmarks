% Fig. 9.16   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
% script to generate figure 9.16
% using the general simulation nonlin
clf
N=0.1;
a=10/2;
r=0;
num=[1];
den=[1 .2 1 0];
nf=1;
df=1;
hold on
grid on
for k=1:2
   r=r+4;
   sim('nonsim',150)
   plot(yn(:,1),yn(:,2))
end
r=1;
sim('nonsim',150)
plot(yn(:,1),yn(:,2))
Title('Figure 9.16 Simulation of a limit cycle')
xlabel('Time (sec)');
ylabel('Amplitude');
gtext('r = 1')
gtext('r = 4')
gtext('r = 8')
hold off