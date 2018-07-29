% Fig. 6.3    Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

numG=1;
zeta=0.05;
denG=[1 2*zeta 1];
w=logspace(-1,1,200);
[m1,p1]=bode(numG,denG,w);
zeta=0.1;
denG=[1 2*zeta 1];
[m2,p2]=bode(numG,denG,w);
zeta=0.2;
denG=[1 2*zeta 1];
[m3,p3]=bode(numG,denG,w);
zeta=0.3;
denG=[1 2*zeta 1];
[m4,p4]=bode(numG,denG,w);
zeta=0.4;
den=[1 2*zeta 1];
[m5,p5]=bode(numG,denG,w);
zeta=0.5;
denG=[1 2*zeta 1];
[m6,p6]=bode(numG,denG,w);
zeta=0.6;
denG=[1 2*zeta 1];
[m7,p7]=bode(numG,denG,w);
zeta=0.7;
denG=[1 2*zeta 1];
[m8,p8]=bode(numG,denG,w);
zeta=0.8;
denG=[1 2*zeta 1];
[m9,p9]=bode(numG,denG,w);
zeta=0.9;
denG=[1 2*zeta 1];
[m10,p10]=bode(numG,denG,w);

figure(1)
loglog(w,m1,w,m2,w,m3,w,m4,w,m5,w,m6,w,m7,w,m8,w,m9,w,m10);
axis([.1 10 .01 10])
xlabel('\omega / \omega_n');
ylabel('Magnitude');
title('Fig. 6.3 (a) Magnitude');
bodegrid;
%pause;
figure(2)
semilogx(w,p1,w,p2,w,p3,w,p4,w,p5,w,p6,w,p7,w,p8,w,p9,w,p10);
xlabel('\omega / \omega_n');
ylabel('Phase');
title('Fig. 6.3 (b) phase');
bodegrid;
