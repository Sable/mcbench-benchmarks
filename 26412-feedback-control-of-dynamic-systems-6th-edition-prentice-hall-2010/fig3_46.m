%  Figure 3.46      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%

%  Example 3.35     

clf;
t=[0 .1 .2 .3 .4 .5 1 1.5 2 2.5 3 4 10];
y=[0 .005 .034 .085 .140 .215 .510 .7 .817 .890 .932 .975 .9999];
A=-1.33;   % these parameters are not the best fit   
alpha=1;   % but they are certainly reasonable 
B=.33;     % based on the eyeball fit with logs.
beta=5.8;  % 

axis([0 6 -.1 1])
fity1=1+A*exp(-alpha*t)+B*exp(-beta*t);

A=-1.37;   % these parameters are better
alpha=1;   % they were obtained by using 
B=.37;     % some iteration including
beta=4.3;  % looking at final fit plot
fity2=1+A*exp(-alpha*t)+B*exp(-beta*t);

plot(t,y,'o',t,fity1,'-',t,fity2,'--');
title('Fig. 3.46 Response data vs. fit');
ylabel('y(t)');
xlabel('Time (sec)');
text(1.3,.5,'--------- A = -1.33, \alpha = 1, B = 0.33, \beta = 5.8');
text(1.3,.4,'- - - - - A = -1.37, \alpha = 1, B = 0.37, \beta = 4.3');
text(1,-.1,'o  o  o Data','Color','b');
nicegrid;