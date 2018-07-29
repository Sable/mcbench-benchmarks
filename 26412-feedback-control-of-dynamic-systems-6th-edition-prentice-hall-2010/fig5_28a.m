% Fig. 5.28  Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
% script for left side of Figure 5.28

clf
n=[1 2]; 
d=conv([1 1 0],[1 13]);
nc=91*[1 .05];
dc=[1 .01];
nol=conv([0 0 n],nc);
dol=conv(d,dc);
 rlocus(nol,dol); 
 hold on
 title('Fig.5.28a Root locus for lead plus lag')
 axis([-20 4 -9 9])
 z=0:.1:.9;
 wn=2:2:19;
 sgrid(z, wn)
 dcl=nol+dol;
 r=roots(dcl);
 plot(r,'*')
 hold off