clc,clear all;
% defining some common simulation parameters
frmLen = 100;       % frame length
numPackets = 10^3;  % number of packets
EbNo = 0:2:20;      % Eb/No varying to 20 dB
N = 2;              % maximum number of Tx antennas

% initializing all the BER variables
BER11 = [];
BER_mrc12 = [];
BER_mrc14 = [];
BER_alamti21 = [];
BER_alamti22 = [];

% Calculation of BER for 1x2 MRC scheme
M = 2;              % maximum number of Rx antennas
for i = 1:11,
    BER_mrc12 = [BER_mrc12 mrc_new(M, frmLen, numPackets, EbNo(i))];
end
% plot of the BER values for 1x2 MRC scheme 
figure(1)
% BER_mrc12 = berfit(EbNo, BER_mrc12);
semilogy(EbNo,BER_mrc12,'g*-');
legend('simulated MRC scheme 1T2R'); 
axis([0 20 10^-5 1]);
xlabel('Eb/No (dB)'); ylabel('BER');
title('Plot of bit error probability of 1x2 MRC scheme');

% Calculation of BER for 1x4 MRC scheme
M = 4;              % maximum number of Rx antennas
for i = 1:11,
    BER_mrc14 = [BER_mrc14 mrc_new(M, frmLen, numPackets, EbNo(i))];
end
% plot of the BER values for 1x4 MRC scheme
figure(2)
% BER_mrc14 = berfit(EbNo, BER_mrc14);
semilogy(EbNo,BER_mrc14,'bd-');
legend('simulated MRC scheme 1T4R'); 
axis([0 20 10^-5 1]);
xlabel('Eb/No (dB)'); ylabel('BER');
title('Plot of bit error probability of 2x2 MRC scheme');

% Calculation of BER for 2x1 Alamouti scheme
M = 1;              % maximum number of Rx antennas
for i = 1:11,
    BER_alamti21 = [BER_alamti21 alamouti_new(M, frmLen, numPackets, EbNo(i))];
end
% plot of the BER values for 2x1 Alamouti scheme 
figure(3)
% BER_alamti21 = berfit(EbNo, BER_alamti21);
semilogy(EbNo,BER_alamti21,'mp-');
legend('simulated Alamouti scheme 2T1R');
axis([0 20 10^-5 1]);
xlabel('Eb/No (dB)'); ylabel('BER');
title('Plot of bit error probability of 2x1 Alamouti scheme');

% Calculation of BER for 2x2 Alamouti scheme
M = 2;              % maximum number of Rx antennas
for i = 1:11,
    BER_alamti22 = [BER_alamti22 alamouti_new(M, frmLen, numPackets, EbNo(i))];
end
% plot of the BER values for 2x2 Alamouti scheme
figure(4)
% BER_alamti22 = berfit(EbNo, BER_alamti22);
semilogy(EbNo,BER_alamti22,'ko-');
legend('simulated Alamouti scheme 2T2R');
axis([0 20 10^-5 1]);
xlabel('Eb/No (dB)'); ylabel('BER')
title('Plot of bit error probability of 2x2 Alamouti scheme');

% Calculation of BER for 1x1 BPSK scheme
M = 1;              % maximum number of Rx antennas
for i = 1:11,
    BER11 = [BER11 mrc_new(M, frmLen, numPackets, EbNo(i))];
end
% plot of the BER values for 1x1 BPSK scheme 
figure(5)
semilogy(EbNo,BER11,'gp-');
legend('simulated BPSK without diversity'); 
axis([0 20 10^-5 1]);
xlabel('Eb/No (dB)'); ylabel('BER');
title('Plot of bit error probability of 1x1 BPSK scheme');

        
% Now, plotting the all error probabilities together....
figure(6)
semilogy(EbNo,BER11,'rp-');
axis([0 20 10^-5 1]);
hold on;
semilogy(EbNo,BER_mrc12,'g*-');
semilogy(EbNo,BER_mrc14,'bd-');
semilogy(EbNo,BER_alamti21,'mp-');
semilogy(EbNo,BER_alamti22,'ko-');
xlabel('Eb/No (dB)'); ylabel('BER')
title('Comparison of performance of MRC & Alamouti schemes');
legend('simulated BPSK without diversity','simulated MRC scheme 1T2R',...
    'simulated MRC scheme 1T4R','simulated Alamouti scheme 2T1R',...
    'simulated Alamouti scheme 2T2R'); 
