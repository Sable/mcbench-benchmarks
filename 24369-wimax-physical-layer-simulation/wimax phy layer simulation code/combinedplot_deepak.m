%%% plot the combined ber for all data_rate_id please put ber_x

% g=[1/4 1/8 1/16];             % guard interval
% bw=20;                            % bandwidth
% ns=57/50;                         % sampling rate
% nfft=256;                       % no. of fft point
% n=192;                          % no.of bit
%% give the input
SNR=[0 2 4 6 8 10 12 15 18 20];
ber_0=[0.1082    0.0551    0.0141         0         0         0        0         0         0         0];
ber_1=[0.5121    0.4718    0.1815    0.0377         0         0        0         0         0         0];
ber_2=[0.4391    0.4744    0.4036    0.0973    0.0066         0        0         0         0         0];
ber_3=[0.5298    0.5099    0.4940    0.2980    0.1090    0.0028         0        0         0         0];
ber_4=[0.5232    0.5127    0.5079    0.4953    0.3668    0.1390    0.0110         0        0         0];
ber_5=[0.5047    0.5140    0.5152    0.5000    0.4755    0.3143    0.1238    0.0080        0         0];
ber_6=[0.4863    0.5179    0.5105    0.5074    0.4443    0.4328    0.3834    0.0820     0.0008           0];


semilogy(SNR,ber_0,'g*-')
grid on
% axis([0 30 10^(-4) 1])
xlabel('Signal to noise ratio ')
ylabel('Bit error rate')
title('Bit error rate for different modulation')
hold all 

semilogy(SNR,ber_1,'bo:')
semilogy(SNR,ber_2,'bs-.')
semilogy(SNR,ber_3,'rd--')
semilogy(SNR,ber_4,'rv-')
semilogy(SNR,ber_5,'m+:')
semilogy(SNR,ber_6,'mx--')
legend('BPSK1/2','QPSK1/2','QPSK3/4','16-QAM1/2','16-QAM3/4','64-QAM2/3','64-QAM3/4',3)


