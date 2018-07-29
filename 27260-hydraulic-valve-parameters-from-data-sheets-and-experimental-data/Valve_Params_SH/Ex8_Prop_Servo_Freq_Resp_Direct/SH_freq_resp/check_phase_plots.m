% Script to compare frequency response to 
% manufacturer's data sheet (phase only)
% Copyright 2010 MathWorks, Inc.

mdl = 'actuator_freq_resp';

amplitude_100 = 0.2;
frequency_100 = 43;
amplitude_40  = amplitude_100*0.4;
frequency_40  = 55;

ios = getlinio(mdl);

in100 = frest.Sinestream(...
    'Frequency',logspace(0,2,30),...
    'Amplitude', amplitude_100, ...
    'SimulationOrder', 'Sequential', ... %Set to OneAtATime to restart simuation for each frequency
    'FreqUnits', 'Hz');

in40 = frest.Sinestream(...
    'Frequency',logspace(0,2,30),...
    'Amplitude', amplitude_40, ...
    'SimulationOrder', 'Sequential', ... %Set to OneAtATime to restart simuation for each frequency
    'FreqUnits', 'Hz');

act_gain = x0(1);
time_const = x0(2);
act_saturation = x0(3);
sys100_start = frestimate(mdl,ios,in100);
sys40_start = frestimate(mdl,ios,in40);

if(exist('x'))
    act_gain = x(1);
    time_const = x(2);
    act_saturation = x(3);
    
    sys100_finish = frestimate(mdl,ios,in100);
    sys40_finish = frestimate(mdl,ios,in40);
end

%% Plot Results
plot_reference_data;

figure(3)

subplot(121)
[mag phase w] = bode(sys100_start); w=w/(2*pi);
semilogx(w,reshape(phase,1,30),'b--','LineWidth',2.5)
legendstrings = {'Start','Ref.'};
hold on
%legendstrings = {'Ref'};

if(exist('x'))
    [mag phase w] = bode(sys100_finish); w=w/(2*pi);
    semilogx(w,reshape(phase,1,30),'r--','LineWidth',2.5)
    legendstrings = {'Start','Finish','Ref.'};
end

semilogx(RefFR_100_Frq,RefFR_100_Phs,'k--','LineWidth',2.5);
hold off
legend(legendstrings,'Location','SouthWest');
title('Phase, 100% Input','FontSize',14)
xlabel('Frequency (Hz)','FontSize',12);
ylabel('Phase (deg)','FontSize',12);
axis([1 100 -180 0]);


subplot(122)
[mag phase w] = bode(sys40_start); w=w/(2*pi);
semilogx(w,reshape(phase,1,30),'b','LineWidth',2.5)
hold on

if(exist('x'))
    [mag phase w] = bode(sys40_finish); w=w/(2*pi);
    semilogx(w,reshape(phase,1,30),'r','LineWidth',2.5)
end

semilogx(RefFR_40_Frq,RefFR_40_Phs,'k','LineWidth',2.5);
hold off
legend(legendstrings,'Location','SouthWest');
title('Phase, 40% Input','FontSize',14)
xlabel('Frequency (Hz)','FontSize',12);
axis([1 100 -180 0]);

