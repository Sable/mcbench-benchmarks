% Fig. 8.4   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

zgrid('new')
axis('square')
plot([-1 1],[0 0])
plot([0 0],[-1 1])
title('Fig. 8.4 Natural frequency and damping loci in z-plane')
xlabel('Re(z)')
ylabel('Im(z)')
hold off