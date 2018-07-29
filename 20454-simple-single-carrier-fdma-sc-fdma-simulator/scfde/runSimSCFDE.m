function runSimSCFDE()

SP.FFTsize = 512;
SP.CPsize = 20;

SP.SNR = [0:2:30];
SP.numRun = 10^4;

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

SER_scfde = scfde(SP);
SER_ofdm = ofdm(SP);
save scfde_awgn

SP.channel = pedAchannel;
SP.equalizerType ='ZERO';
SER_scfde = scfde(SP);
SER_ofdm = ofdm(SP);
save scfde_pedA_zero

SP.channel = pedAchannel;
SP.equalizerType ='MMSE';
SER_scfde = scfde(SP);
SER_ofdm = ofdm(SP);
save scfde_pedA_mmse

SP.channel = vehAchannel;
SP.equalizerType ='ZERO';
SER_scfde = scfde(SP);
SER_ofdm = ofdm(SP);
save scfde_vehA_zero

SP.channel = vehAchannel;
SP.equalizerType ='MMSE';
SER_scfde = scfde(SP);
SER_ofdm = ofdm(SP);
save scfde_vehA_mmse

SP.CPsize = 0;

SP.channel = pedAchannel;
SP.equalizerType ='MMSE';
SER_scfde = scfde(SP);
SER_ofdm = ofdm(SP);
save scfde_pedA_noCP_mmse

SP.channel = vehAchannel;
SP.equalizerType ='MMSE';
SER_scfde = scfde(SP);
SER_ofdm = ofdm(SP);
save scfde_vehA_noCP_mmse
