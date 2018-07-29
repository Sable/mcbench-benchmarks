function PlotSeries(DatesChgs,Chgs,DatesChgsNoJumps,ChgsNoJumps,ChgsJumps,Name)
% jumps
figure % set up dates ticks
h=plot(DatesChgs,DatesChgs); 
a=get(gca,'XTick');
XTick = [];
years = year(DatesChgs(1)):year(DatesChgs(end));
for n = years
    XTick = [XTick datenum(n,1,1)];
end
a=min(DatesChgs); 
b=max(DatesChgs); 
X_Lim=[a-.01*(b-a) b+.01*(b-a)];
close

figure % plot series
subplot(3,1,1)
plot(DatesChgs,Chgs,'k')
set(gca,'ylim',[-.3 .3],'xlim',X_Lim,'XTick',XTick,'YTick',[]);
Datetick('x','yy','keeplimits','keepticks');
grid on
title('original series')

subplot(3,1,2)
plot(DatesChgsNoJumps,ChgsNoJumps,'k')
Datetick('x','yy','keeplimits','keepticks');
set(gca,'ylim',[-.3 .3],'xlim',X_Lim,'XTick',XTick,'YTick',[])
Datetick('x','yy','keeplimits','keepticks');
grid on
title('no jumps')

subplot(3,1,3) % plot events
h=plot(DatesChgs,cumsum(ChgsJumps),'k');
set(gca,'xlim',X_Lim,'XTick',XTick,'YTick',[]);
Datetick('x','yy','keeplimits','keepticks');
grid on
title('jumps only')
set(gcf,'Name',['        time series of daily changes in ' Name ' par swap rate'])
