%  Figure 5.46 Feedback Control of Dynamic Systems, 6e 
%                   Franklin, Powell, Emami
%                
clf
numG=[1 0];
denG=[1 1 4];
K1=0:.1:8;   % K = 2 at breakin point
K2=100;
Kt=[K1 K2];
axis('square')
r=rlocus(numG,denG,Kt);    % roots vs. Kt
plot(r,'--'),nicegrid;
axis([-6 2 -4 4])
hold on
p=roots(denG);             % find and plot OL poles
z=roots(numG);             % find and plot OL zeros
plot(z(1),0,'o')
plot(real(p(1)),imag(p(1)),'x',real(p(2)),imag(p(2)),'x')
title('Fig. 5.46  Root Locus vs. K with K_{T} = 1')
xlabel('Re(s)')
ylabel('Im(s)')

% now do RL vs. K

Kt1 = 1;
r1=rlocus(numG,denG,Kt1);    % root at Kt = 1
plot(r1,'*')
num = 1;
den = poly(r1);
K = [0 30];
r2=rlocus(num,den,K);    % root locus vs. K
plot(r2,'-')

hold off
axis('normal')
