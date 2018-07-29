%  Figure 6.86      Feedback Control of Dynamic Systems, 5e
%                   Franklin, Powell, Emami
% 

clear all
close all;

w=logspace(-1,4,500);
figure(1)
plot(-sin(w)./w,-cos(w)./w,-sin(w)./w,cos(w)./w)
xlabel('Re(G(s))');
ylabel('Im(G(s))');
title('Fig. 6.86 Complete but unreadable Nyquist plot.');
grid;
pause;
figure(2)
i=100:500;
plot(-sin(w(i))./w(i),-cos(w(i))./w(i),-sin(w(i))./w(i),cos(w(i))./w(i))
grid;
xlabel('Re(G(s))');
ylabel('Im(G(s))');
title('Fig. 6.86 Relevant Portion of Nyquist plot');