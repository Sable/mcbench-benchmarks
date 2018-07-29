function callnnpiter
% routine to call nnpiter
% load some data
load GBPdata1sShort
%x=diff(eurusd(1:300000,4));
N=round(length(bid)/1);
x = diff(0.5*(bid(1:N)+ask(1:N)));
tic
% parameters for the model
%window=25; d = 10; n=5;
%window=10; d = 3; n=5;
window=15; d = 3; n=10;
% evaluate the model and compute predictions and signal
xp2=zeros(length(x),1);
sig2=zeros(length(x),1);
clear persistent
% call the iterative nnpred routine
parfor i=1:length(x)
    [xp2(i),sig2(i)]=nnpiter(x(i),window,d,n,0);
end
% calculate the time for the backtest
toc
% calculate PnL
pnl = ([0;x(2:end).*sig2(1:end-1)-abs(diff(sig2))*0.000028]);
figure
subplot(3,1,1:2)
plot(cumsum(pnl)), grid on
subplot(3,1,3)
plot(abs(diff(sig2))), grid on, set(gca,'ylim',[-1 3]);
title([num2str(sum(abs(diff(sig2)))),' trades in ',...
    num2str(round(length(sig2)/(3600*11))),' days'])