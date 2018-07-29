function AnimateTrajectory(x,y,z)

ax = newplot([]);
axis(ax,[min(x) max(x) min(y) max(y) min(z) max(z)])
%axis(ax,[0 max(x) 0 max(y) 0 max(z)])
head = line('parent',ax,'color','r','marker','.','markersize',15,'erase','xor', ...
    'xdata',x(1),'ydata',y(1),'zdata',z(1));
body = line('parent',ax,'color','b','linestyle','-','erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);
box on
%set(gca,'yDir','reverse')
% Grow the body
for i = 1:length(x)
    pause(.01)
    set(head,'xdata',x(i),'ydata',y(i),'zdata',z(i))
    set(body,'xdata',x(1:i),'ydata',y(1:i),'zdata',z(1:i))
end
