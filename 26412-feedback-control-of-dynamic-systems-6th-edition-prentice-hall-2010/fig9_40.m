% Fig. 9.40   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%
%script to plot the phase plane for a node with saturation
figure(1);
hold off;
clf;
xdot = -2;
for k=1:6;    
    x=-k;
    sim('satnodemodel');
    plot(xsat(:,2),xdotsat(:,2));
    hold on;
end
xdot = 2;
for k=1:6;
        x=k;
    sim('satnodemodel');
    plot(xsat(:,2),xdotsat(:,2));
    hold on;
end
xdot=-2;
for k=1:6;
        x=k;
    sim('satnodemodel');
    plot(xsat(:,2),xdotsat(:,2));
    hold on;
end
xdot = 2;
for k=1:6;
        x=-k;
    sim('satnodemodel')
    plot(xsat(:,2),xdotsat(:,2));
    hold on
end

title('Phase plane for a node with saturation')
xlabel('x_1');
ylabel('x_2');
plot([-8 8],[0 0])
plot([0 0],[-2 2])
nicegrid;