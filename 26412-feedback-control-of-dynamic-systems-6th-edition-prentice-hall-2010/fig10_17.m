%  Figure 10.17      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
%  fig10_17.m is a script to generate Fig. 10.17, transient  
%  response of the PD plus notch compensator of the 
%  satellite position control, non-colocated case with the stiff-spring
%  parameters
m=[1 .1] ; k1 = [0 .4] ; b1=[0 .04*sqrt(.04)];
[f,g,h,j]=twomass(m,k1,b1);

no3=conv(.25*[2 1],[1/.81 0 1]);
do3=conv([1/40 1],[1/625 2/25 1]);
[Ac3,Bc3,Cc3,Dc3]=tf2ss(no3,do3);
sys1=ss(f,g,h,j);
sys3=ss(Ac3,Bc3,Cc3,Dc3);
sysol=series(sys3,sys1);
[Aol,Bol,Col,Dol]=ssdata(sysol);
[Acl]=[Aol-Bol*Col]; 
hold off; clf
%subplot(224);  
t=0:0.1:40;
sys=ss(Acl,Bol,Col,Dol);
[y]=step(sys,t);
plot(t,y);
xlabel('Time (sec)');
ylabel('Amplitude');
title('Fig. 10.17 Closed-loop step response for KD_3(s)Ghat(s)')
%grid
nicegrid