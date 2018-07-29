ax=[];
R=rsi2(Bund.Close,100);
R2=rsi2(Bund.Close-ema(Bund.Close,500),100);
ax=subplot(3,1,1);
plot(Close-ema(Close,500)); grid on
ax(2)=subplot(3,1,2);
plot(R), grid on
ax(3)=subplot(3,1,3);
plot(R2), grid on
linkaxes(ax,'x')