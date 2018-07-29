%test_VAcPlant(t, ID) is an example, which shows how to use the VAModel in MATLAB
%In this example, Luyben's multi-loop control structure is implemented and tested
%Eight process disturbances are available and transients are generated at the end of simulation
%On a PIII-1GHz PC, the VA plant model runs approaximately 80 times faster than the real time
%To use this example: 
%       t sets the simulation time (in munite) 
%       ID is an integer selected between 0 and 8
%           0: no disturbance 
%           1: setpoint of the reactor outlet temperature decreases 8 degC (from 159 to 151)
%           2: setpoint of the reactor outlet temperature increases 6 degC (from 159 to 165)
%           3: setpoint of the H2O composition in the column bottom increases 9% (from 9% to 18%)
%           4: the vaporizer liqiud inlet flowrate increases 0.44 kmol/min (from 2.2 to 2.64)
%           5: HAc fresh feed stream lost for 5 minutes
%           6: O2 fresh feed stream lost for 5 minutes
%           7: C2H6 composition changes from 0.001 to 0.003 in the C2H4 fresh feed stream
%           8: column feed lost for 5 minutes
%       Note: in this example, all the disturbances occur at 10 minute after the simulation starts
%-----------------------------------------------------------------------------
%Copyright: Rong Chen and Kedar David, June 2002
%-----------------------------------------------------------------------------
function test_VAcPlant(minute,selected_ID)

%-----------------------------------------------------------------------------
close all
format short g
%-----------------------------------------------------------------------------

%-----------------------------------------------------------------------------
%The recommended simulation sampling time is 1/3 second, which corresponds to a frequency of 180 samples in one minute 
model_sampling_frequency=180; 
%The recommended historical data sampling time is 1 minute, which corresponds to a frequency of 1 sample in one minute 
storage_sampling_frequency=1;
%The recommended display sampling time is 1 minute, which corresponds to a frequency of 1 sample in one minute 
display_sampling_frequency=1;
%-----------------------------------------------------------------------------

%-----------------------------------------------------------------------------
% Inintialze process states and MV's
% 246 state variables
states=zeros(246,1);
% 26 manipulated variables
MVs=zeros(26,1);
% set the current process time to 0 (in minute)
time=0;
% set initialization flag 1
is_initial=1;
% set disturbance_ID 0
disturbance_ID=0;
% get the base operation
[dstatedt,states,MVs,y_ss]=VAModel(states,MVs,time,is_initial,disturbance_ID);
%-----------------------------------------------------------------------------

%-----------------------------------------------------------------------------
% Implement Luyben and Tyreus's control structure for the VA plant
% Note that: in this example,  
%   1. for each transmitter, a 3 second time lag is used
%   2. for two analyzer transmitters (on the gas recycle and column bottom), a 10 minute deadtime is used
%   3. for other transmitters, no deadtime is used
%   4. for three controllers using analyzers on the gas recycle and column bottom, a 10 minute sampling time is used
%   5. for other controllers, a 1 second sampling time is used
%   6. for each transmitter, a 1 second sampling time is used
%-----------------------------------------------------------------------------
transmitter_lag=0.05; %in minute
transmitter_deadtime=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10 10 0 10 0 0 0 0 0 0]; %in minute
transmitter_sampling_frequency=[60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60];
controller_sampling_frequency=[60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 0.1 0.1 60 0.1 60 60 60 60 60 60];
%-----------------------------------------------------------------------------
%transmitter and controller initialization
%SP: setpoint (not scaled)
%K: controller gain which is dimentionless
%Ti: reset time (in minute)
%act: 1 if positive process gain, -1 if negative process gain 
%mode: 1 for automatic, 2 for manual
%Ponly: 1 for proportional only control, 0 for PI control
%hc: controller sampling time (in minute), should be 1/"controller_sampling_frequency"
%ht: transmitter sampling time (in minute), should be 1/"transmitter_sampling_frequency"
%uLO: low limit of MV
%uHI: high limit of MV
%ded: should be "transmitter_deadtime" defined above
%tau: should be "transmitter_lag" defined above
%yLO: low limit of measurement
%yHI: high limit of measurement
%Nded: measurement deadtime storage, which should be 1+transmitter_deadtime*transmitter_sampling_frequency
%Ntau: measurement time constant storage, which should be 1 all the time
%-----------------------------------------------------------------------------
%MV1: F_O2 - O2 composition
SP_O2=0.075;
K_O2=5;
Ti_O2=10; 
act_O2=1;
mode_O2=1;
Ponly_O2=0;
ht_O2=1/transmitter_sampling_frequency(1);
hc_O2=1/controller_sampling_frequency(1);
uLO_O2=0;
uHI_O2=2.268;
ded_O2=transmitter_deadtime(1);
tau_O2=transmitter_lag;
yLO_O2=0;
yHI_O2=0.2;
Nded_O2=1+transmitter_deadtime(1)*transmitter_sampling_frequency(1);
Ntau_O2=1;
xxx_O2(1)= (y_ss(37) -yLO_O2) / (yHI_O2 -yLO_O2);
for i=2:Nded_O2
    xxx_O2(i)=xxx_O2(1);
end
for i=1:Ntau_O2
    yyy_O2(i)= xxx_O2(Nded_O2);
end
xi_O2= (MVs(1) - uLO_O2) /(uHI_O2 -uLO_O2)-K_O2*act_O2*((SP_O2-yLO_O2)/(yHI_O2-yLO_O2)-yyy_O2(Ntau_O2));
%-----------------------------------------------------------------------------
%controller initialization
%MV2: F_C2H4 - Recycle Pressure
SP_C2H4=128;
K_C2H4=0.3;
Ti_C2H4=20; 
act_C2H4=1;
mode_C2H4=1;
Ponly_C2H4=0;
ht_C2H4=1/transmitter_sampling_frequency(2);
hc_C2H4=1/controller_sampling_frequency(2);
uLO_C2H4=0;
uHI_C2H4=7.56;
ded_C2H4=transmitter_deadtime(2);
tau_C2H4=transmitter_lag;
yLO_C2H4=0;
yHI_C2H4=200;
Nded_C2H4=1+transmitter_deadtime(2)*transmitter_sampling_frequency(2);
Ntau_C2H4=1;
xxx_C2H4(1)= (y_ss(12) -yLO_C2H4) / (yHI_C2H4 -yLO_C2H4);
for i=2:Nded_C2H4
    xxx_C2H4(i)= xxx_C2H4(1);
end
for i=1:Ntau_C2H4
    yyy_C2H4(i)= xxx_C2H4(Nded_C2H4);
end
xi_C2H4= (MVs(2) - uLO_C2H4) /(uHI_C2H4 -uLO_C2H4)-K_C2H4*act_C2H4*((SP_C2H4-yLO_C2H4)/(yHI_C2H4-yLO_C2H4)-yyy_C2H4(Ntau_C2H4));
%-----------------------------------------------------------------------------
%controller initialization
%MV3: HAc feed stream - HAc tank level
SP_HAc=0.5;
K_HAc=2;
Ti_HAc=100; 
act_HAc=1;
mode_HAc=1;
Ponly_HAc=1;
ht_HAc=1/transmitter_sampling_frequency(3);
hc_HAc=1/controller_sampling_frequency(3);
uLO_HAc=0;
uHI_HAc=4.536;
ded_HAc=transmitter_deadtime(3);
tau_HAc=transmitter_lag;
yLO_HAc=0;
yHI_HAc=1;
Nded_HAc=1+transmitter_deadtime(3)*transmitter_sampling_frequency(3);
Ntau_HAc=1;
xxx_HAc(1)= (y_ss(23) -yLO_HAc) / (yHI_HAc -yLO_HAc);
for i=2:Nded_HAc
    xxx_HAc(i)= xxx_HAc(1);
