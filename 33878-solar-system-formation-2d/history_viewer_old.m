load('history_734828928651');

n=1000;

r=hisrr(1,1:n,:);
hp=plot(r(1,:,1),r(1,:,2),'k.');
axis equal;
for lc=1:size(hisrr,2)/n
    r=hisrr(1,1+n*(lc-1):n*lc,:);
    %hp=plot(r(1,:,1),r(1,:,2),'k.');
    set(hp,'Xdata',r(1,:,1),'Ydata',r(1,:,2));
    drawnow;
end