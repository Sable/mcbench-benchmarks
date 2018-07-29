function FF = computeAllStatistics(fileName, win, step)

% This function computes the average and std values for the following audio
% features:
% - energy entropy
% - short time energy
% - spectral rolloff
% - spectral centroid
% - spectral flux
% 
% ARGUMENTS:
% fileName: the name of the .wav file in which the signal is stored
% win: the processing window (in seconds)
% step: the processing step (in seconds)
%
% RETURN VALUE:
% F: a 12x1 array containing the 12 feature statistics
%

[x, fs] = wavread(fileName);

EE = Energy_Entropy_Block(x, win*fs, step*fs, 10);
E = ShortTimeEnergy(x, win*fs, step*fs);
Z = zcr(x, win*fs, step*fs, fs);
R = SpectralRollOff(x, win*fs, step*fs, 0.80, fs);
C = SpectralCentroid(x, win*fs, step*fs, fs);
F = SpectralFlux(x, win*fs, step*fs, fs);

FF(1) = statistic(EE, 1, length(EE), 'std');
FF(2) = statistic(Z, 1, length(Z), 'stdbymean');
FF(3) = statistic(R, 1, length(R), 'std');
FF(4) = statistic(C, 1, length(C), 'std');
FF(5) = statistic(F, 1, length(F), 'std');
FF(6) = statistic(E, 1, length(E), 'stdbymean');

