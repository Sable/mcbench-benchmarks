% Plot analog signal values
% Copyright 2001-2013 The MathWorks, Inc.

h1=subplot(3,1,1);
plot(analog.time,analog.signals.values,'b')
title('Analog Signal')
%xlabel('time(s)')
set(gca,'XTick',[]);
a=axis;
axis([a(1) a(2) -1.3 1.3]);

h1=subplot(3,1,2);
% plot(analog.time,analog.signals.values,'-b')
hold on
stairs(digital1.time,digital1.signals.values,'-r')
stairs(digital2.time,digital2.signals.values,'-g')
title('Digital Signals:   red = modulator output,   green = 1st filter output')
%xlabel('time(s)')
set(gca,'XTick',[]);
a=axis;
axis([a(1) a(2) -1.3 1.3]);

%a1=axis; endtime1=a1(2);
hold off

% Plot time step size v time on second axis
h2=subplot(3,1,3);
semilogy(analog.time(1:end-1),diff(analog.time),'k-'),title('Step size'),ylabel('Step size(s)'),xlabel('time(s)')
axis([0 .004 1e-21 1e-5])
set(gca,'Ytick',[ 1e-020 1e-015 1e-010 1e-005 ])
%a2=axis; a2(2)=endtime1;axis(a2)