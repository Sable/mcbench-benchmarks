clear all;clc

a = [1 0 1 1 0 1 0 0 1 0 1];%---Bit stream
A = 1;  %---Amplitude
Tb = 10e-6; %---Bit time period

%---Get Unipolar NRZ
[x t] = LineEncoder('uninrz',a,Tb,A);
figure(1);
subplot(5,1,1);plot(t,x,'LineWidth',2);grid on;
title(['Unipolar NRZ line coding for ', num2str(a)]);
xlabel('Time in sec');
ylabel('Amplitude');
axis([0,max(t),min(x)-A,max(x)+A]);

%---Get Unipolar RZ
[x t] = LineEncoder('unirz',a,Tb,A);
subplot(5,1,2);plot(t,x,'LineWidth',2);grid on;
title(['Unipolar RZ line coding for ', num2str(a)]);
xlabel('Time in sec');
ylabel('Amplitude');
axis([0,max(t),min(x)-A,max(x)+A]);

%---Get Polar RZ
[x t] = LineEncoder('polrz',a,Tb,A);
subplot(5,1,3);plot(t,x,'LineWidth',2);grid on;
title(['Polar RZ line coding for ', num2str(a)]);
xlabel('Time in sec');
ylabel('Amplitude');
axis([0,max(t),min(x)-A,max(x)+A]);

%---Get Polar NRZ
[x t] = LineEncoder('polnrz',a,Tb,A);
subplot(5,1,4);plot(t,x,'LineWidth',2);grid on;
title(['Polar NRZ line coding for ', num2str(a)]);
xlabel('Time in sec');
ylabel('Amplitude');
axis([0,max(t),min(x)-A,max(x)+A]);

%---Get Manchester
[x t] = LineEncoder('manchester',a,Tb,A);
subplot(5,1,5);plot(t,x,'LineWidth',2);grid on;
title(['Manchester line coding for ', num2str(a)]);
xlabel('Time in sec');
ylabel('Amplitude');
axis([0,max(t),min(x)-A,max(x)+A]);