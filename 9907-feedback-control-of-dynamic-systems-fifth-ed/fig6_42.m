% Fig. 6.42   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

num=86*conv([1 1],[1 2 43.25]);
p=conv([1 2 82],[1 2 101]);
den=conv([1 0 0],p);
w=logspace(-1,2,1000);
[mag,phas]=bode(num,den,w);
figure(1)
loglog(w,mag,w,ones(size(w)));
axis([.1 100 .01 10])
grid;
xlabel('\omega (rad/sec)');
ylabel('magnitude');
title('Fig. 6.42 : Bode plot for Example 6.12 (a) magnitude');
pause;
figure(2)
semilogx(w,phas,w,-180*ones(size(w)));
grid;
xlabel('\omega (rad/sec)');
ylabel('phase (deg)');
title('Fig. 6.42 : Bode plot for Example 6.12 (b) phase');

% actually, the GMs and PMs are slightly different for the system here
% than that described in the text, the differences arose from  
% roundoff because the initial design was done by hand.  The ideas
% are unchanged.
