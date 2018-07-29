% Fig. 9.19   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
% script to generate figure 9.19
% using the general simulation nonlin
clf
N=0.1;
a=5;
r=0;
num=[1];
den=[1 0.2 1 0];
nf=[1  0.18  0.81]*100/0.81;
df=[1 20 100];
hold on
for k=1:2
   r=r+2;
   sim('nonsim',50)
   plot(yn(:,1),yn(:,2))
end
title('Figure 9.19 Simulation of a system with notch compensation')
xlabel('Time (sec)');
ylabel('Amplitude');
text(25,2.1,'r = 2')
text(45,4.1,'r = 4')
nicegrid
hold off