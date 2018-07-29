% Test spectrogram

function tPlotSpectrogram

addpath('..');

[x, Fs] = wavread('addf8.wav');

Options = {'BW', 'NB', 'FLim', [500 1500]};
PlotSpectrogram(x, Fs, Options{:});
colormap(SpecColorMap);
colorbar;

% Use alternate colour map
figure;

Options = {'NSlice', 450, 'preF', 0.97,  'BW', 'WB'};
TLen = (length(x)-1)/Fs;
TLim = [0.3*TLen, 0.4*TLen];
PlotSpectrogram(x, TLim, Fs, Options{:});
colorbar;

% Sine wave test (expect sine wave peak at -6 dBov)
% Changing fc to 0, gives 0 dBov at dc
Fs = 16000;
fc = Fs/8;
NSamp = 5000;
t = (0:NSamp-1)/Fs;
Amax = 32767;
x = Amax * cos(2*pi*t*fc);

PmaxdBSPL = 92;             % Max level in dB SPL
PoffsdB = PmaxdBSPL + 20*log10(2);
g = 10^(PoffsdB/20);
AmaxN = Amax/g;

figure;
Options = {'Amax', AmaxN, 'FLim', [0 4000]};
PlotSpectrogram(x, Fs, Options{:});
colormap(SpecColorMap);
colorbar;

return
