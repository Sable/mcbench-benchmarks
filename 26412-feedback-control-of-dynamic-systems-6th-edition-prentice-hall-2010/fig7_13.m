%  Figure 7.13      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% fig7_13.m is a script to generate Figure 7.13 

% Impulse response
clf;
f=[0 1;-1 0];
g=[0;1];
h=[1 0];
K=[3 4];
fc=f-g*K;
gc=[4*g [1;0]];
hc=[h;[0 1]; -K/4];
jc=[0 0;0 0; 1 0];
sysCL=ss(fc,gc,hc,jc);
t=0:0.1:7;
y=impulse(sysCL,t);
plot(t,y(:,:,2));
xlabel('Time (sec)');
ylabel('Amplitude');
text(1.7,-.3,'x_2');
text(.5,.1,'u/4');
text(.7,.7,'x_1');
title('Fig. 7.13 Impulse response of the oscillator with full state feedback');
nicegrid;

