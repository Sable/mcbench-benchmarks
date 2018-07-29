function update_plots
global hnds
global r nn asz G ps
global hpb ht hi

ax1=hnds.axes1;
ax2=hnds.axes2;

cla(ax1);
cla(ax2);

nn=str2num(get(hnds.nn,'string')); % number of cities
ps=str2num(get(hnds.ps,'string')); % population size

% to plot best path:
hpb=plot(NaN,NaN,'r-','parent',ax1);
ht=title(ax1,' ');

set(ax1,'NextPlot','add');

% plot nodes numbers
for n=1:nn
    text(r(1,n),r(2,n),num2str(n),'color',[0.7 0.7 0.7],'parent',ax1);
end

plot(r(1,:),r(2,:),'k.','parent',ax1); % plot cities as black dots



axis(ax1,'equal');
set(ax1,'xlim',[-0.1*asz 1.1*asz]);
set(ax1,'ylim',[-0.1*asz 1.1*asz]);



hi=imagesc(G,'parent',ax2);
title(ax2,'color is city number');
colorbar('peer',ax2);
xlabel(ax2,'index in sequence of cities');
ylabel(ax2,'path number');