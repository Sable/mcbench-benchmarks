% Fig. 6.54   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

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
title('Fig. 6.54 Maximum phase increase for lead compensation.');
bodegrid;
