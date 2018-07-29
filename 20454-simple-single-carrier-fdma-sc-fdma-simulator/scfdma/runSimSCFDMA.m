function runSimSCFDMA()

SP.FFTsize = 512;
SP.inputBlockSize = 16;
SP.CPsize = 20;
%SP.subband = 15;
SP.subband = 0;

SP.SNR = [0:2:20];
SP.numRun = 10^5;

% TS 25.104
pedAchannel = [1 10^(-9.7/20) 10^(-22.8/20)];
pedAchannel = pedAchannel/sqrt(sum(pedAchannel.^2));
vehAchannel = [1 0 10^(-1/20) 0 10^(-9/20) 10^(-10/20) 0 0 0 10^(-15/20) 0 0 0 10^(-20/20)];
vehAchannel = vehAchannel/sqrt(sum(vehAchannel.^2));
idenChannel = 1;

SP.channel = idenChannel;
%SP.channel = pedAchannel;
%SP.channel = vehAchannel;

SP.equalizerType ='ZERO';
%SP.equalizerType ='MMSE';

[SER_ifdma SER_lfdma] = scfdma(SP);

save scfdma_awgn
