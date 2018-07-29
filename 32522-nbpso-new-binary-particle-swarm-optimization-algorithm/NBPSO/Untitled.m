close all,clc,,a=1:1500;
plot(a,f7_min_BPSO,'k',a,f7_min_NBPSO,'k-.')
legend('BPSO','NBPSO','NorthWest')
title('F7 Function')
xlabel('Iteration')
ylabel('Best-so far')
% axis([0 1500 0 12])