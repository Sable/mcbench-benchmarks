%Figure 9.23       Feedback Control of Dynamic Systems, 5e
%                      Franklin, Powell, Emami
% 
clf;
ka=10;
sim('fig9_22')
figure(1)
plot(uantib(:,1),uantib(:,2))
axis([0 10 -1.2 1.2])
hold on
figure(2)
plot(yantib(:,1),yantib(:,2))
hold on
ka=0;
sim('fig9_22')
figure(1)
plot(uantib(:,1),uantib(:,2))
grid on
title('Fig. 9.23(b) Control with and without antiwindup')
xlabel('Time (sec)');
ylabel('Control');
gtext('With anti-windup')
gtext('Without anti-winduup')
figure(2)
plot(yantib(:,1),yantib(:,2))
grid on
xlabel('Time (sec)');
ylabel('Output');
title('Fig. 9.23(a) Output with and without antiwindup')
gtext('With anti-windup')
gtext('Without anti-winduup')
hold off