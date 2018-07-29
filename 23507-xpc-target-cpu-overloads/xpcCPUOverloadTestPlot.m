% Plots results from CPUOverload tests.
% Note: Run the test model before invoking this script.

tg=xpc;

figure(1); clf;
subplot(3,1,1);
stem(tg.TimeLog,tg.TETLog,'*'); hold on;
plot([tg.TimeLog(1) tg.TimeLog(end)],[250e-6 250e-6],'r:');
ylabel('TET ( {\mu}s)');
title('CPU Overload Test Results')
subplot(3,1,2);
stem(tg.TimeLog,tg.OutputLog(:,1),'*');
ylabel('Trigger');
subplot(3,1,3);
plot(tg.TimeLog,tg.OutputLog(:,2));
ylabel('Counter');
xlabel('Time (sec)');
