clear;clc

%% Designing a decimation filter.
% We start by desinging a decimation filter in double precision. The
% decimation filter is a low pass filter with a decimation rate of 64. The
% filter specification is from the AD1877 Anolog Devices Sigma-Delta
% data sheet. You can find the data sheet at
% http://www.analog.com/UploadedFiles/Data_Sheets/AD1877.pdf

% The desing of the filter takes about 10 seconds. As such, for a faster
% start up the design is stored in a file. If you need to redesign the
% filter, simply uncomment the lines below and run the script.

Decimation_Factor=64;
Passband_Ripple=.006; %dB
Stopband_Attenuation=90; %dB
Fs=48e3;
Passband=21.6e3;  %dB
Stopband=26.4e3; %dB

Input_Sampling_Rate = Decimation_Factor*Fs;
f=fdesign.decimator(Decimation_Factor,'lowpass',Passband,Stopband,...
    Passband_Ripple,Stopband_Attenuation,Input_Sampling_Rate);
h=design(f);

save one_stage h
fvtool(h,'Fs',Input_Sampling_Rate);


%% To have a more efficnet implementation, we break down the filter into

hm=design(f,'multistage','Nstages',3);

save multi_stage hm
fvtool(h,'Fs',Input_Sampling_Rate);

%% We then convert the filter into fixed-point.
hf=hm;

hf.stage(1).Arithmetic = 'fixed';
hf.stage(1).CoeffWordLength = 24;
hf.stage(1).InputWordLength = 2;
hf.stage(1).InputFracLength = 0;
specifyall(hf.stage(1));
hf.stage(1).OutputWordLength = 12;
hf.stage(1).OutputFracLength = 10;
hf.stage(1).ProductWordLength = 8;
hf.stage(1).ProductFracLength = 10;
hf.stage(1).AccumWordLength = 13;
hf.stage(1).AccumFracLength = 10;
hf.stage(1).RoundMode = 'nearest';

hf.stage(2).Arithmetic = 'fixed';
hf.stage(2).CoeffWordLength = 24;
hf.stage(2).InputWordLength = 13;
hf.stage(2).InputFracLength = 10;
specifyall(hf.stage(2));
hf.stage(2).OutputWordLength = 13;
hf.stage(2).OutputFracLength = 10;
hf.stage(2).ProductWordLength = 10;
hf.stage(2).ProductFracLength = 10;
hf.stage(2).AccumWordLength = 13;
hf.stage(2).AccumFracLength = 10;
hf.stage(2).RoundMode = 'nearest';

hf.stage(3).Arithmetic = 'fixed';
hf.stage(3).CoeffWordLength = 24;
hf.stage(3).InputWordLength = 13;
hf.stage(3).InputFracLength = 10;
specifyall(hf.stage(3));
hf.stage(3).ProductWordLength = 11;
hf.stage(3).ProductFracLength = 12;
hf.stage(3).AccumWordLength = 14;
hf.stage(3).AccumFracLength = 12;
hf.stage(3).OutputWordLength = 16;
hf.stage(3).OutputFracLength = 15;
hf.stage(3).RoundMode = 'nearest';
hf.stage(3).OverflowMode = 'saturate';

save multi_stage_fixed hf

fvtool(hf,'Fs',Input_Sampling_Rate);
