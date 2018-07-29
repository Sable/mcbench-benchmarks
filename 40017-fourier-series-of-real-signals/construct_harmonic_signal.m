function y = construct_harmonic_signal( freq,amp,phase,dc,t )
% y = construct_harmonic_signal( freq,amp,phase,dc,t )
% reconstructs a periodical signal from given harmonics
% Written by Dr. Yoash Levron, April 2013.
%
% The input is the individual harmonics of the signal.
% the function reconstructs the signal y(t).
%
% for example, given the input :
% freq        = [50   100  150   200 ...]
% amp       = [3     0      0        0     ...]
% phase    = [0     0      0        0     ...]
% dc  = 2
% The function will output the signal:
% y = 2 + 3*cos(2*pi*50*t)
%
% Generally, the output signal y is:
% y = dc + amp(1)*cos(2*pi*freq(1)*t + phase(1))  
%             +amp(2)*cos(2*pi*freq(2)*t + phase(2)) + ...
%
% This function is designed compatible to
% function 'fourier_series_real'. The two functions are inversible:
% The following code will generate a signal y(t) identical to x(t) :
% [ freq,amp,phase,dc ] = fourier_series_real( t,x );
% y = construct_harmonic_signal( freq,amp,phase,dc,t);
%
% inputs:
% freq - [Hz] frequencies of the fourier series, not including zero.
% amp - amplitudes vector, not including the DC component.
% phase - [rad/sec] . phases, not including the DC component.
% dc - the DC value (average of the signal).
% t - [sec] time vector. 
%
% outputs:
% y - output signal. same length as t.

y = dc * t.^0;
for ii = 1:length(freq)
    y = y + amp(ii)*cos(2*pi*freq(ii)*t + phase(ii));
end

end

