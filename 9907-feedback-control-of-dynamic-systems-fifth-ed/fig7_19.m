%  Figure 7.19      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% Script to plot the step tension responses of the tape
% drive servo with dominant second order, and LQR designs
clf;

f =[0    2.0000         0         0         0;
   -0.1000   -0.3500    0.1000    0.1000    0.7500;
         0         0         0    2.0000         0 ;
    0.4000    0.4000   -0.4000   -1.4000         0  ;
         0   -0.0300         0         0   -1.0000   ];

g =[0;
     0;
     0 ;
     0  ;
     1   ];
h3 =[0.5000         0    0.5000         0         0];
ht =[-0.2000   -0.2000    0.2000    0.2000         0];

j=0;

p2 =[-0.7070+0.7070*i;
  -0.7070-0.7070*i    ;
  -4.0000               ;
  -4.0000                ;
  -4.0000                 ];



p22 =p2/1.5;
k2=acker(f,g,p22);

k2 =[8.5123   20.3457   -1.4911   -7.8821    6.1927];

f2c=f-g*k2;

s=[f g;h3 j];
r=[0 0 0 0 0 1]';
n=s\r
nu=n(6);
nx=n(1:5)
nbar2=k2*nx+nu
t=0:.2:12;
% y2=step(f2c,g*nbar2,h3,j,1,t);
T2=step(f2c,g*nbar2,ht,j,1,t);

kqr=lqr(f,g,h3'*h3,1)

klqr =[0.6526    2.1667    0.3474    0.5976    1.0616];

flqrc=f-g*klqr;
% nbarklqr1=klqr1*nx;

nbarlqr = klqr*nx+nu;


%  ylqr=step(flqrc,g*nbarlqr,h3,j,1,t);
 Tlqr=step(flqrc,g*nbarlqr,ht,j,1,t);
% T2=step(f2c,g*nbar2,ht,j,1,t);
plot(t,[T2  Tlqr]);
grid;
xlabel('Time (msec)');
ylabel('Tape Tension, T');
text(8,.01,'LQR');
text(5,-.01,'Dominant second-order');
title('Fig.7.19: Tension plots for tape servo step responses')

% plot(t,[y2 ylqr])
 % grid
% title('Step responses of tape servo designs')
