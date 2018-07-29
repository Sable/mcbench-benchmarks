% Fig. 9.41   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

%script to plot the phase plane for a focus
figure(1)
hold off
clf
xdot = 0;
for k=1:6    
    x=-k/5;
    sim('focusmodel');
    plot(xfocus(:,2),xdotfocus(:,2));
    hold on;
end
for k=1:6
        x=k/5;
    sim('focusmodel');
    plot(xfocus(:,2),xdotfocus(:,2));
    hold on
end
title('Phase plane for a focus')
xlabel('x_1');
ylabel('x_2');
grid on
plot([-1.5 1.5],[0 0])
plot([0 0],[-4 4])