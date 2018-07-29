%  Figure 3.25      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%script to generate Fig. 3.25
clf;
% zeta=.3;
a1 = [1 2 4 10];
Mp1=[1.9 .9 .55 .35];

% zeta=.5;
a2 = [.5 1 2 4 10];
Mp2=[1.71 .7 .3 .19  .16];

% zeta=.7;
Mp3=[.76 .22 .07 .05 .04];

axis([0 10 0 2])
plot(a1,Mp1,'-',a2,Mp2,'-',a2,Mp3,'-'),grid
title('Fig. 3.25 M_p vs. zero location, \alpha')
xlabel('\alpha')
ylabel('Mp')
text(2,1.85,'See fig3.25a, b, c.m for data')
