% Script to plot flowrate error
% Copyright 2010 MathWorks, Inc.

diff_data = yout(:,1);
ref_data = yout(:,2);
control_signal_data = yout(:,3);

figure(1)
plot(control_signal_data,diff_data./max(ref_data)*100,'LineWidth',3);
title('Flow Rate Error','FontWeight','Bold','FontSize',16);
ylabel('Flow Rate Error (%)','FontSize',12)
xlabel('Control Signal','FontSize',12);
legend('(Ref-Sim)/Ref_m_a_x))*100','Location','Best');
grid on


