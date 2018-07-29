% an Example file for the function 'filter_damping_design'.
% Written by Dr. Yoash Levron
% type 'help filter_damping_design' for more details

clc;
tic;  % start timer

% Dear user - please select one example from below

% %%% example - one stage filter design
% stg_L = [250]*1e-6;  % [H] primary inductor
% stg_C = [10]*1e-6;  % [F] primary capacitor
% fs = 500e3;  % [Hz] switching frequency to attenuate
% Zmax = 10; % [ohm] maximum allowed output resistance
% % design damping network
% [ stg_Ld, stg_Rd, att] = filter_damping_design( stg_L, stg_C, fs, Zmax);

%%% example - two stage filter design
stg_L = [10 10]*1e-6;  % [H] primary inductor
stg_C = [1.5   1.5]*1e-6;  % [F] primary capacitor
fs = 500e3;  % [Hz] switching frequency to attenuate
Zmax = 10; % [ohm] maximum allowed output resistance
% design damping network
[ stg_Ld, stg_Rd, att] = filter_damping_design( stg_L, stg_C, fs, Zmax);

% %%% example - three stage filter design
% stg_L = [3.3   3.3   3.3]*1e-6;  % [H] primary inductors
% stg_C = [1   1    1]*1e-6;  % [F] primary capacitors
% fs = 500e3;  % [Hz] switching frequency to attenuate
% Zmax = 10; % [ohm] maximum allowed output resistance
% % design damping network
% [ stg_Ld, stg_Rd, att] = filter_damping_design( stg_L, stg_C, fs, Zmax);
% %%%% save filter3.mat;

% Bode plots
ws = 2*pi*fs;
w = logspace(log10(2*pi*1000),log10(ws),1000);
stg_Rd_temp = stg_Rd;
ind = find(isinf(stg_Rd));  stg_Rd_temp(ind) = 1e6;
[MAG, IMP] = tf_filter( stg_L,stg_C, stg_Ld, stg_Rd_temp , w);
Habs = 20*log10(abs(MAG));
close all;
subplot(2,1,1);
semilogx(w/(2*pi),Habs,'k-');  ylabel('gain [dB]');
xlim([1e3 ws/(2*pi)]);
title('optimal filter');
subplot(2,1,2);
loglog(w/(2*pi),abs(IMP),'k-');  ylabel('impedance [ohm]');
xlabel('frequency [Hz]');
xlim([1e3 ws/(2*pi)]);
total_run_time = toc;
% print resulting filter components:
inductors_L_uH = 1e6*stg_L
capacitors_C_uF = 1e6*stg_C
inductors_Ld_uH = 1e6*stg_Ld
resistors_Rd = stg_Rd
attenuation = att
maxZout = max(abs(IMP))