end
for i=1:Ntau_HAc
    yyy_HAc(i)= xxx_HAc(Nded_HAc);
end
xi_HAc= (MVs(3) - uLO_HAc) /(uHI_HAc -uLO_HAc)-K_HAc*act_HAc*((SP_HAc-yLO_HAc)/(yHI_HAc-yLO_HAc)-yyy_HAc(Ntau_HAc));
%-----------------------------------------------------------------------------
%controller initialization
%MV4: Qv - Level
SP_LevelVap=0.7;
K_LevelVap=0.1;
Ti_LevelVap=30; 
act_LevelVap=-1;
mode_LevelVap=1;
Ponly_LevelVap=0;
ht_LevelVap=1/transmitter_sampling_frequency(4);
hc_LevelVap=1/controller_sampling_frequency(4);
uLO_LevelVap=0;
uHI_LevelVap=1433400;  
ded_LevelVap=transmitter_deadtime(4);
tau_LevelVap=transmitter_lag;
yLO_LevelVap=0;
yHI_LevelVap=1;
Nded_LevelVap=1+transmitter_deadtime(4)*transmitter_sampling_frequency(4);
Ntau_LevelVap=1;
xxx_LevelVap(1)= (y_ss(2) -yLO_LevelVap) / (yHI_LevelVap -yLO_LevelVap);
for i=2:Nded_LevelVap
    xxx_LevelVap(i)= xxx_LevelVap(1);
end
for i=1:Ntau_LevelVap
    yyy_LevelVap(i)= xxx_LevelVap(Nded_LevelVap);
end
xi_LevelVap= (MVs(4) - uLO_LevelVap) /(uHI_LevelVap -uLO_LevelVap)-K_LevelVap*act_LevelVap*((SP_LevelVap-yLO_LevelVap)/(yHI_LevelVap-yLO_LevelVap)-yyy_LevelVap(Ntau_LevelVap));
%-----------------------------------------------------------------------------
%controller initialization
%MV5: F_Vaporizer - Vaporizer Pressure
SP_PresVap=128;
K_PresVap=5;
Ti_PresVap=10;
act_PresVap=-1;
mode_PresVap=1;
Ponly_PresVap=0;
ht_PresVap=1/transmitter_sampling_frequency(5);
hc_PresVap=1/controller_sampling_frequency(5);
uLO_PresVap=0;
uHI_PresVap=50;
ded_PresVap=transmitter_deadtime(5);
tau_PresVap=transmitter_lag;
yLO_PresVap=0;
yHI_PresVap=200;
Nded_PresVap=1+transmitter_deadtime(5)*transmitter_sampling_frequency(5);
Ntau_PresVap=1;
xxx_PresVap(1)= (y_ss(1) -yLO_PresVap) / (yHI_PresVap -yLO_PresVap);
for i=2:Nded_PresVap
    xxx_PresVap(i)= xxx_PresVap(1);
end
for i=1:Ntau_PresVap
    yyy_PresVap(i)= xxx_PresVap(Nded_PresVap);
end
xi_PresVap= (MVs(5) - uLO_PresVap) /(uHI_PresVap -uLO_PresVap)-K_PresVap*act_PresVap*((SP_PresVap-yLO_PresVap)/(yHI_PresVap-yLO_PresVap)-yyy_PresVap(Ntau_PresVap));
%-----------------------------------------------------------------------------
%controller initialization
%MV6: Q_heater - Vaporizer Outlet Temperature
SP_ReactorInletTemp=150;
K_ReactorInletTemp=1;
Ti_ReactorInletTemp=5; 
act_ReactorInletTemp=1;
mode_ReactorInletTemp=1;
Ponly_ReactorInletTemp=0;
ht_ReactorInletTemp=1/transmitter_sampling_frequency(6);
hc_ReactorInletTemp=1/controller_sampling_frequency(6);
uLO_ReactorInletTemp=0;
uHI_ReactorInletTemp=15000;
ded_ReactorInletTemp=transmitter_deadtime(6);
tau_ReactorInletTemp=transmitter_lag;
yLO_ReactorInletTemp=120;
yHI_ReactorInletTemp=170;
Nded_ReactorInletTemp=1+transmitter_deadtime(6)*transmitter_sampling_frequency(6);
Ntau_ReactorInletTemp=1;
xxx_ReactorInletTemp(1)= (y_ss(4) -yLO_ReactorInletTemp) / (yHI_ReactorInletTemp -yLO_ReactorInletTemp);
for i=2:Nded_ReactorInletTemp
    xxx_ReactorInletTemp(i)= xxx_ReactorInletTemp(1);
end
for i=1:Ntau_ReactorInletTemp
    yyy_ReactorInletTemp(i)= xxx_ReactorInletTemp(Nded_ReactorInletTemp);
end
xi_ReactorInletTemp= (MVs(6) - uLO_ReactorInletTemp) /(uHI_ReactorInletTemp -uLO_ReactorInletTemp)-K_ReactorInletTemp*act_ReactorInletTemp*((SP_ReactorInletTemp-yLO_ReactorInletTemp)/(yHI_ReactorInletTemp-yLO_ReactorInletTemp)-yyy_ReactorInletTemp(Ntau_ReactorInletTemp));
%-----------------------------------------------------------------------------
%controller initialization
%MV7: T_Shell - T_RCTOUT
SP_TRCT=159.17;
K_TRCT=3;
Ti_TRCT=10; 
act_TRCT=1;
mode_TRCT=1;
Ponly_TRCT=0;
ht_TRCT=1/transmitter_sampling_frequency(7);
hc_TRCT=1/controller_sampling_frequency(7);
uLO_TRCT=110;
uHI_TRCT=150;
ded_TRCT=transmitter_deadtime(7);
tau_TRCT=transmitter_lag;
yLO_TRCT=0;
yHI_TRCT=200;
Nded_TRCT=1+transmitter_deadtime(7)*transmitter_sampling_frequency(7);
Ntau_TRCT=1;
xxx_TRCT(1)= (y_ss(5)-yLO_TRCT) / (yHI_TRCT -yLO_TRCT);
for i=2:Nded_TRCT
    xxx_TRCT(i)= xxx_TRCT(1);
end
for i=1:Ntau_TRCT
    yyy_TRCT(i)= xxx_TRCT(Nded_TRCT);
end
xi_TRCT= (MVs(7) - uLO_TRCT) /(uHI_TRCT -uLO_TRCT)-K_TRCT*act_TRCT*((SP_TRCT-yLO_TRCT)/(yHI_TRCT-yLO_TRCT)-yyy_TRCT(Ntau_TRCT));
%-----------------------------------------------------------------------------
%controller initialization
%MV8: Separator Liquid Exit - Separator Level
SP_LevelSep=0.5;
K_LevelSep=5;
Ti_LevelSep=100; 
act_LevelSep=-1;
mode_LevelSep=1;
Ponly_LevelSep=1;
ht_LevelSep=1/transmitter_sampling_frequency(8);
hc_LevelSep=1/controller_sampling_frequency(8);
uLO_LevelSep=0;
uHI_LevelSep=4.536;
ded_LevelSep=transmitter_deadtime(8);
tau_LevelSep=transmitter_lag;
yLO_LevelSep=0; 
yHI_LevelSep=1; 
Nded_LevelSep=1+transmitter_deadtime(8)*transmitter_sampling_frequency(8);
Ntau_LevelSep=1;
xxx_LevelSep(1)= (y_ss(9)-yLO_LevelSep) / (yHI_LevelSep -yLO_LevelSep);
for i=2:Nded_LevelSep
    xxx_LevelSep(i)= xxx_LevelSep(1);
