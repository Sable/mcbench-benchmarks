%
% Plot output power (Pout) vs. Switching frequency (Fsw)
%
% Reference: "High-Voltage Phase-Leg Modules for Medium Voltage Drives
% and Inverters", www.abb.com/semiconductors PCIM 12-408
%
% =====================================================================
% Manufacturer data for a 3-level inverter built with half-bridge IGBT
% modules (5SNG 0250P330300)
% Vdc= 2 x 1800 V (Vph= 2200V)
% cos(phi)= 0.85, m= 1, Fout= 50Hz, Tj_max= 125 deg. C), Ta= 40 deg. C)
% Rth= 0.072 K/W (air)
%
%     Fsw (Hz)     Pout (kW)
%
Pout_kW_ManufacturerData=[
       819	       411
       930.1	   380
       1067	       347
       1186	       318
       1349	       285
       1439	       268
       1535	       250
       1781	       212
       1877	       197
];
% =====================================================================
% Simulation results based on model: Loss_3Phase3Level_Inverter.mdl
% Pout_kW_SimulationResults = Maximum inverter output power vs. switching
% frequency while keeping IGBT1 (module 1) junction temperature at 125 degrees C.
%     Fsw (Hz)     Pout (kW)
Pout_kW_SimulationResults= [
        850        372
       1050	       323
       1250	       287
       1450	       273
       1650	       245
       1850	       211
];
% =====================================================================
% Plot comparison between manufacturer data vs. simulation results
figure
clf
plot(Pout_kW_ManufacturerData(:,1),Pout_kW_ManufacturerData(:,2),'blue')
hold on
plot(Pout_kW_SimulationResults(:,1),Pout_kW_SimulationResults(:,2),'+red')
grid
axis([ 800  2000  100 500 ])
xlabel('Fsw (Hz)')
ylabel('Pout (kW)')
title('Achievable 3-phase Output Power (at Tj=125C) vs. Switching Frequency')
legend('Manufacturer data','Simulation results','Location','NorthEast')

% =====================================================================
%
% end of file
