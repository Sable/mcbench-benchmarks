% Demo on parameters identification via TLS method
clear all; close all;
load dataHeater.txt 
XData=dataHeater(:,1); 
YData=dataHeater(:,2);
FTime = 600; Tvz=5;
LBa=[1.75 128 565]; UBa=[1.76 130 566];
[Err, min_param]=numerFminD(@dmodel2D, 3, LBa, UBa, XData, YData, FTime, Tvz)
[time, Yhat] = ode45(@(time,Yhat)dmodel2D(time,Yhat,min_param), [0:Tvz:FTime],[XData(1,1) YData(1,1)]);
figure
plot(XData,YData,'*');
hold on
plot(Yhat(:,1),Yhat(:,2),'k');
xlabel('y(t)');
ylabel('y^,(t)');
legend('Data','Model')
title('Measured state trajectory and model')
figure
plot([0:Tvz:FTime],XData, 'b*');
hold on
plot([0:Tvz:FTime],Yhat(:,1), 'k');
xlabel('Time [s]');
ylabel('y(t)');
legend('Data','Model')
title('Measured unit step response and model');
figure
plot([0:Tvz:FTime],YData, 'b*');
hold on
plot([0:Tvz:FTime],Yhat(:,2), 'k');
xlabel('Time [s]');
ylabel('y(t)');
legend('Data','Model')
title('Measured impulse response and model');
%