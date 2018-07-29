%% Calculate some technical indicators
R=rsi2(Close,20);
stoch=stochosc(High,Low,Close);
[macdvec, nineperma] = macd(Close);
%% Plot the results - first a figure with price
figure; ax=axes;
X=(1:length(Close))';
plot(X,Close), grid on
%% A new figure with the indicators
figure
ax(2)=subplot(3,1,1);
plot(X,R), grid on
% set the y-limits for good visibility
set(ax(2),'ylim',[-10 110]);
ax(3)=subplot(3,1,2);
plot(X,[macdvec,nineperma]), grid on
ax(4)=subplot(3,1,3);
plot(X,stoch), grid on
set(ax(4),'ylim',[-10 110]);
%% link the axes together
linkaxes(ax,'x')
