function SNR = Convert_SNR(SNR_dB)

% Convert back from dBs to SNR value 
%SNR_dB = 10 * Log10(SNR)

SNR = 10^(SNR_dB/10);