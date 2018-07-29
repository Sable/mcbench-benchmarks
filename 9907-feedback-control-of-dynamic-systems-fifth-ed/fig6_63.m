%  Figure 6.63      Feedback Control of Dynamic Systems, 5e
%                   Franklin, Powell, Emami
%   

clear all
close all

num=3;
den=conv([2 1],[1 1]);
den=conv(den,[0.5 1]);
w=logspace(-2,1,500);
[mag,phas]=bode(num,den,w);
[OLGM,OLPM,OLWcg,OLWcp]=margin(mag,phas,w)

%Lag compensator 
numl=3*[5 1];
denl=[15 1];
numc=conv(num,numl);
denc=conv(den,denl);
[magc,phasc]=bode(numc,denc,w);
[D1GM,D1PM,D1Wcg,D1Wcp]=margin(magc,phasc,w)
dencl=denc+[0 0 0 numc];
t=0:.1:20;
y=step(numc,dencl,t);
subplot(2,1,1)
loglog(w,mag,'-',w,magc,'--',w,ones(500,1),'-');
axis([.01 10 .1 10])
grid;
%xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.63 Bode Plot for lag-compensation design (a) magnitude');
subplot(2,1,2)
semilogx(w,phas,'-',w,phasc,'--',w,-180*ones(500,1));
axis([.01 10 -250 -50])
grid;
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
title('Fig. 6.63 (b) phase');
%return
%plot(t,y);
%grid;
%xlabel('time (sec)');
%ylabel('y');
%title('Fig. 6.64  Step Response');
