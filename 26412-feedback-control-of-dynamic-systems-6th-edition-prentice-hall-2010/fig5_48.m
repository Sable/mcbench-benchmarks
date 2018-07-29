% Fig. 5.48  Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%  Figure 5.48 Root locus for the heat exchanger, with and without delay

clf
numG=1;
denG=conv([10 1],[60 1]);
sysG=tf(numG, denG);
rlocus(sysG);
axis([-.8 .8 -.6 .6]);
%pause;
hold on
%gtext('locus without delay')
Td=5;
numD1 = 1;
denD1=[Td 1];
numGD1=conv(numG,numD1);
denGD1=conv(denG,denD1);
sysGD1= tf(numGD1, denGD1);
rlocus(sysGD1);

%gtext('locus with (0,1) lag Pade')
title('Fig. 5.48 Root locus for heat exchanger with and without delay')
%pause;
numDe2=[Td^2/12 -Td/2 1];
denDe2=[Td^2/12 +Td/2 1];
numGD=conv(numG,numDe2);
denGD=conv(denG,denDe2);
sysGD= tf(numGD, denGD);
rlocus(sysGD);

%gtext('locus with(2,2) Pade')
nicegrid;
% title('Fig. 5.47 Root locus for heat exchanger with and without delay')
% z=0:.1:.9;
% wn= .1:.1:.6;
% sgrid(z, wn) 
hold off