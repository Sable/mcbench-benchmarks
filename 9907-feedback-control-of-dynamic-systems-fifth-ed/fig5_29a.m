% Fig. 5.29a  Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%script for Figure 5.29a
n=[1 5.4]; 
d=conv([1 1 0],[1 20]);
nc=127*[1 .03];
dc=[1 .01];
nol=conv([0 0 n],nc);
dol=conv(d,dc);
 rlocus(nol,dol); 
 title('Fig.5.29a Root locus for lead plus lag')
 axis([-20 4 -9 9])
 z=0:.1:.9;
 wn=2:2:19;
 sgrid(z, wn)
 hold off