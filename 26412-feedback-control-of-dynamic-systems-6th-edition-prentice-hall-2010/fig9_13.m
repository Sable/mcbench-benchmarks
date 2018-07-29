% Fig. 9.13  Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
% script to generate Fig. 9.13
% using the general nonlinear simulation
clf;
N=1;
a=2;
r=0;
num=[1 2 1];
den=[1 0 0 0];
nf=1;
df=1;
for k=1:3
   r=r+1;
   sim('nonsim',20)
   hold on
   plot(yn(:,1),yn(:,2))
end
r=3.475;
sim('nonsim',20)
plot(yn(:,1),yn(:,2))
xlabel('Time (sec)');
ylabel('Amplitude');
Title('Figure 9.13 Simulation of a conditionally stable system')
text(2,1.5,'r = 1')
text(2,3.1,'r = 2')
text(2.3,5.2,'r = 3')
text(2,6.5,'r = 3.475')
nicegrid
