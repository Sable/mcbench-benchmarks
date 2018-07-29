% Fig. 9.45   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

% script to run the ptos simulation
r=4;
clf
L=.005;
N=1.00;
alph=.95;
Na=N*alph;
k1=1/L;
k2=sqrt(2/(N*L));
sim('ptos_sim');
figure(1)
subplot(211);
plot(uptos(:,1),uptos(:,2))
axis([0 2.5*sqrt(r/N) -1.2*N 1.2*N]); 
title('Control for the  PTOS, \alpha = 0.9')
xlabel('Time (sec)');
ylabel('u(t)');
grid on
hold on
subplot(212);
%figure(2)
plot(yptos(:,1),yptos(:,2));
axis([ 0 2.5*sqrt(r/N) 0 1.2*r]);
title('Output for the PTOS')
xlabel('Time (sec)');
ylabel('y(t)');
nicegrid
hold off
