%  Figure 10.46      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% fig10_46.m is a script to generate Fig. 10.46 the step response for the SRL
% design for the aircraft with state feedback augmenting the
% inner loop stabilization. Control effort plot.
clf;
f =[-0.00643    0.0263         0    -32.2000      0;
   -0.0941     -0.6240       820      0         0;
   -0.000222   -0.00153     -0.668    0         0;
     0         0             1.000    0         0;
     0         -1.0000       0       830         0];
g=[0; -32.7; -2.08; 0; 0];
h=[0 0 0 0 1];
j=0;
k=[-.0011 .0016 -.0833 -1.613 -.0010];
t=0:.3:30;
kq=[0 0 -1 0 0];
ktq=[0 0 -.8 -6 0];
hc=-k; % we plot the outer-loop control effort
fc=f-g*(k+kq+ktq); % the feedback includes the inner compensation
nbar = -k(5);  % since there is integral control, we can compute Nbar from k
r=-100*nbar;  % 100 foot step  up is negative
jc=r;
y=step(fc,g*r,h,j,1,t);
u=step(fc,g*r,hc,jc,1,t);
plot(t,u*180/pi) % plot the control in degrees
title( 'Fig. 10.46 Outer-loop control for altitude step');
xlabel(' Time (sec)');
ylabel('\delta_e (deg)');
grid;

