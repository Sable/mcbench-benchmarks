% This function generates normalized rayleigh samples based on Inverse DFT 
% method as was proposed by David J. Young, and Norman C. Beaulieu
% "The Generation of Correlated Rayleigh Random Variates by Inverse
% Discrete Fourier Transform, "
% Sample Use: 
% chan=genRayleighFading(512,ceil(10000/512),1e4,100);
% chan=chan(1:10000);
% where 10000=number of needed samples
% parameters:
% fftsize: size of fft which used
% numBlocks: number of samples/fftsize
% fs: sampling frequency(Hz)
% fd: doppler shift(Hz)

function [ outSignal ] = RayleighFading_generation( fftSize,numBlocks,fs,fd )
numSamples=fftSize*numBlocks; %total number of samples

fM=fd/fs;       %normalized doppler shift
NfM=fftSize*fM;
kM=floor(NfM); %maximum freq of doppler filter in FFT samples

doppFilter=[0,1./sqrt(2*sqrt(1-(((1:kM-1)./NfM).^2))),sqrt((kM/2)*((pi/2)-atan((kM-1)/sqrt(2*kM-1)))),...
            zeros(1,fftSize-2*kM-1),sqrt((kM/2)*((pi/2)-atan((kM-1)/sqrt(2*kM-1)))),1./sqrt(2*sqrt(1-(((kM-1:-1:1)./NfM).^2)))].';

sigmaG=sqrt((2*2/(fftSize.^2))*sum(doppFilter.^2));

gSamplesI=randn(numSamples,2);  %i.i.d gaussian input samples (in phase)
gSamplesQ=randn(numSamples,2);  %i.i.d gaussian input samples (quadrature phase)

gSamplesI=(1/sigmaG)*(gSamplesI(:,1)+1j*gSamplesI(:,2));
gSamplesQ=(1/sigmaG)*(gSamplesQ(:,1)+1j*gSamplesQ(:,2));

%filtering
filterSamples=kron(ones(numBlocks,1),doppFilter);
gSamplesI=gSamplesI.*filterSamples;
gSamplesQ=gSamplesQ.*filterSamples;

freqSignal=gSamplesI-1j*gSamplesQ;
freqSignal=reshape(freqSignal,fftSize,numBlocks);
outSignal=ifft(freqSignal,fftSize);
outSignal=abs(outSignal(:)); %Rayleigh distributed signal