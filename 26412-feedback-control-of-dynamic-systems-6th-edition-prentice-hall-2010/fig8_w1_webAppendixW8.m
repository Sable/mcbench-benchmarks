% Fig. W1 Web Appendix W8    Feedback Control of Dynamic Systems, 6e 
%                                 Franklin, Powell, Emami
%

clear all;
close all;

F=[0 1;0 0];
G=[0;1];
H=[1 0];
J=0;
T=1;
[Phi,Gam]=c2d(F,G,T);
j=sqrt(-1);
Pc=[.78+.18*j;.78-.18*j];
K=acker(Phi,Gam,Pc);
Pe=[.2+.2*j;.2-.2*j];
L=acker(Phi',H',Pe)';
[A,B,C,D]=dreg(Phi,Gam,H,J,K,L);
A=Phi-Gam*K-L*H;
B=L;
C=K;
D=0;
[Ac,Bc,Cc,Dc]=series(A,B,C,D,Phi,Gam,H,J);
[Acl,Bcl,Ccl,Dcl]=feedback(Ac,Bc,Cc,Dc,0,0,0,1);
tf=30;
N=tf/T+1;
td=0:1:tf;
yd=dstep(Acl,Bcl,Ccl,Dcl,1,N);
axis([0 30 0 1.5])
plot(td,yd,'-',td,yd,'*'),
xlabel('time (sec)')
ylabel('plant output  y(t)')
title('Fig. 8.20  Step response of the continuous and digital systems')
nicegrid;
hold on

% use command structure from section 7.8

Nx=[1;0];    
A2=[Phi  -Gam*K;
   L*H  Phi-L*H-Gam*K];
B2=[Gam*K*Nx;Gam*K*Nx];
C2=[1 0 0 0];
D2=0;
y2=dstep(A2,B2,C2,D2,1,N);
plot(td,y2,'-',td,y2,'o')
text(6.5,.25,'o-----o-----o-----o  Command structure from Fig 7.48(b)')
text(6.5,.45,'*-----*-----*-----*  Command structure from Fig 7.15')
hold off

