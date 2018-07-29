% Fig. 6.42   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

alpha=logspace(-2,0,100);
N=size(alpha);
ialpha=ones(N)./alpha;
dum=(ialpha-ones(N))./(ialpha+ones(N));
phimax=asin(dum);
ff=180/pi;
phimax=ff*phimax;
semilogx(ialpha,phimax);
xlabel('1/\alpha');
ylabel('Maximum phase lead (deg)');
grid;
title('Fig. 6.53 Maximum phase increase for lead compensation.');
