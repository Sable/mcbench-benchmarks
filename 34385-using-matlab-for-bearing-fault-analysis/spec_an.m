%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function spec_an:	 									   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the spectral analysis (PSD)  of %
% a given signal.										   %
% It gets the response signal - Y, and the time vector - t,%
% and returns the frequency vector - f, and the PSD value -%
% S.													   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [S, f] = spec_an(Y,t)
dt = t(2)-t(1);	 		% Get the time interval, as it will be
                        % used to get the sampling frequency, fs

Nfft = length(Y);		% Number of samples per cycle.
if (Nfft > 256)
    Nfft = 256;			% For maximum efficiency.
end
[S, f] = calc_psd(Y, Nfft, 2*pi/dt, hanning(Nfft));