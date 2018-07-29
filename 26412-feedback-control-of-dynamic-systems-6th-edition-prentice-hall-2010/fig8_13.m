% Fig. 8.13   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

w=logspace(-1,2,100);
l=length(w);

% s-plane
num=5;
den=[1 5];
[magC,phaseC]=bode(num,den,w);
subplot(2,1,1),
loglog(w,magC,'-')
axis([.1  100  .01 1]);
ylabel('Magnitude')
%xlabel('Frequency (rad/sec)')
title('Fig. 8.13  (a) 100 rad/sec  T=1/15 sec')
nicegrid
hold on

%              T = 1/15 sec
T = 1/15;

%  MPZ

num=.143*[1 1];
den=[1 -.715];
[mag1,phase]=dbode(num,den,T,w);

%  MMPZ

num=.285;
den=[1 -.715];
[mag2,phase]=dbode(num,den,T,w);

% Tustins

num=.143*[1 1];
den=[1 -.713];
[mag3,phase]=dbode(num,den,T,w);

loglog(w,mag1,'--',w,mag2,'--',w,mag3,'-.')
hold off

%              T = 1/3 sec

subplot(2,1,2),loglog(w,magC,'-')
ylabel('Magnitude')
xlabel('Frequency (rad/sec)')
title('(b) 20 rad/sec  T=1/3 sec')
nicegrid
hold on

T = 1/3;

%  MPZ

num=.405*[1 1];
den=[1 -.189];
wp=w;
wp=wp(wp < 24);
[mag1,phase]=dbode(num,den,T,wp);

%  MMPZ

num=.811;
den=[1 -.189];
[mag2,phase]=dbode(num,den,T,wp);

% Tustins

num=.454*[1 1];
den=[1 -.0914];
[mag3,phase]=dbode(num,den,T,wp);

loglog(wp,mag1,'--',wp,mag2,'--',wp,mag3,'-.')

hold off