end
for i=1:Ntau_LevelSep
    yyy_LevelSep(i)= xxx_LevelSep(Nded_LevelSep);
end
xi_LevelSep= (MVs(8) - uLO_LevelSep) /(uHI_LevelSep -uLO_LevelSep)-K_LevelSep*act_LevelSep*((SP_LevelSep-yLO_LevelSep)/(yHI_LevelSep-yLO_LevelSep)-yyy_LevelSep(Ntau_LevelSep));
%-----------------------------------------------------------------------------
%controller initialization
%MV9: T_Shell_Separator - Separator Liquid Temperature
SP_TempSep=40;
K_TempSep=5;
Ti_TempSep=20; 
act_TempSep=-1;
mode_TempSep=1;
Ponly_TempSep=0;
ht_TempSep=1/transmitter_sampling_frequency(9);
hc_TempSep=1/controller_sampling_frequency(9);
uLO_TempSep=0;
uHI_TempSep=80;
ded_TempSep=transmitter_deadtime(9);
tau_TempSep=transmitter_lag;
yLO_TempSep=0; 
yHI_TempSep=80; 
Nded_TempSep=1+transmitter_deadtime(9)*transmitter_sampling_frequency(9);
Ntau_TempSep=1;
xxx_TempSep(1)= (y_ss(10)-yLO_TempSep) / (yHI_TempSep -yLO_TempSep);
for i=2:Nded_TempSep
    xxx_TempSep(i)= xxx_TempSep(1);
end
for i=1:Ntau_TempSep
    yyy_TempSep(i)= xxx_TempSep(Nded_TempSep);
end
xi_TempSep= (MVs(9) - uLO_TempSep) /(uHI_TempSep -uLO_TempSep)-K_TempSep*act_TempSep*((SP_TempSep-yLO_TempSep)/(yHI_TempSep-yLO_TempSep)-yyy_TempSep(Ntau_TempSep));
%-----------------------------------------------------------------------------
%controller initialization
%MV10: Separator Vapor Exit is fixed at 16.1026 kmol/min
%-----------------------------------------------------------------------------
%controller initialization
%MV11: Q_Compressor_Cooler - Compressor Outlet Temperature (80degC)
SP_CompOutletTemp=80;
K_CompOutletTemp=1;
Ti_CompOutletTemp=5; 
act_CompOutletTemp=-1;
mode_CompOutletTemp=1;
Ponly_CompOutletTemp=0;
ht_CompOutletTemp=1/transmitter_sampling_frequency(11);
hc_CompOutletTemp=1/controller_sampling_frequency(11);
uLO_CompOutletTemp=0;
uHI_CompOutletTemp=50000;
ded_CompOutletTemp=transmitter_deadtime(11);
tau_CompOutletTemp=transmitter_lag;
yLO_CompOutletTemp=70;
yHI_CompOutletTemp=90;
Nded_CompOutletTemp=1+transmitter_deadtime(11)*transmitter_sampling_frequency(11);
Ntau_CompOutletTemp=1;
xxx_CompOutletTemp(1)= (y_ss(11) -yLO_CompOutletTemp) / (yHI_CompOutletTemp -yLO_CompOutletTemp);
for i=2:Nded_CompOutletTemp
    xxx_CompOutletTemp(i)= xxx_CompOutletTemp(1);
end
for i=1:Ntau_CompOutletTemp
    yyy_CompOutletTemp(i)= xxx_CompOutletTemp(Nded_CompOutletTemp);
end
xi_CompOutletTemp= (MVs(11) - uLO_CompOutletTemp) /(uHI_CompOutletTemp -uLO_CompOutletTemp)-K_CompOutletTemp*act_CompOutletTemp*((SP_CompOutletTemp-yLO_CompOutletTemp)/(yHI_CompOutletTemp-yLO_CompOutletTemp)-yyy_CompOutletTemp(Ntau_CompOutletTemp));
%-----------------------------------------------------------------------------
%controller initialization
%MV12: Absorber Liquid Exit - Absorber Level
SP_LevelAbs=0.5;
K_LevelAbs=5;
Ti_LevelAbs=100; 
act_LevelAbs=-1;
mode_LevelAbs=1;
Ponly_LevelAbs=1;
ht_LevelAbs=1/transmitter_sampling_frequency(12);
hc_LevelAbs=1/controller_sampling_frequency(12);
uLO_LevelAbs=0;
uHI_LevelAbs=4.536;
ded_LevelAbs=transmitter_deadtime(12);
tau_LevelAbs=transmitter_lag;
yLO_LevelAbs=0;
yHI_LevelAbs=1;
Nded_LevelAbs=1+transmitter_deadtime(12)*transmitter_sampling_frequency(12);
Ntau_LevelAbs=1;
xxx_LevelAbs(1)= (y_ss(13)-yLO_LevelAbs) / (yHI_LevelAbs -yLO_LevelAbs);
for i=2:Nded_LevelAbs
    xxx_LevelAbs(i)= xxx_LevelAbs(1);
end
for i=1:Ntau_LevelAbs
    yyy_LevelAbs(i)= xxx_LevelAbs(Nded_LevelAbs);
end
xi_LevelAbs= (MVs(12) - uLO_LevelAbs) /(uHI_LevelAbs -uLO_LevelAbs)-K_LevelAbs*act_LevelAbs*((SP_LevelAbs-yLO_LevelAbs)/(yHI_LevelAbs-yLO_LevelAbs)-yyy_LevelAbs(Ntau_LevelAbs));
%-----------------------------------------------------------------------------
%controller initialization
%MV13: Circulation Flowrate is fixed to 15.1198 kmol/min
%-----------------------------------------------------------------------------
%controller initialization
%MV14: Q_Cooler_Circulation - Circulation Temperature
SP_CircOutletTemp=25;
K_CircOutletTemp=1;
Ti_CircOutletTemp=5; 
act_CircOutletTemp=-1;
mode_CircOutletTemp=1;
Ponly_CircOutletTemp=0;
ht_CircOutletTemp=1/transmitter_sampling_frequency(14);
hc_CircOutletTemp=1/controller_sampling_frequency(14);
uLO_CircOutletTemp=0;
uHI_CircOutletTemp=30000;
ded_CircOutletTemp=transmitter_deadtime(14);
tau_CircOutletTemp=transmitter_lag;
yLO_CircOutletTemp=10;
yHI_CircOutletTemp=40;
Nded_CircOutletTemp=1+transmitter_deadtime(14)*transmitter_sampling_frequency(14);
Ntau_CircOutletTemp=1;
xxx_CircOutletTemp(1)= (y_ss(14) -yLO_CircOutletTemp) / (yHI_CircOutletTemp -yLO_CircOutletTemp);
for i=2:Nded_CircOutletTemp
    xxx_CircOutletTemp(i)= xxx_CircOutletTemp(1);
end
for i=1:Ntau_CircOutletTemp
    yyy_CircOutletTemp(i)= xxx_CircOutletTemp(Nded_CircOutletTemp);
