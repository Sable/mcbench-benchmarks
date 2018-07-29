% Fig. 5.26  Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
% script for Figure 5.26, Lead design embellishment via RLTOOL.

clf;
np=1;
dp=[1 1 0];
nc=[1 2];
dc=[1 13];
nol=conv(np,nc);
dol=conv(dp,dc);
sysDG = tf(nol,dol);
rltool(sysDG)

% right click on the plot
%    click "grid"
%    click "design requirements", then "new"
%        put in 7.5 rad/sec natural frequency
%        put in 0.5 damping ratio

% move roots so that the specs above are met, and find that the gain is about 91.