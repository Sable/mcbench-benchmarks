%% Compare_Spice_SimPower
% compare LTSpice simulation results with SimPower
% Dick Benson
% Copyright 2013 The MathWorks, Inc.

% original version needed LTSPice2Matlab.m 
%LTS=LTspice2Matlab('EF_4.raw',[15,18]);
%plot(LTS.time_vect*1e9,LTS.variable_mat(1,:),'color',[0 0 1])
%LTS_Time_ns=LTS.time_vect*1e9;
%LTS_Node_Voltage=LTS.variable_mat(1,:);
%save('LTSpice_Result','LTS_Time_ns','LTS_Node_Voltage');
load LTSpice_Result
plot(LTS_Time_ns,LTS_Node_Voltage)
%  LTS.time_vect, LTS.variable_mat(2,:),'color',[0 1 0]);
hold on
%%
plot(Isw.time*1e9,Isw.signals.values(:,2),'color',[1 0 0])
% Isw.time,Isw.signals.values(:,1),'color',[1 0 1] )
hold off
ylabel('FET Drain Current Amps')
xlabel('Time in Nanoseconds');
legend('LTSpice','Simulink')