end
xi_CircOutletTemp= (MVs(14) - uLO_CircOutletTemp) /(uHI_CircOutletTemp -uLO_CircOutletTemp)-K_CircOutletTemp*act_CircOutletTemp*((SP_CircOutletTemp-yLO_CircOutletTemp)/(yHI_CircOutletTemp-yLO_CircOutletTemp)-yyy_CircOutletTemp(Ntau_CircOutletTemp));
%-----------------------------------------------------------------------------
%controller initialization
%MV15: Scrub Flowrate is fixed to 0.756 kmol/min
%-----------------------------------------------------------------------------
%controller initialization
%MV16: Q_Cooler_Scrub - Scrub Temperature
SP_ScrubOutletTemp=25;
K_ScrubOutletTemp=1;
Ti_ScrubOutletTemp=5; 
act_ScrubOutletTemp=-1;
mode_ScrubOutletTemp=1;
Ponly_ScrubOutletTemp=0;
ht_ScrubOutletTemp=1/transmitter_sampling_frequency(16);
hc_ScrubOutletTemp=1/controller_sampling_frequency(16);
uLO_ScrubOutletTemp=0;
uHI_ScrubOutletTemp=5000;
ded_ScrubOutletTemp=transmitter_deadtime(16);
tau_ScrubOutletTemp=transmitter_lag;
yLO_ScrubOutletTemp=10;
yHI_ScrubOutletTemp=40;
Nded_ScrubOutletTemp=1+transmitter_deadtime(16)*transmitter_sampling_frequency(16);
Ntau_ScrubOutletTemp=1;
xxx_ScrubOutletTemp(1)= (y_ss(15) -yLO_ScrubOutletTemp) / (yHI_ScrubOutletTemp -yLO_ScrubOutletTemp);
for i=2:Nded_ScrubOutletTemp
    xxx_ScrubOutletTemp(i)= xxx_ScrubOutletTemp(1);
end
for i=1:Ntau_ScrubOutletTemp
    yyy_ScrubOutletTemp(i)= xxx_ScrubOutletTemp(Nded_ScrubOutletTemp);
end
xi_ScrubOutletTemp= (MVs(16) - uLO_ScrubOutletTemp) /(uHI_ScrubOutletTemp -uLO_ScrubOutletTemp)-K_ScrubOutletTemp*act_ScrubOutletTemp*((SP_ScrubOutletTemp-yLO_ScrubOutletTemp)/(yHI_ScrubOutletTemp-yLO_ScrubOutletTemp)-yyy_ScrubOutletTemp(Ntau_ScrubOutletTemp));
%-----------------------------------------------------------------------------
%controller initialization
%MV17: CO2 - CO2 composition
SP_CO2=0.0076393;
K_CO2=1;
Ti_CO2=100; 
act_CO2=-1;
mode_CO2=1;
Ponly_CO2=1;
ht_CO2=1/transmitter_sampling_frequency(17);
hc_CO2=1/controller_sampling_frequency(17);
uLO_CO2=0;
uHI_CO2=22.68;
ded_CO2=transmitter_deadtime(17);
tau_CO2=transmitter_lag;
yLO_CO2=0;
yHI_CO2=0.5;
Nded_CO2=1+transmitter_deadtime(17)*transmitter_sampling_frequency(17);
Ntau_CO2=1;
xxx_CO2(1)= (y_ss(31) -yLO_CO2) / (yHI_CO2 -yLO_CO2);
for i=2:Nded_CO2
    xxx_CO2(i)= xxx_CO2(1);
end
for i=1:Ntau_CO2
    yyy_CO2(i)= xxx_CO2(Nded_CO2);
end
xi_CO2= (MVs(17) - uLO_CO2) /(uHI_CO2 -uLO_CO2)-K_CO2*act_CO2*((SP_CO2-yLO_CO2)/(yHI_CO2-yLO_CO2)-yyy_CO2(Ntau_CO2));
%-----------------------------------------------------------------------------
%controller initialization
%MV18: Purge - C2H6 composition
SP_C2H6=0.25;
K_C2H6=1;
Ti_C2H6=100; 
act_C2H6=-1;
mode_C2H6=1;
Ponly_C2H6=1;
ht_C2H6=1/transmitter_sampling_frequency(18);
hc_C2H6=1/controller_sampling_frequency(18);
uLO_C2H6=0;
uHI_C2H6=0.02268;
ded_C2H6=transmitter_deadtime(18);
tau_C2H6=transmitter_lag;
yLO_C2H6=0;
yHI_C2H6=1;
Nded_C2H6=1+transmitter_deadtime(18)*transmitter_sampling_frequency(18);
Ntau_C2H6=1;
xxx_C2H6(1)= (y_ss(33) -yLO_C2H6) / (yHI_C2H6 -yLO_C2H6);
for i=2:Nded_C2H6
    xxx_C2H6(i)= xxx_C2H6(1);
end
for i=1:Ntau_C2H6
    yyy_C2H6(i)= xxx_C2H6(Nded_C2H6);
end
xi_C2H6= (MVs(18) - uLO_C2H6) /(uHI_C2H6 -uLO_C2H6)-K_C2H6*act_C2H6*((SP_C2H6-yLO_C2H6)/(yHI_C2H6-yLO_C2H6)-yyy_C2H6(Ntau_C2H6));
%-----------------------------------------------------------------------------
%controller initialization
%MV19: bypass - FEHE Cold Exit Temp
SP_FEHE=134;
K_FEHE=5;
Ti_FEHE=10; 
act_FEHE=1;
mode_FEHE=1;
Ponly_FEHE=0;
ht_FEHE=1/transmitter_sampling_frequency(19);
hc_FEHE=1/controller_sampling_frequency(19);
uLO_FEHE=0;
uHI_FEHE=1;
ded_FEHE=transmitter_deadtime(19);
tau_FEHE=transmitter_lag;
yLO_FEHE=0;
yHI_FEHE=200;
Nded_FEHE=1+transmitter_deadtime(19)*transmitter_sampling_frequency(19);
Ntau_FEHE=1;
xxx_FEHE(1)= (y_ss(8) -yLO_FEHE) / (yHI_FEHE -yLO_FEHE);
for i=2:Nded_FEHE
    xxx_FEHE(i)= xxx_FEHE(1);
end
for i=1:Ntau_FEHE
    yyy_FEHE(i)= xxx_FEHE(Nded_FEHE);
end
xi_FEHE= (MVs(19) - uLO_FEHE) /(uHI_FEHE -uLO_FEHE)-K_FEHE*act_FEHE*((SP_FEHE-yLO_FEHE)/(yHI_FEHE-yLO_FEHE)-yyy_FEHE(Ntau_FEHE));
%-----------------------------------------------------------------------------
%controller initialization
%MV20: LR - %H2O in bottom
SP_H2OCol=0.09344;
K_H2OCol=0.5;
Ti_H2OCol=60;
act_H2OCol=-1;
mode_H2OCol=1;
Ponly_H2OCol=0;
ht_H2OCol=1/transmitter_sampling_frequency(20);
hc_H2OCol=1/controller_sampling_frequency(20);
uLO_H2OCol=0;
uHI_H2OCol=7.56;
ded_H2OCol=transmitter_deadtime(20);
tau_H2OCol=transmitter_lag;
yLO_H2OCol=0;
yHI_H2OCol=0.2;
Nded_H2OCol=1+transmitter_deadtime(20)*transmitter_sampling_frequency(20);
Ntau_H2OCol=1;
xxx_H2OCol(1)= (y_ss(28) -yLO_H2OCol) / (yHI_H2OCol -yLO_H2OCol);
for i=2:Nded_H2OCol
    xxx_H2OCol(i)= xxx_H2OCol(1);
end
for i=1:Ntau_H2OCol
    yyy_H2OCol(i)= xxx_H2OCol(Nded_H2OCol);
