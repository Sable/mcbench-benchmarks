%  Figure 5.44  Feedback Control of Dynamic Systems, 5e 
%                   Franklin, Powell, Emami


clf
numG=[1 0];
denG=[1 1 4];
K1=0:.1:8;   % K = 2 at breakin point
K2=100;
K=[K1 K2];
axis('square')
r=rlocus(numG,denG,K);    % roots vs. K
plot(r,'-'),grid on;
axis([-6 2 -4 4])
hold on
p=roots(denG);             % find and plot OL poles
z=roots(numG);             % find and plot OL zeros
plot(z(1),0,'o')
plot(real(p(1)),imag(p(1)),'x',real(p(2)),imag(p(2)),'x')
title('Fig. 5.44  Root Locus vs. K_T')
xlabel('Re(s)')
ylabel('Im(s)')
hold off
axis('normal')
