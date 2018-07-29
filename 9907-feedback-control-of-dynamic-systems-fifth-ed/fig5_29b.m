% Fig. 5.29b  Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%script for Figure 5.29b
n=[1 5.4]; 
d=[1 1 0];
% the lead pole at -20 is omitted to allow greater
%  accuracy for very small values of s
nc=[1 .03];
dc=[1 .01];
nol=conv([ 0 n],nc);
dol=conv(d,dc);
 rlocus(nol,dol); 
 title('Fig.5.29b Root locus showing lag branch')
 axis([-.2 .2 -.15 .15])
 z=0:.1:.9;
 wn=2:2:19;
 sgrid(z, wn)
 hold off