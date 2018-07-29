%  Figure 6.60      Feedback Control of Dynamic Systems, 5e
%                   Franklin, Powell, Emami
%   

clear all
close all

num=10;
den=conv([1 0],[1/2.5 1]);
den=conv(den,[1/6 1]);
w=logspace(-1,2,100);
[mag,phas]=bode(num,den,w);
[OLgm,OLpm,OLwcg,OLwcp]=margin(mag,phas,w)
%Lead compensator
numl=10*[1 2];
denl=[1 20];
num1=conv(num,numl);
den1=conv(den,denl);
[magcl,phascl]=bode(num1,den1,w);
[D1gm,D1pm,D1wcg,D1wcp]=margin(magcl,phascl,w)
numll=10*conv(numl,[1 4]);
denll=conv(denl,[1 40]);
num2=conv(num,numll);
den2=conv(den,denll);
[magcll,phascll]=bode(num2,den2,w);
[D2gm,D2pm,D2wcg,D2wcp]=margin(magcll,phascll,w)
subplot(2,1,1)
loglog(w,mag,'-',w,magcl,'--',w,magcll,'-.',w,ones(100,1),'-');
axis([.1 100 .01 10])
grid;
ylabel('Magnitude');
title('Fig. 6.60 Bode plot for Example 6.16.   (a) magnitude');
subplot(2,1,2)
semilogx(w,phas,'-',w,phascl,'--',w,phascll,'-.',w,-180*ones(100,1),'-');
axis([.1 100 -250 -50])
grid;
xlabel('\omega (rad/sec)');
ylabel('phase (deg)');
title('Fig. 6.60 (b) phase.');
