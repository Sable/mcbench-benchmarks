function [ freq,amp,phase,dc ] = fourier_series_real( t,x )
% function [ freq,amp,phase,dc ] = fourier_series_real( t,x )
% Fourier series of real signals.
% Written by Yoash Levron, January 2013.
%
% This function computes the fourier series of a signal x(t).
% the amplitudes of the fourier series have the same dimension
% of the original signal, so this function is useful for immediate
% computation of the actual frequency components, without
% further processing.
%
% for example, x(t) = 2 + 3*cos(2*pi*50*t) will result in 
% dc value = 2
% frequencies = [50   100  150   200 ...]
% amplitudes   = [3     0      0        0     ...]
% phases         = [0     0      0        0     ...]
%
% x(t) is one cycle of an infinite cyclic signal. The function
% computes the fourier transform of that infinite signal.
% the period of the signal (T) is determined by the length
% of the input time vector, t.
% x(t) must be real (no imaginary values).
%
% The signal x(t) is represented as:
% x(t) = Adc + A1*cos(w*t + ph1) + A2*cos(2*w*t + ph2) + ...
% the function computes the amplitudes, Adc,A1,A2...
% and the phases ph1,ph2,...
%
% T = period of the signal = t(end) - t(1)
% w = basic frequency = 2*pi/T
%
% The function automatically interpolates the original signal
% to avoid aliasing. Likewise, the function automatically determines
% the number of fourier components, and truncates trailing zeros.
%
% inputs:
% t - [sec] time vector. Sample time may vary within the signal.
% x - signal vector. same length as t.
%
% outputs:
% freq - [Hz] frequencies of the fourier series, not including zero.
% amp - amplitudes vector. amp=[A1 A2 A3 ...], not including the DC component.
% phase - [rad/sec] . phases, not including the DC component.
% dc - the DC value (average of the signal).


%%%%%%%%%%% computation %%%%%%%%
rel_tol = 1e-4;  % relative tolerance, to determine trailing zero truncation

if (~isreal(x))
        clc;
        beep;
        disp('fourier_series_real Error:  x(t) must be real.');
        dc = NaN;  amp = NaN;  freq = NaN;  phase = NaN;
        return;
end

t = t-t(1);  % shifting time to zero.
T = t(end);  % period time.
N = 100;  % number of samples
if (mod(N,2) == 1)
    N = N + 1;
end
N = N/2;

ok = 0;
while (~ok)
    N = N*2;  % increase number of samples
    
    if (N > 10e6)
        clc;
        beep;
        disp('fourier_series_real Error: signal bandwidth seems too high.');
        disp('Try decreasing the sample time in the input time vector t,');
        disp('or increasing the relative tolerance rel_tol');
        dc = NaN;  amp = NaN;  freq = NaN;  phase = NaN;
        return;
    end
    dt = T/N;
    t1 = 0:dt:(T-dt);
    x1 = interp1(t,x,t1,'cubic',0);
    xk = (1/N)*fft(x1);
    
    dc = abs(xk(1));
    xkpos = xk(2:(N/2));
    xkneg = xk(end:-1:(N/2+2));
    
    freq = [1:length(xkpos)]/T;  % Hz
    amp = 2*abs(xkpos);
    phase = angle(xkpos);  % rad/sec
    
    %%% check if enough samples are used.
    %%% if not, try again, with more samples.
    Am = max(amp);
    ii = find((amp(end-10:end)/Am)>rel_tol);
    ok = isempty(ii);
end

% %%% truncate output vectors to remove trailing zeros
Am = max(amp);
ii = length(amp);
while (amp(ii) < Am*rel_tol)
    ii = ii - 1;
end
amp = amp(1:ii);
freq = freq(1:ii);
phase = phase(1:ii);

end