end
xi_H2OCol= (MVs(20) - uLO_H2OCol) /(uHI_H2OCol -uLO_H2OCol)-K_H2OCol*act_H2OCol*((SP_H2OCol-yLO_H2OCol)/(yHI_H2OCol-yLO_H2OCol)-yyy_H2OCol(Ntau_H2OCol));
%-----------------------------------------------------------------------------
%controller initialization
%MV21: Qr - Temp
SP_TempCol=110;
K_TempCol=20;
Ti_TempCol=30;
act_TempCol=1;
mode_TempCol=1;
Ponly_TempCol=0;
ht_TempCol=1/transmitter_sampling_frequency(21);
hc_TempCol=1/controller_sampling_frequency(21);
uLO_TempCol=0;
uHI_TempCol=100000;
ded_TempCol=transmitter_deadtime(21);
tau_TempCol=transmitter_lag;
yLO_TempCol=0;
yHI_TempCol=120;
Nded_TempCol=1+transmitter_deadtime(21)*transmitter_sampling_frequency(21);
Ntau_TempCol=1;
xxx_TempCol(1)= (y_ss(22) -yLO_TempCol) / (yHI_TempCol -yLO_TempCol);
for i=2:Nded_TempCol
    xxx_TempCol(i)= xxx_TempCol(1);
end
for i=1:Ntau_TempCol
    yyy_TempCol(i)= xxx_TempCol(Nded_TempCol);
end
xi_TempCol= (MVs(21) - uLO_TempCol) /(uHI_TempCol -uLO_TempCol)-K_TempCol*act_TempCol*((SP_TempCol-yLO_TempCol)/(yHI_TempCol-yLO_TempCol)-yyy_TempCol(Ntau_TempCol));
%-----------------------------------------------------------------------------
%controller initialization
%MV22: Q_Condenser - Decanter Temperature (45.845 degC) is perfetly controlled in the code
SP_DecanterTemp=45.845;
K_DecanterTemp=1;
Ti_DecanterTemp=5; 
act_DecanterTemp=-1;
mode_DecanterTemp=1;
Ponly_DecanterTemp=0;
ht_DecanterTemp=1/transmitter_sampling_frequency(22);
hc_DecanterTemp=1/controller_sampling_frequency(22);
uLO_DecanterTemp=0;
uHI_DecanterTemp=150000;
ded_DecanterTemp=transmitter_deadtime(22);
tau_DecanterTemp=transmitter_lag;
yLO_DecanterTemp=40;
yHI_DecanterTemp=50;
Nded_DecanterTemp=1+transmitter_deadtime(22)*transmitter_sampling_frequency(25);
Ntau_DecanterTemp=1;
xxx_DecanterTemp(1)= (y_ss(20) -yLO_DecanterTemp) / (yHI_DecanterTemp -yLO_DecanterTemp);
for i=2:Nded_DecanterTemp
    xxx_DecanterTemp(i)= xxx_DecanterTemp(1);
end
for i=1:Ntau_DecanterTemp
    yyy_DecanterTemp(i)= xxx_DecanterTemp(Nded_DecanterTemp);
end
xi_DecanterTemp= (MVs(22) - uLO_DecanterTemp) /(uHI_DecanterTemp -uLO_DecanterTemp)-K_DecanterTemp*act_DecanterTemp*((SP_DecanterTemp-yLO_DecanterTemp)/(yHI_DecanterTemp-yLO_DecanterTemp)-yyy_DecanterTemp(Ntau_DecanterTemp));
%-----------------------------------------------------------------------------
%controller initialization
%MV22: Organic Level is controlled by Organic Product Flow at 0.5
SP_Organic=0.5;
K_Organic=1;
Ti_Organic=100; 
act_Organic=-1;
mode_Organic=1;
Ponly_Organic=1;
ht_Organic=1/transmitter_sampling_frequency(23);
hc_Organic=1/controller_sampling_frequency(23);
uLO_Organic=0;
uHI_Organic=2.4;
ded_Organic=transmitter_deadtime(23);
tau_Organic=transmitter_lag;
yLO_Organic=0; 
yHI_Organic=1; 
Nded_Organic=1+transmitter_deadtime(23)*transmitter_sampling_frequency(23);
Ntau_Organic=1;
xxx_Organic(1)= (y_ss(18)-yLO_Organic) / (yHI_Organic -yLO_Organic);
for i=2:Nded_Organic
    xxx_Organic(i)= xxx_Organic(1);
end
for i=1:Ntau_Organic
    yyy_Organic(i)= xxx_Organic(Nded_Organic);
end
xi_Organic= (MVs(23) - uLO_Organic) /(uHI_Organic -uLO_Organic)-K_Organic*act_Organic*((SP_Organic-yLO_Organic)/(yHI_Organic-yLO_Organic)-yyy_Organic(Ntau_Organic));
%-----------------------------------------------------------------------------
%controller initialization
%MV23: Aqueous Level is controlled by Aqueous Product Flow at 0.5
SP_Aqueous=0.5;
K_Aqueous=1;
Ti_Aqueous=100; 
act_Aqueous=-1;
mode_Aqueous=1;
Ponly_Aqueous=1;
ht_Aqueous=1/transmitter_sampling_frequency(24);
hc_Aqueous=1/controller_sampling_frequency(24);
uLO_Aqueous=0;
uHI_Aqueous=2.4;
ded_Aqueous=transmitter_deadtime(24);
tau_Aqueous=transmitter_lag;
yLO_Aqueous=0; 
yHI_Aqueous=1; 
Nded_Aqueous=1+transmitter_deadtime(24)*transmitter_sampling_frequency(24);
Ntau_Aqueous=1;
xxx_Aqueous(1)= (y_ss(19)-yLO_Aqueous) / (yHI_Aqueous -yLO_Aqueous);
for i=2:Nded_Aqueous
    xxx_Aqueous(i)= xxx_Aqueous(1);
end
for i=1:Ntau_Aqueous
    yyy_Aqueous(i)= xxx_Aqueous(Nded_Aqueous);
end
xi_Aqueous= (MVs(24) - uLO_Aqueous) /(uHI_Aqueous -uLO_Aqueous)-K_Aqueous*act_Aqueous*((SP_Aqueous-yLO_Aqueous)/(yHI_Aqueous-yLO_Aqueous)-yyy_Aqueous(Ntau_Aqueous));
%-----------------------------------------------------------------------------
%MV24: Column Bottom Exit is used to control the Column Bottom Level
SP_ColButtom=0.5;
K_ColButtom=1;
Ti_ColButtom=100; 
act_ColButtom=-1;
mode_ColButtom=1;
Ponly_ColButtom=1;
ht_ColButtom=1/transmitter_sampling_frequency(25);
hc_ColButtom=1/controller_sampling_frequency(25);
uLO_ColButtom=0;
uHI_ColButtom=4.536;
ded_ColButtom=transmitter_deadtime(25);
tau_ColButtom=transmitter_lag;
yLO_ColButtom=0; 
yHI_ColButtom=1; 
Nded_ColButtom=1+transmitter_deadtime(25)*transmitter_sampling_frequency(25);
Ntau_ColButtom=1;
xxx_ColButtom(1)= (y_ss(21)-yLO_ColButtom) / (yHI_ColButtom -yLO_ColButtom);
for i=2:Nded_ColButtom
    xxx_ColButtom(i)= xxx_ColButtom(1);
end
for i=1:Ntau_ColButtom
    yyy_ColButtom(i)= xxx_ColButtom(Nded_ColButtom);
end
xi_ColButtom= (MVs(25) - uLO_ColButtom) /(uHI_ColButtom -uLO_ColButtom)-K_ColButtom*act_ColButtom*((SP_ColButtom-yLO_ColButtom)/(yHI_ColButtom-yLO_ColButtom)-yyy_ColButtom(Ntau_ColButtom));
%-----------------------------------------------------------------------------
%controller initialization
%MV26: Vaporizer Liquid Inlet is fixed at 2.1924 kmol/min
%-----------------------------------------------------------------------------

