% Demo on Linear regression models via TLS and classical LS method
clear all; close all;
load dataLRM.txt;
xdata=dataLRM(1,:);
ydata=dataLRM(2,:);
[ErrTLS, P1] = fit_2D_data(xdata, ydata, 'no')
YhatTLS=polyval(P1,xdata);
[F_TLS, Srez_TLS, Scel_TLS] = statindexes(xdata, ydata, P1(2), P1(1))
P2=polyfit(xdata, ydata, 1)
YhatLS=polyval(P2,xdata);
ErrLS=sum((YhatLS-ydata).^2)
[F_LS, Srez_LS, Scel_LS] = statindexes(xdata, ydata, P2(2), P2(1))
plot(xdata, ydata, '*');
hold on
plot(xdata,YhatTLS,'k');
hold on
plot(xdata,YhatLS,'r');
xlabel('x');
ylabel('y');
legend('Data','Model (TLS)', 'Model (LS)');
%