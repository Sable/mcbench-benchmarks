load('history_734829708443');


r=hisrr(1,:,:);
hp=plot(r(1,:,1),r(1,:,2),'k.');
axis equal;
for lc=1:3:size(hisrr,1)
    r=hisrr(lc,:,:);
    %hp=plot(r(1,:,1),r(1,:,2),'k.');
    set(hp,'Xdata',r(1,:,1),'Ydata',r(1,:,2));
    drawnow;
end