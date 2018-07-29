% Fig. 9.39   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

%script to plot the phase plane for a node
figure(1)
hold off
clf
for k=1:12;
    xdot = 1;
    x=(k-6)/5;
    sim('nodemodel');
    plot(xnode(:,2),xdotnode(:,2));
    hold on;
end
for k=1:12;
    xdot = -1;
    x=(k-6)/5;
    sim('nodemodel');
    plot(xnode(:,2),xdotnode(:,2));
    hold on;
end
title('Phase plane for a node');
xlabel('x_1');
ylabel('x_2');
gtext('s = -1')
gtext('s = -5')
plot([-1.5 1.5],[0 0]);
plot([0 0],[-1 1])
nicegrid;