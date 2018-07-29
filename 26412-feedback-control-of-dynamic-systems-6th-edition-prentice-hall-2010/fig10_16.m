%  Figure 10.16      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
%  fig10_16.m is a script to generate Fig 10.16    
%  the  frequency response of the PD plus notch compensator of the 
%  satellite position control, non-colocated case with the stiff-spring
%  parameters

% parameter values
m=[1 .1] ; k1 = [0 .4] ; b1=[0 .04*sqrt(.04)];
% call function
[f,g,h,j]=twomass(m,k1,b1);

no3=conv(.25*[2 1],[1/.81 0 1]);
do3=conv([1/40 1],[1/625 2/25 1]);
[Ac3,Bc3,Cc3,Dc3]=tf2ss(no3,do3);
[Aol,Bol,Col,Dol]=series( Ac3,Bc3,Cc3,Dc3, f,g,h,j);
[Acl]=[Aol-Bol*Col]; 
hold off; clf
w=logspace(-1,1);
w(24)=0.89;w(33)=2.1;
[mag3, ph3, w]=bode(Aol,Bol,Col,Dol,1,w);
ph3(25:50)=ph3(25:50)+360*ones(size(ph3(25:50)));
ph180=-180*ones(size(w));
subplot(211); 
loglog(w,[mag3, ones(size(mag3))]); grid;
xlabel('\omega (rad/sec)');
ylabel('Magnitude, KD_3(s)Ghat(s)|');
title('Fig. 10.16 Frequency response for KD_3(s)Ghat(s).')
subplot(212); 
semilogx(w,[ph3, ph180]);  
grid; 
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
%Bode grid
bodegrid