%-----------------------------------------------------------------------------
%initialize historical data vectors
x_history=[];
y_history=[];
u_history=[];
dx_history=[];
%initialize simulation parameters
tic
timer=0;
is_initial=0;
disturbance_ID=0;
%start simulation
for k=0:(model_sampling_frequency*minute)
    time=k/model_sampling_frequency; %in minute
    %initialize disturbances
    if (k/model_sampling_frequency)>=10
        switch selected_ID
        case 0
            ;
        case 1
            SP_TRCT=151;
        case 2
            SP_TRCT=165;
        case 3
            SP_H2OCol=0.18;
        case 4
            MVs(26)=2.64;
        case 5
            if (k/model_sampling_frequency)<15
                MVs(3)=0;
            end
        case 6
            if (k/model_sampling_frequency)<15
                MVs(1)=0;
            end
        case 7            
             disturbance_ID=1;
        case 8            
            if (k/model_sampling_frequency)<15
                disturbance_ID=2;
            else
                disturbance_ID=0;
            end
        end
    end
    %calculate state derivatives and measurements
    [dstatedt,states,MVs,y_ss]=VAModel(states,MVs,time,is_initial,disturbance_ID);
    %in this example, we assume the setpoint of the vaporizer pressure control is given by the current gas recycle pressure
    SP_PresVap=y_ss(12);
    %command window display refreshing rate
    if rem(k,display_sampling_frequency*model_sampling_frequency)==0
        [error, indx]=max(abs(dstatedt./states));
