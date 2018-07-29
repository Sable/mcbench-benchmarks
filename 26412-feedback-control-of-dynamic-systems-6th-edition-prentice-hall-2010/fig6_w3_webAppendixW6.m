%  Figure W3 web Appendix W6     Feedback Control of Dynamic Systems, 5e
%                                     Franklin, Powell, Emami
% 

clear all
close all;

num=1;
den=conv([1 0],[1 2 1]);
w=0:.005:1;
Nw=size(w);
%G^{-1)(jw)=-2w^2+jw(-w^2+1)
rei=-2*w.*w;
imi=w.*(-w.*w+ones(Nw));
% do circle
w=0:.05:2*pi;
x=cos(w);
y=sin(w);
plot(rei,imi,x,y,'--');
axis([-2 2 -2 2]);
axis('square')
xlabel('Re(1/G)');
ylabel('Im(1/G)');
title('Fig. W3: Inverse Nyquist plot.');
nicegrid;