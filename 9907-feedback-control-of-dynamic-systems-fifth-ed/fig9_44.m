% Fig. 9.44   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

% script to run the time optimal system
% and plot the results
r=4;
sim('tos_sim');
figure(2)
subplot(211) 
plot(utos(:,1),utos(:,2));
axis([0 6 -1.2 1.2]); grid on;
title('Control for the time optimal system');
xlabel('Time (sec)');
ylabel('u(t)');
subplot(212); plot(ytos(:,1),ytos(:,2));
grid on;
axis([ 0 5 0 5]);
title('Output for the Time Optimal System');
xlabel('Time (sec)')
ylabel('y(t)')
hold off