% Script to produce plot explaining method of calculating phase in time
% domain.
% Copyright 2010 MathWorks, Inc.

figure(3)
clf
PLOT_DATA = Actuator_Freq_Direct_100p_DATA;

time_data = PLOT_DATA.time;
input_signal = PLOT_DATA.signals.values(:,1);
output_signal = PLOT_DATA.signals.values(:,2);

lin1_h = plot(time_data,input_signal,'b','LineWidth',3);
hold on
lin2_h = plot(time_data,output_signal,'LineStyle','--','Color',[0 0.2 0],'LineWidth',3);
set(lin2_h,'Color',[0 0.5 0]);
hold off
title('Calculating Phase in Time Domain','FontWeight','Bold','FontSize',16);
xlabel('Time (s)','FontSize',14);
ylabel('Signal Level','FontSize',14)
legend({'Input Signal' 'Output Signal'},'FontSize',12);
grid on;
axis([0.4 0.52 -10 10]);





