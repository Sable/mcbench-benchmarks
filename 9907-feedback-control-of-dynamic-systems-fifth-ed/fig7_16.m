%  Figure 7.16      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
%
%fig7_16.m                                           
%
clf;
f=[0 1;-1 0];
g=[0;1];
h=[1 0];
K=[3 4];
fc=f-g*K;
gc=[4*g [1;0]];
hc=[h;[0 1]; -K/4];
jc=[0 0;0 0; 1 0];
t=0:.1:7;
sys=ss(fc,gc,hc,jc);
[y,t]=step(sys,t);
plot(t,y(:,:,1));
grid;
xlabel('Time (sec)');
ylabel('Amplitude');
text(1.5,.9,'x_1');
text(1.6,.3,'x_2');
text(1.5,.05,'u/4');
text(6.5,.3,'u_{ss}');
text(6.5,.95,'x_{ss}');
title('Fig. 7.16 Step response of the oscillator to a reference input');

