clear all;
close all;
clc;

%% Frequency MODULATION of Triangular Signal
t = -0.04:1.e-4:0.04;
Ta = 0.01;
fc = 200;                                                           % Frequency of carrier
msg = msg1(t,Ta);                                            % Calling Function to Generate Msg Signal

%% MODULATION
kf = 160*pi;
m_int = kf*1.e-4*cumsum(msg);              % Integrating Msg
fm = cos(2*fc*pi*t + m_int);                   % fm = cos(2*pi*fc*t + integral(msg))

%% DEMODULATION (Using Differentiator)
dem = diff(fm);                 
dem = [0,dem];
rect_dem = abs(dem);

%% Filtering out High Frequencies
N = 80;                                                             % Order of Filter
Wn = 1.e-2;                                                    % Pass Band Edge Frequency.
a = fir1(N,Wn);                                             % Return Numerator of Low Pass FIR filter
b = 1;                                                                % Denominator of Low Pass FIR Filter
rec = filter(a,b,rect_dem);

%% Finding frequency Response of Signals

fl = length(t);
fl = 2^ceil(log2(fl));
f = (-fl/2:fl/2-1)/(fl*1.e-4);

mF = fftshift(fft(msg,fl));               % Frequency Response of Message Signal
                                        
fmF = fftshift(fft(fm,fl));             % Frequency Response of FM Signal

rect_demF = fftshift(fft(rect_dem,fl)); % Frequency Response of Rectified FM Signal

recF = fftshift(fft(rec,fl));           % Frequency Response of Recovered Message Signal


%% Plotting signal in time domain
figure;
subplot(2,1,1);
plot(t,msg);
title('Message Signal');
xlabel('{\it t} (sec)');
ylabel('m(t)');
grid;

subplot(2,1,2);
plot(t,fm);
title('FM');
xlabel('{\it t} (sec)');
ylabel('FM');
grid;

figure;
subplot(2,1,1);
plot(t,rect_dem);
title('Rectified FM');
xlabel('{\it t} (sec)');
ylabel('dem')
grid;

subplot(2,1,2);
plot(t,rec);
title('Recovered Signal');
xlabel('{\it t} (sec)');
ylabel('m(t)');
grid;

%% Plotting Freq Response of Signals
figure;
subplot(2,2,1);
plot(f,abs(mF));
title('Freq Response of MSG');
xlabel('f(Hz)');
ylabel('M(f)');
grid;
axis([-600 600 0 200]);

subplot(2,2,2);
plot(f,abs(fmF));
title('Freq Response of FM');
grid;
xlabel('f(Hz)');
ylabel('C(f)');
axis([-600 600 0 300]);

subplot(2,2,3);
plot(f,abs(rect_demF));
title('Freq Response of Rectified FM');
xlabel('f(Hz)');
ylabel('DSBSC(f)');
grid;
axis([-600 600 0 100]);

subplot(2,2,4);
plot(f,abs(recF));
title('Freq Response of Recovered Signal');
xlabel('f(Hz)');
ylabel('M(f)');
grid;
axis([-600 600 0 100]);