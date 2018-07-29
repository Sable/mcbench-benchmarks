%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Програма за спектрален анализ и измерване на шум    %
% с използване на данни от PCSGU250                   %
% Program for spectrum analysis and noise measurement %
% using data from PCSGU250                            %
%                                                     %
% Author: M.Sc. Eng. Hristo Zhivomirov       07/15/12 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clf, close all

% open of the data file
fid = fopen('data.txt','rt'); 

% avoid of the header in the data file
for m = 1:10 
    tline = fgetl(fid);
end
DM = [];

% read of the data and storing them into data matrix
while 1
    tline = fgetl(fid); 
    if ~ischar(tline), break, end 
    nums = str2num(tline); 
    DM = [DM; nums]; 
end 

% close of the data file
fclose(fid); 

% preparing of vector with amplitudes
DM = DM(:, 2); % obtain information from first channel
x = (DM-125)*(0.01/32); %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ADJUST

% remove the DC
DC = mean(x);
x = x - DC;

% discretisation parameters
fs = 125/0.2e-3; % sampling frequency, Hz !!!!!!!!!!!!!!!!!!!!! ADJUST
N = length(x); % number of signal samples
Ts = (N-1)/fs; % Ts = (N-1)*ts signal length, s
Tsms = Ts*1000; % signal length, ms
t = linspace(0, Tsms, N); % time, ms

% plotting of the signal
figure(1)
subplot(2, 3, 1)
plot(t, x, 'r')
grid on
a = 1.1*min(x);
b = 1.1*max(x);
axis([0 Tsms a b])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 13)
title('Signal in the time domain'),
xlabel('Time, ms')
ylabel('Amplitude, V')

% PSD (Power Spectral Density ,Vrms^2/Hz)
% [Pxx,F] = PWELCH(X,WINDOW,NOVERLAP,NFFT,Fs)
win = hanning(512);
[Pxx, f] = pwelch(x, win, 256, length(x), fs, 'onesided');
f = f/1000;
PxxdB = 10*log10(Pxx);
PSDavr = mean(Pxx);
PSDavrdB = 10*log10(PSDavr);
subplot(2, 3, 2)
plot(f, PxxdB, 'r', 'LineWidth', 2)
grid on
hold on
line([0 max(f)], [PSDavrdB PSDavrdB], 'Color', 'k', 'LineWidth', 2)
xlim([0 max(f)])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 13)
title('Power Spectral Density Estimation of the signal'),
xlabel('Frequency, kHz')
ylabel('Magnitude, dBV_{rms}^{2}/Hz')
h = legend('PSD', 'mean PSD');
set(h, 'FontName', 'Times New Roman', 'FontSize', 12)

% PS (Power spectrum, Vrms^2) & AS (Amplitude Spectrum, Vrms)
S1 = sum(win);
S2 = win'*win;
ENBW = fs*S2/(S1^2);
PS = Pxx.*ENBW;
AS = sqrt(PS);
ASdB = 20*log10(AS);
subplot(2, 3, 3)
plot(f, ASdB, 'r', 'LineWidth', 2)
grid on
xlim([0 max(f)])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 13)
title('Amplitude Spectrum of the signal'),
xlabel('Frequency, kHz')
ylabel('Magnitude, dBV_{rms}')

% A-weighting filter
xA = filterA(1000*f, x); % filtering

% view of the weigted signal in the time domain
subplot(2, 3, 4)
plot(t(1:end/2+1), xA, 'r', 'LineWidth', 2);
grid on
c = 1.1*min(xA);
d = 1.1*max(xA);
axis([0 Tsms/2 c d])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 13)
title('A-weighted signal in the time domain'),
xlabel('Time, ms')
ylabel('Amplitude, V')

% PSD (Power Spectral Density ,Vrms^2/Hz) of the weighted signal
win = hanning(512);
[PxxA, f] = pwelch(xA, win, 256, length(xA), fs, 'onesided');
f = f/1000;
PxxAdB = 10*log10(PxxA);
subplot(2, 3, 5)
plot(f/2, PxxAdB, 'r', 'LineWidth', 2)
grid on
xlim([0 max(f/2)])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 13)
title('Power Spectral Density Estimation of the weigted signal'),
xlabel('Frequency, kHz')
ylabel('Magnitude, dBV_{rms}^{2}/Hz')

% PS (Power spectrum, Vrms^2) & AS (Amplitude Spectrum, Vrms) of the weighted signal
PSA = PxxA.*ENBW;
ASA = sqrt(PSA);
ASAdB = 20*log10(ASA);
subplot(2, 3, 6)
plot(f/2, ASAdB, 'r', 'LineWidth', 2)
grid on
xlim([0 max(f/2)])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 13)
title('Amplitude Spectrum of the weighted signal'),
xlabel('Frequency, kHz')
ylabel('Magnitude, dBV_{rms}')

% Displey PSD & ASD before A-weighting
ASDavr = sqrt(PSDavr);
disp(['Power Spectral Density before A-weighting = ' num2str(PSDavr) ' Vrms^2/Hz'])
disp(['Amplitude Spectral Density before A-weighting = ' num2str(ASDavr) ' Vrms/sqrtHz'])

% Calculating output noise U, Vrms (by Oscilloscope) after A-weighting (Reference To Output)
pospeak = max(xA); % determine the possitive peak
negpeak = min(xA); % determine the negative peak
Urms_noise_O = 1000*(pospeak - negpeak)/6; % calculating the output noise in mVrms using 99.7% assurance
disp(['Output noise (by Oscilloscope) after A-weighting= ' num2str(Urms_noise_O) ' mVrms or ' num2str(20*log10(Urms_noise_O/1000)) ' dBV' ])

% Calculating output noise U, Vrms (by TrueRMS Voltmeter) after A-weighting (Reference To Output)
Urms_noise_V = 1000*sqrt(mean(xA.^2)); % mVrms
disp(['Output noise (by TrueRMS Voltmeter) after A-weighting = ' num2str(Urms_noise_V) ' mVrms or ' num2str(20*log10(Urms_noise_V/1000)) ' dBV' ])