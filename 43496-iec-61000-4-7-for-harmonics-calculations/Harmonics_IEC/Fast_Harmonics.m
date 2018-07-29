function [nyquist_number,Bezugsfrequenz,Signal_amp] = Fast_Harmonics(x,fs,duration)
xx = 0;
if xx == 1
    % Sampling
    fs = 1000;     % Sampling rate [Hz]
    Ts = 1/fs;     % Sampling period [s]
    fNy = fs / 2;  % Nyquist frequency [Hz]
    duration = 10; % Duration [s]
    t = 0 : Ts : duration-Ts; % Time vector
    noSamples = length(t);    % Number of samples
    % Original signal
    x = 220.*sin(2 .* pi .* 50 .* t);
    % Harmonics
    x1 = 100.*sin(2 .* pi .* 100 .* t);
    x2 = 100.*sin(2 .* pi .* 200 .* t);
    x3 = 100.*sin(2 .* pi .* 300 .* t);
    % Contaminated signal
    xn = x + x1 + x2 + x3;
    % Frequency analysis
    f = 0 : fs/noSamples : fs - fs/noSamples; % Frequency vector
    % FFT
    x_fft = abs(fft(x));
    xn_fft = abs(fft(xn));
    % Plot
    figure(1);
    subplot(2,2,1);
    plot(t, x);
    subplot(2,2,2);
    plot(t, xn);
    subplot(2,2,3);
    plot(f,x_fft);
    xlim([0 fNy]);
    subplot(2,2,4);
    plot(f,xn_fft);
    xlim([0 fNy]);
else
%     x is the sampled data
%     m = length(x) is the window length (number of samples)
%     fs is the samples/unit time
%     dt = 1/fs is Time increment per sample
%     t = (0:m-1)/fs Time range for data
%     y = fft(x,n) is the Discrete Fourier Transform (DFT)
%     abs(y) is the Amplitude of the DFT
%     (abs(y).^2)/n is power of the DFT
%     fs/n Frequency increment
%     f = (0:n-1)*(fs/n) is frequency range
%     fs/2 is Nyquist frequency
%     n = pow2(nextpowe2(m)) is the transfrom length
    Ts = 1/fs;     % Sampling period [s]
    fNy = fs / 2;  % Nyquist frequency [Hz]
    t = 0 : Ts : duration-Ts; % Time vector
    noSamples = length(t);    % Number of samples
    % Original signal
    % Frequency analysis
    f = 0 : fs/noSamples : fs - fs/noSamples; % Frequency vector
    % FFT
    x_fft = abs(fft(x));
    xx = x';
    X = fft(xx(2:end));
    if rem(length(X),2)==0
        nyquist_number = length(X)/2;
    else
        nyquist_number = (length(X)+1)/2;
    end
    Bezugsfrequenz = 1/(t(end)-t(1));
    Signal_amp        = zeros(1,nyquist_number+1);
    Signal_phi        = zeros(1,nyquist_number+1);
    Signal_amp(1)     = X(1)/length(X);									                % Gleichanteil des Signals [unit]
    Signal_amp(2:end-1) = 2*abs(X(2:nyquist_number))/length(X);
    Signal_amp(end) = abs(X(nyquist_number+1))/length(X);   
    %Signal_amp(2:end) = [2*abs(X(2:nyquist_number)) abs(X(nyquist_number+1))]/length(X);   % Amplituden der Harmonischen des Signals [unit]
    Signal_phi(1)     = 0;
    Signal_phi(2:end) = angle(X(2:nyquist_number+1));		                                % Phasenwinkel der Harmonischen des Signals [rad]
    
    %xn_fft = abs(fft(xn));
    % Plot
end


