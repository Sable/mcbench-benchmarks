a=tg.OutputLog;

subplot(3,1,1);plot(a(:,1));title('desired position (output shaft revs)');
subplot(3,1,2);plot(a(:,2));title('input (V)');
subplot(3,1,3);plot(a(:,3));title('output (output shaft rev)')
