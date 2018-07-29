%  Figure 7.62      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% Robust Servo Example    
%% Example 7.36; Figure 7.62
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
%grid;
%sys=ss(ac,bc,cc,dc);
%bode(sys);
%title('Fig. 7.61: Controller frequency response');
%pause;
% closed-loop system
acl=[F-G*ko G*cc;bc*H ac];
bcl=[0;0;-bc];
ccl=[H 0 0];
dcl=[0];
syscl=ss(acl,bcl,ccl,dcl);
pole(syscl)
tzero(syscl)
% blocking zeros
dcle=-1;
syse=ss(acl,bcl,ccl,dcle);
tzero(syse)

% Frequency response from r to e
syscle=ss(acl,bcl,ccl,dcle);
w=logspace(-1,2,500);
[mag, phas]=bode(syscle,w);
subplot(2,1,1);
magdb=20*log10(mag(:,:));
semilogx(w,magdb);grid on;hold on;
xlabel('\omega (rad/sec)');
ylabel('Magnitude (db)');
title('Fig. 7.62: Frequency response: r to e');
subplot(2,1,2);
semilogx(w,phas(:,:));
xlabel('\omega (rad/sec)');
ylabel('Phase(deg)');
grid on;


