%  Figure 7.61     Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% Robust Servo Example  
%% Example 7.36; Figure 7.61
clf;
F=[0 1; 0 -1];
G=[0;1];
H=[1 0];
J=[0];
omega=1;
a=[0 1 0 0;-omega*omega 0 1 0;0 0 0 1;0 0 0 -1];
b=[0;0;G];
% desired closed-loop poles
pc=[-1+sqrt(3)*j;-1-sqrt(3)*j;-sqrt(3)+j;-sqrt(3)-j];
k=acker(a,b,pc);
% form controller matrices
k1=k(:,1:2);
ko=k(:,3:4);
ac=[0 1;-omega*omega 0];
bc=-[k(2);k(1)];;
cc=[1 0];
dc=[0];
% controller frequency response
grid;
sys=ss(ac,bc,cc,dc);
w=logspace(-2,1,5000);
[mag, ph]=bode(sys,w);
grid on;
subplot(211);
magdb=20*log10(mag);
semilogx(w,magdb(:));
xlabel('\omega (rad/sec)');
ylabel('Magnitude (db)');
title('Fig. 7.61: Controller frequency response');
grid on;
subplot(212);
semilogx(w,ph(:));
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
grid on;
