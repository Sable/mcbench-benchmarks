%  Figure 10.45      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% fig10_45.m is a script to generate Fig. 10.45 the step response for the SRL
% design for the aircraft with state feedback augmenting the
% inner loop stabilization
clf;
%system matrices
ftq =[-0.0064    0.0263         0  -32.2000      0;
   -0.0941   -0.6240  761.1400 -196.2000         0;
   -0.0002   -0.0015   -4.4120  -12.4800         0;
         0         0    1.0000         0         0;
         0   -1.0000         0  830.0000         0];
g=[0; -32.7; -2.08; 0; 0];
h=[0 0 0 0 1];
j=0;
k=[-.0011 .0016 -.0833 -1.613 -.0010];
fc=ftq-g*k;
% dc gain
dcgain=-h*inv(fc)*g;
r=100/dcgain;
t=0:.3:30;
% step response
y=step(fc,g*r,h,j,1,t);
plot(t,y);
v=[0, 30, 0, 100];
axis(v);
xlabel('Time (sec)');
ylabel('Altitude, h (ft)');
grid;

title( 'Fig. 10.45 Step response of the altitude autopilot')
