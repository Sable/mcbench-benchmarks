%  Figure 10.15      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
%  fig10_15.m is a script to generate Fig 10.15       
%  the root locus of the PD plus notch compensator of the 
%  satellite position control, non-colocated case with the stiff-spring
%  parameters
m=[1, 0.1] ; k1 = [0, 0.4] ; b1=[0, 0.04*sqrt(0.04)];
% call function
[f,g,h,j]=twomass(m,k1,b1);

no3=conv(.25*[2 1],[1/.81 0 1]);
do3=conv([1/40 1],[1/625 2/25 1]);
[Ac3,Bc3,Cc3,Dc3]=tf2ss(no3,do3);
[Aol,Bol,Col,Dol]=series( Ac3,Bc3,Cc3,Dc3, f,g,h,j);
[Acl]=[Aol-Bol*Col]; 
hold off; clf
v=[-8, 1, -3, 3];axis(v);  
pzmap(Aol,Bol,Col,Dol); 
hold on;    
k1=[0:.1:1.4];
k2=[1.4:.001:1.5];
k3=[1.5:.001:1.6];         
k4=[1.6:.001:1.7];
k5=[1.7:.5:50];
r=rlocus(Aol,Bol,Col,Dol,k1);
plot(r,'-')                  
r=rlocus(Aol,Bol,Col,Dol,k2);
plot(r,'-')       
r=rlocus(Aol,Bol,Col,Dol,k3);
plot(r,'-')       
r=rlocus(Aol,Bol,Col,Dol,k4);
plot(r,'-')       
r=rlocus(Aol,Bol,Col,Dol,k5);
plot(r,'-')       
grid;
v=[-8,1,-3,3];
axis(v);
title('Root locus for KD_3(s)Ghat(s)')




