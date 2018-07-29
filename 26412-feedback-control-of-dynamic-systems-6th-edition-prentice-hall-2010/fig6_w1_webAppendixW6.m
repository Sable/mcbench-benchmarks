%  Figure W1 web Appendix W6      Feedback Control of Dynamic Systems, 6e
%                                       Franklin, Powell, Emami
% 

clear all
%close all;
clf

w=logspace(-1,4,500);
figure(1)
plot(-sin(w)./w,-cos(w)./w,-sin(w)./w,cos(w)./w)
xlabel('Re(G(s))');
ylabel('Im(G(s))');
title('Fig. W1 Complete Nyquist plot.');
nicegrid;
%pause;
figure(2)
i=100:500;
plot(-sin(w(i))./w(i),-cos(w(i))./w(i),-sin(w(i))./w(i),cos(w(i))./w(i))
xlabel('Re(G(s))');
ylabel('Im(G(s))');
title('Fig. W1 Relevant Portion of Nyquist plot');
nicegrid;