%        info=['minute: ' num2str(time) '    max_dxdt_error: ' num2str(error) '    location: ' num2str(indx)];
 %       disp(info);
    end
    %save information
    if rem(k,storage_sampling_frequency*model_sampling_frequency)==0
        x_history=[x_history;states'];
        y_history=[y_history;[y_ss(37);y_ss(12);y_ss(23);y_ss(2);y_ss(1);y_ss(4);y_ss(5);y_ss(9);y_ss(10);MVs(10);y_ss(11);y_ss(13);MVs(13);y_ss(14);MVs(15);y_ss(15);y_ss(31);y_ss(33);y_ss(8);y_ss(28);y_ss(22);y_ss(20);y_ss(18);y_ss(19);y_ss(21);MVs(26);y_ss(27)]'];
        u_history=[u_history;MVs'];
        dx_history=[dx_history;dstatedt'];
    end
    %update states
    states=states+(1/model_sampling_frequency)*dstatedt;
    %controller action
    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(1))==0 & k~=0
        [xxx_O2, yyy_O2]=Transmit(y_ss(37), xxx_O2, yyy_O2, ded_O2, tau_O2, Nded_O2, Ntau_O2, ht_O2, yLO_O2, yHI_O2);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(1))==0 & k~=0
        [MVs(1),xi_O2,flag_O2]=controller(SP_O2, yyy_O2(Ntau_O2), MVs(1), xi_O2, mode_O2, K_O2, Ti_O2, hc_O2,...
            yLO_O2, yHI_O2, uLO_O2, uHI_O2, act_O2, Ponly_O2, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(2))==0 & k~=0
        [xxx_C2H4, yyy_C2H4]=Transmit(y_ss(12), xxx_C2H4, yyy_C2H4, ded_C2H4, tau_C2H4, Nded_C2H4, Ntau_C2H4, ht_C2H4, yLO_C2H4, yHI_C2H4);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(2))==0 & k~=0
        [MVs(2),xi_C2H4,flag_C2H4]=controller(SP_C2H4, yyy_C2H4(Ntau_C2H4), MVs(2), xi_C2H4, mode_C2H4, K_C2H4, Ti_C2H4, hc_C2H4,...
            yLO_C2H4, yHI_C2H4, uLO_C2H4, uHI_C2H4, act_C2H4, Ponly_C2H4, 0, 0, 0, 0);
    end
    
    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(3))==0 & k~=0
        [xxx_HAc, yyy_HAc]=Transmit(y_ss(23), xxx_HAc, yyy_HAc, ded_HAc, tau_HAc, Nded_HAc, Ntau_HAc, ht_HAc, yLO_HAc, yHI_HAc);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(3))==0 & k~=0
        [MVs(3),xi_HAc,flag_HAc]=controller(SP_HAc, yyy_HAc(Ntau_HAc), MVs(3), xi_HAc, mode_HAc, K_HAc, Ti_HAc, hc_HAc,...
            yLO_HAc, yHI_HAc, uLO_HAc, uHI_HAc, act_HAc, Ponly_HAc, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(4))==0 & k~=0
        [xxx_LevelVap, yyy_LevelVap]=Transmit(y_ss(2), xxx_LevelVap, yyy_LevelVap, ded_LevelVap, tau_LevelVap, Nded_LevelVap, Ntau_LevelVap, ht_LevelVap, yLO_LevelVap, yHI_LevelVap);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(4))==0 & k~=0
        [MVs(4),xi_LevelVap,flag_LevelVap]=controller(SP_LevelVap, yyy_LevelVap(Ntau_LevelVap), MVs(4), xi_LevelVap, mode_LevelVap, K_LevelVap, Ti_LevelVap, hc_LevelVap,...
            yLO_LevelVap, yHI_LevelVap, uLO_LevelVap, uHI_LevelVap, act_LevelVap, Ponly_LevelVap, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(5))==0 & k~=0
        [xxx_PresVap, yyy_PresVap]=Transmit(y_ss(1), xxx_PresVap, yyy_PresVap, ded_PresVap, tau_PresVap, Nded_PresVap, Ntau_PresVap, ht_PresVap, yLO_PresVap, yHI_PresVap);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(5))==0 & k~=0
        [MVs(5),xi_PresVap,flag_PresVap]=controller(SP_PresVap, yyy_PresVap(Ntau_PresVap), MVs(5), xi_PresVap, mode_PresVap, K_PresVap, Ti_PresVap, hc_PresVap,...
            yLO_PresVap, yHI_PresVap, uLO_PresVap, uHI_PresVap, act_PresVap, Ponly_PresVap, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(6))==0 & k~=0
        [xxx_ReactorInletTemp, yyy_ReactorInletTemp]=Transmit(y_ss(4), xxx_ReactorInletTemp, yyy_ReactorInletTemp, ded_ReactorInletTemp, tau_ReactorInletTemp, Nded_ReactorInletTemp, Ntau_ReactorInletTemp, ht_ReactorInletTemp, yLO_ReactorInletTemp, yHI_ReactorInletTemp);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(6))==0 & k~=0
        [MVs(6),xi_ReactorInletTemp,flag_ReactorInletTemp]=controller(SP_ReactorInletTemp, yyy_ReactorInletTemp(Ntau_ReactorInletTemp), MVs(6), xi_ReactorInletTemp, mode_ReactorInletTemp, K_ReactorInletTemp, Ti_ReactorInletTemp, hc_ReactorInletTemp,...
            yLO_ReactorInletTemp, yHI_ReactorInletTemp, uLO_ReactorInletTemp, uHI_ReactorInletTemp, act_ReactorInletTemp, Ponly_ReactorInletTemp, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(7))==0 & k~=0
        [xxx_TRCT, yyy_TRCT]=Transmit(y_ss(5), xxx_TRCT, yyy_TRCT, ded_TRCT, tau_TRCT, Nded_TRCT, Ntau_TRCT, ht_TRCT, yLO_TRCT, yHI_TRCT);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(7))==0 & k~=0
        [MVs(7),xi_TRCT,flag_TRCT]=controller(SP_TRCT, yyy_TRCT(Ntau_TRCT), MVs(7), xi_TRCT, mode_TRCT, K_TRCT, Ti_TRCT, hc_TRCT,...
            yLO_TRCT, yHI_TRCT, uLO_TRCT, uHI_TRCT, act_TRCT, Ponly_TRCT, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(8))==0 & k~=0
        [xxx_LevelSep, yyy_LevelSep]=Transmit(y_ss(9), xxx_LevelSep, yyy_LevelSep, ded_LevelSep, tau_LevelSep, Nded_LevelSep, Ntau_LevelSep, ht_LevelSep, yLO_LevelSep, yHI_LevelSep);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(8))==0 & k~=0
        [MVs(8),xi_LevelSep,flag_LevelSep]=controller(SP_LevelSep, yyy_LevelSep(Ntau_LevelSep), MVs(8), xi_LevelSep, mode_LevelSep, K_LevelSep, Ti_LevelSep, hc_LevelSep,...
            yLO_LevelSep, yHI_LevelSep, uLO_LevelSep, uHI_LevelSep, act_LevelSep, Ponly_LevelSep, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(9))==0 & k~=0
        [xxx_TempSep, yyy_TempSep]=Transmit(y_ss(10), xxx_TempSep, yyy_TempSep, ded_TempSep, tau_TempSep, Nded_TempSep, Ntau_TempSep, ht_TempSep, yLO_TempSep, yHI_TempSep);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(9))==0 & k~=0
        [MVs(9),xi_TempSep,flag_TempSep]=controller(SP_TempSep, yyy_TempSep(Ntau_TempSep), MVs(9), xi_TempSep, mode_TempSep, K_TempSep, Ti_TempSep, hc_TempSep,...
            yLO_TempSep, yHI_TempSep, uLO_TempSep, uHI_TempSep, act_TempSep, Ponly_TempSep, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(11))==0 & k~=0
        [xxx_CompOutletTemp, yyy_CompOutletTemp]=Transmit(y_ss(11), xxx_CompOutletTemp, yyy_CompOutletTemp, ded_CompOutletTemp, tau_CompOutletTemp, Nded_CompOutletTemp, Ntau_CompOutletTemp, ht_CompOutletTemp, yLO_CompOutletTemp, yHI_CompOutletTemp);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(11))==0 & k~=0
        [MVs(11),xi_CompOutletTemp,flag_CompOutletTemp]=controller(SP_CompOutletTemp, yyy_CompOutletTemp(Ntau_CompOutletTemp), MVs(11), xi_CompOutletTemp, mode_CompOutletTemp, K_CompOutletTemp, Ti_CompOutletTemp, hc_CompOutletTemp,...
            yLO_CompOutletTemp, yHI_CompOutletTemp, uLO_CompOutletTemp, uHI_CompOutletTemp, act_CompOutletTemp, Ponly_CompOutletTemp, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(12))==0 & k~=0
        [xxx_LevelAbs, yyy_LevelAbs]=Transmit(y_ss(13), xxx_LevelAbs, yyy_LevelAbs, ded_LevelAbs, tau_LevelAbs, Nded_LevelAbs, Ntau_LevelAbs, ht_LevelAbs, yLO_LevelAbs, yHI_LevelAbs);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(12))==0 & k~=0
        [MVs(12),xi_LevelAbs,flag_LevelAbs]=controller(SP_LevelAbs, yyy_LevelAbs(Ntau_LevelAbs), MVs(12), xi_LevelAbs, mode_LevelAbs, K_LevelAbs, Ti_LevelAbs, hc_LevelAbs,...
            yLO_LevelAbs, yHI_LevelAbs, uLO_LevelAbs, uHI_LevelAbs, act_LevelAbs, Ponly_LevelAbs, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(14))==0 & k~=0
        [xxx_CircOutletTemp, yyy_CircOutletTemp]=Transmit(y_ss(14), xxx_CircOutletTemp, yyy_CircOutletTemp, ded_CircOutletTemp, tau_CircOutletTemp, Nded_CircOutletTemp, Ntau_CircOutletTemp, ht_CircOutletTemp, yLO_CircOutletTemp, yHI_CircOutletTemp);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(14))==0 & k~=0
        [MVs(14),xi_CircOutletTemp,flag_CircOutletTemp]=controller(SP_CircOutletTemp, yyy_CircOutletTemp(Ntau_CircOutletTemp), MVs(14), xi_CircOutletTemp, mode_CircOutletTemp, K_CircOutletTemp, Ti_CircOutletTemp, hc_CircOutletTemp,...
            yLO_CircOutletTemp, yHI_CircOutletTemp, uLO_CircOutletTemp, uHI_CircOutletTemp, act_CircOutletTemp, Ponly_CircOutletTemp, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(16))==0 & k~=0
        [xxx_ScrubOutletTemp, yyy_ScrubOutletTemp]=Transmit(y_ss(15), xxx_ScrubOutletTemp, yyy_ScrubOutletTemp, ded_ScrubOutletTemp, tau_ScrubOutletTemp, Nded_ScrubOutletTemp, Ntau_ScrubOutletTemp, ht_ScrubOutletTemp, yLO_ScrubOutletTemp, yHI_ScrubOutletTemp);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(16))==0 & k~=0
        [MVs(16),xi_ScrubOutletTemp,flag_ScrubOutletTemp]=controller(SP_ScrubOutletTemp, yyy_ScrubOutletTemp(Ntau_ScrubOutletTemp), MVs(16), xi_ScrubOutletTemp, mode_ScrubOutletTemp, K_ScrubOutletTemp, Ti_ScrubOutletTemp, hc_ScrubOutletTemp,...
            yLO_ScrubOutletTemp, yHI_ScrubOutletTemp, uLO_ScrubOutletTemp, uHI_ScrubOutletTemp, act_ScrubOutletTemp, Ponly_ScrubOutletTemp, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(17))==0 & k~=0
        [xxx_CO2, yyy_CO2]=Transmit(y_ss(31), xxx_CO2, yyy_CO2, ded_CO2, tau_CO2, Nded_CO2, Ntau_CO2, ht_CO2, yLO_CO2, yHI_CO2);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(17))==0 & k~=0
        [MVs(17),xi_CO2,flag_CO2]=controller(SP_CO2, yyy_CO2(Ntau_CO2), MVs(17), xi_CO2, mode_CO2, K_CO2, Ti_CO2, hc_CO2,...
            yLO_CO2, yHI_CO2, uLO_CO2, uHI_CO2, act_CO2, Ponly_CO2, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(18))==0 & k~=0
        [xxx_C2H6, yyy_C2H6]=Transmit(y_ss(33), xxx_C2H6, yyy_C2H6, ded_C2H6, tau_C2H6, Nded_C2H6, Ntau_C2H6, ht_C2H6, yLO_C2H6, yHI_C2H6);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(18))==0 & k~=0
        [MVs(18),xi_C2H6,flag_C2H6]=controller(SP_C2H6, yyy_C2H6(Ntau_C2H6), MVs(18), xi_C2H6, mode_C2H6, K_C2H6, Ti_C2H6, hc_C2H6,...
            yLO_C2H6, yHI_C2H6, uLO_C2H6, uHI_C2H6, act_C2H6, Ponly_C2H6, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(19))==0 & k~=0
        [xxx_FEHE, yyy_FEHE]=Transmit(y_ss(8), xxx_FEHE, yyy_FEHE, ded_FEHE, tau_FEHE, Nded_FEHE, Ntau_FEHE, ht_FEHE, yLO_FEHE, yHI_FEHE);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(19))==0 & k~=0
        [MVs(19),xi_FEHE,flag_FEHE]=controller(SP_FEHE, yyy_FEHE(Ntau_FEHE), MVs(19), xi_FEHE, mode_FEHE, K_FEHE, Ti_FEHE, hc_FEHE,...
            yLO_FEHE, yHI_FEHE, uLO_FEHE, uHI_FEHE, act_FEHE, Ponly_FEHE, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(20))==0 & k~=0
        [xxx_H2OCol, yyy_H2OCol]=Transmit(y_ss(28), xxx_H2OCol, yyy_H2OCol, ded_H2OCol, tau_H2OCol, Nded_H2OCol, Ntau_H2OCol, ht_H2OCol, yLO_H2OCol, yHI_H2OCol);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(20))==0 & k~=0
        [MVs(20),xi_H2OCol,flag_H2OCol]=controller(SP_H2OCol, yyy_H2OCol(Ntau_H2OCol), MVs(20), xi_H2OCol, mode_H2OCol, K_H2OCol, Ti_H2OCol, hc_H2OCol,...
            yLO_H2OCol, yHI_H2OCol, uLO_H2OCol, uHI_H2OCol, act_H2OCol, Ponly_H2OCol, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(21))==0 & k~=0
        [xxx_TempCol, yyy_TempCol]=Transmit(y_ss(22), xxx_TempCol, yyy_TempCol, ded_TempCol, tau_TempCol, Nded_TempCol, Ntau_TempCol, ht_TempCol, yLO_TempCol, yHI_TempCol);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(21))==0 & k~=0
        [MVs(21),xi_TempCol,flag_TempCol]=controller(SP_TempCol, yyy_TempCol(Ntau_TempCol), MVs(21), xi_TempCol, mode_TempCol, K_TempCol, Ti_TempCol, hc_TempCol,...
            yLO_TempCol, yHI_TempCol, uLO_TempCol, uHI_TempCol, act_TempCol, Ponly_TempCol, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(22))==0 & k~=0
        [xxx_DecanterTemp, yyy_DecanterTemp]=Transmit(y_ss(20), xxx_DecanterTemp, yyy_DecanterTemp, ded_DecanterTemp, tau_DecanterTemp, Nded_DecanterTemp, Ntau_DecanterTemp, ht_DecanterTemp, yLO_DecanterTemp, yHI_DecanterTemp);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(22))==0 & k~=0
        [MVs(22),xi_DecanterTemp,flag_DecanterTemp]=controller(SP_DecanterTemp, yyy_DecanterTemp(Ntau_DecanterTemp), MVs(22), xi_DecanterTemp, mode_DecanterTemp, K_DecanterTemp, Ti_DecanterTemp, hc_DecanterTemp,...
            yLO_DecanterTemp, yHI_DecanterTemp, uLO_DecanterTemp, uHI_DecanterTemp, act_DecanterTemp, Ponly_DecanterTemp, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(23))==0 & k~=0
        [xxx_Organic, yyy_Organic]=Transmit(y_ss(18), xxx_Organic, yyy_Organic, ded_Organic, tau_Organic, Nded_Organic, Ntau_Organic, ht_Organic, yLO_Organic, yHI_Organic);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(23))==0 & k~=0
        [MVs(23),xi_Organic,flag_Organic]=controller(SP_Organic, yyy_Organic(Ntau_Organic), MVs(23), xi_Organic, mode_Organic, K_Organic, Ti_Organic, hc_Organic,...
            yLO_Organic, yHI_Organic, uLO_Organic, uHI_Organic, act_Organic, Ponly_Organic, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(24))==0 & k~=0
        [xxx_Aqueous, yyy_Aqueous]=Transmit(y_ss(19), xxx_Aqueous, yyy_Aqueous, ded_Aqueous, tau_Aqueous, Nded_Aqueous, Ntau_Aqueous, ht_Aqueous, yLO_Aqueous, yHI_Aqueous);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(24))==0 & k~=0
        [MVs(24),xi_Aqueous,flag_Aqueous]=controller(SP_Aqueous, yyy_Aqueous(Ntau_Aqueous), MVs(24), xi_Aqueous, mode_Aqueous, K_Aqueous, Ti_Aqueous, hc_Aqueous,...
            yLO_Aqueous, yHI_Aqueous, uLO_Aqueous, uHI_Aqueous, act_Aqueous, Ponly_Aqueous, 0, 0, 0, 0);
    end

    if rem(k,model_sampling_frequency/transmitter_sampling_frequency(25))==0 & k~=0
        [xxx_ColButtom, yyy_ColButtom]=Transmit(y_ss(21), xxx_ColButtom, yyy_ColButtom, ded_ColButtom, tau_ColButtom, Nded_ColButtom, Ntau_ColButtom, ht_ColButtom, yLO_ColButtom, yHI_ColButtom);
    end
    if rem(k,model_sampling_frequency/controller_sampling_frequency(25))==0 & k~=0
        [MVs(25),xi_ColButtom,flag_ColButtom]=controller(SP_ColButtom, yyy_ColButtom(Ntau_ColButtom), MVs(25), xi_ColButtom, mode_ColButtom, K_ColButtom, Ti_ColButtom, hc_ColButtom,...
            yLO_ColButtom, yHI_ColButtom, uLO_ColButtom, uHI_ColButtom, act_ColButtom, Ponly_ColButtom, 0, 0, 0, 0);
    end

