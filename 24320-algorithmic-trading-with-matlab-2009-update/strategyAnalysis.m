function strategyAnalysis(t,p,pos,th,ph)
% plot the buy and sell signals on the data
ax=subplot(2,1,1);
plot(t,p,th,ph,'m'); grid on
title('price movements and buy(*)/sell(o) signals')
hold on
% buy signals
buyIndex = [~1;diff(pos)>=1];
plot(t(buyIndex),p(buyIndex),'kp','markersize',8,'markerfacecolor','k');
% sell signals
sellIndex =[~1;diff(pos)<=-1];
plot(t(sellIndex),p(sellIndex),'ro','markersize',8,'markerfacecolor','r');
hold off
ax(2)=subplot(2,1,2);
plot(t,pos),grid on, set(ax(2),'ylim',[-3 3]);
title('Position vector')
linkaxes(ax,'x')

