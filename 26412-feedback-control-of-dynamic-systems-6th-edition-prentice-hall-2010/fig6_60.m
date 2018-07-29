%  Figure 6.60      Feedback Control of Dynamic Systems, 6e
%                   Franklin, Powell, Emami
%   

clear all
%close all
clf

num=9;
den=conv([1 0.5],[1 1]);
den=conv(den,[1 2]);
w=logspace(-1,1,500);
[mag,phas]=bode(num,den,w);
[OLGM,OLPM,OLWcg,OLWcp]=margin(mag,phas,w)

%Lead compensator, first guess
numl=[1 1];
denl=0.333*[1 3];
numc=conv(num,numl);
denc=conv(den,denl);
[magc,phasc]=bode(numc,denc,w);
[D1GM,D1PM,D1Wcg,D1Wcp]=margin(magc,phasc,w)
dencl=denc+[0 0 0 numc];
t=0:.1:20;
y=step(numc,dencl,t);
%Design Iteration, next guess
numl=[1 1.5];
denl=0.1*[1 15];
numcc=conv(num,numl);
dencc=conv(den,denl);
[magcc,phascc]=bode(numcc,dencc,w);
[D2GM,D2PM,D2Wcg,D2Wcp]=margin(magcc,phascc,w)
subplot(2,1,1)
loglog(w,mag,'-',w,magc,'--',w,magcc,'-.',w,ones(500,1),'-');
%xlabel('w (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.60 Bode Plot for lead-compensation design (a) magnitude');
bodegrid;
subplot(2,1,2)
semilogx(w,phas,'-',w,phasc,'--',w,phascc,'-.',w,-180*ones(500,1));
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
title('Fig. 6.60 (b) phase');
bodegrid;
