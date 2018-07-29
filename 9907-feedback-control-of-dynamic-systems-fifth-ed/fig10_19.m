%  Figure 10.19      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
%  fig10_19.m is a script to generate Fig 10.19 the transient  
%  response of the LQR symmetric rootlocus compensator of the 
%  satellite position control, non-colocated case

m=[1, 0.1]; k=[0, 0.091] ; d=[0, 0.0036]; k1=[0, 0.4];
[f,g,h,j] = twomass(m,k,d);

% Compute Nu, Nx
s=[f, g;h, 0];
r=[0*g;1]; 
n=s\r;
nx=n(1:4);
nu=n(5);

% call function
[f1,g,h,j] = twomass(m,k1,d);
a=[f, 0*f;
-h'*h, -f'];
b=[g;0*g];
c=[0*h, g'];
d=[0];

hold off; clf
%subplot(221); 
rlocus(a,b,c,d);
grid;
v=[-2 2 -1.5 1.5];
axis(v);
title('Symmetric rootlocus for the satellite') 
disp('select poles at -0.5+j0.36')
pause
[K, P]=rlocfind(a,b,c,d)
pc=P(real(P<0)==1);
K=place(f,g,pc);
nbar=nu+K*nx;
eig(f-g*K)
t=0:.25:20;  
sys1=ss(f-g*K,nbar*g,h,j);
sys2=ss(f1-g*K,nbar*g,h,j);
step(sys1,t); hold on; step(sys2,t);
grid on;
text(6,1.15,'Nominal');
text(4.5,0.7,'Stiff spring');
title('Fig. 10.19 Closed-loop step response for SRL design with state feedback')



