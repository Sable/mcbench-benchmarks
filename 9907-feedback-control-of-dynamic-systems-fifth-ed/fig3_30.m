%  Figure 3.30      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%script to generate Fig. 3.30
clf;
% zeta=.5;
a = [.5 1 2 5 10];
tr1=[5.8 3.4 2.2 1.8 1.6];

% zeta=.7;
tr2=[6.3 3.5 2.6 2.2 2.1];

% zeta=1;
tr3=[8.4 4.2 3.6 3.4 3.3];

axis([0 10 0 9])
plot(a,tr1,'-',a,tr2,'-',a,tr3,'-'),grid
title('Fig. 3.30 \omega_n*t_r vs. pole location, \alpha')
xlabel('\alpha')
ylabel('\omega_n t_r')
text(4,3.5,'\xi =1')
text(4.6,2.3,'0.7')
text(4.6,1.8,'0.5')
text(2,8.1,'See fig3.30a, b, c, d, e.m for data')