end
toc
%plot graphics
my_label=['   %O2  ';'  Pres  ';'  HAc-L ';'  Vap-L ';'  Vap-P ';'  Pre-T ';'  RCT-T ';'  Sep-L ';'  Sep-T ';'  Sep-V ';'  Com-T ';'  Abs-L ';'  Cir-F ';'  Cir-T ';'  Scr-F ';'  Scr-T ';'  %CO2  ';'  %C2H6 ';' FEHE-T ';'  %H2O  ';'  Col-T ';'  Org-L ';'  Aqu-L ';'  Col-L ';' Vap-In ';' Dect-T ';'%VAc E-3'];
MV_label=[' F-O2 ';'F-C2H4';' F-HAc';' Q-Vap';' F-Vap';'Q-Heat';'ShellT';'F-SepL';' T-Sep';'F-SepV';'Q-Comp';'F-AbsL';'F-Circ';'Q-Circ';'F-Scru';'Q-Scru';' F-CO2';' Purge';'bypass';'Reflux';'Q-Rebo';'F-Orga';'F-Aque';' F-Bot';'Q_Cond';'F-Tank'];
setpoint=[SP_O2;SP_C2H4;SP_HAc;SP_LevelVap;SP_PresVap;150;SP_TRCT;SP_LevelSep;SP_TempSep;16.1026;80;SP_LevelAbs;15.1198;25;0.756;25;SP_CO2;SP_C2H6;SP_FEHE;SP_H2OCol;SP_TempCol;0.5;0.5;SP_ColButtom;45.845;2.1924];
warning off
if selected_ID==1
    McAvoy_Plot_1(y_history,u_history,setpoint,my_label,MV_label,storage_sampling_frequency);
elseif selected_ID==2
    McAvoy_Plot_2(y_history,u_history,setpoint,my_label,MV_label,storage_sampling_frequency);
elseif selected_ID==3
    McAvoy_Plot_3(y_history,u_history,setpoint,my_label,MV_label,storage_sampling_frequency);
elseif selected_ID==4
    McAvoy_Plot_4(y_history,u_history,setpoint,my_label,MV_label,storage_sampling_frequency);    
else
    Transient_Plot(y_history,u_history,setpoint,my_label,MV_label,storage_sampling_frequency);    
end
return
