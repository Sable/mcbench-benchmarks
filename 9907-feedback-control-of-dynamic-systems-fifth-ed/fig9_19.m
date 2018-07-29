% Fig. 9.19   Feedback Control of Dynamic Systems, 5e 
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
grid on
for k=1:2
   r=r+2;
   sim('nonsim',50)
   plot(yn(:,1),yn(:,2))
end
Title('Figure 9.19 Simulation of a system with notch compensation')
xlabel('Time (sec)');
ylabel('Amplitude');
gtext('r = 2')
gtext('r = 4')
hold off