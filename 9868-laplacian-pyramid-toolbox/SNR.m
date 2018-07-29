function r = SNR(in, est)
% To find SNR between input (in) and estimate (est) in decibels (dB).
%
% Reference: Vetterli & Kovacevic, "Wavelets and Subband Coding", p. 372

error = in - est;

r = 10 * log10(var(in(:), 1) / mean(error(:).^2));