% Demo on Nonlinear regression models via TLS and classical LS method
clear all; close all;
load dataNRM.txt;
xdata=dataNRM(1,:);
ydata=dataNRM(2,:);
par_number = 3;
[ErrTLS,P1]=numerFminS(@model,par_number,[-0.05 0.5 9.5], [-0.04 0.7 10.0], xdata, ydata)
YhatTLS=polyval(P1(1:par_number),xdata);
Index_TLS = corrindex(xdata, ydata, YhatTLS, par_number)
P2=polyfit(xdata,ydata,2)
YhatLS=polyval(P2,xdata);
Index_LS = corrindex(xdata, ydata, YhatLS, par_number)
plot(xdata, ydata, '*');
hold on
plot(xdata,YhatTLS,'k');
hold on
plot(xdata,YhatLS,'r');
xlabel('x');
ylabel('y');
legend('Data','Model (TLS)', 'Model (LS)');
%