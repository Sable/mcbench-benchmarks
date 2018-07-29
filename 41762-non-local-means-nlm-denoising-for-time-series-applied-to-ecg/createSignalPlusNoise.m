function [noisySig,targetNoiseSigma] = createSignalPlusNoise(signal,targetSNR_dB)
% function [noisySig,targetNoiseSigma] = createSignalPlusNoise(signal,targetSNR_dB)
% this is a "helper function" to add white Gaussian noise to a signal, for
% testing denoising performance

n = length(signal);

targetSNR_lin = lin10(targetSNR_dB);

signalPower = var(signal);

targetNoiseSigma = sqrt(signalPower/targetSNR_lin);

noise = randn(size(signal)) * targetNoiseSigma;

noisySig = signal+noise;

% check 
noisePower = mean(noise.^2);
%sprintf('Sig pow = %2.2f dB, Noise pow = %2.2f dB, SNR = %2.2f',db10(signalPower),db10(noisePower), db10(signalPower/noisePower))

return