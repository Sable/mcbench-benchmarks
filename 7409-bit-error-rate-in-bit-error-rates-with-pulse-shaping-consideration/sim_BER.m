%Bit Error rates with pulse shaping consideration
%Based on the following works
% H. H. Nguyen and E. Shwedyk, "On error probabilities of DS-CDMA systems with arbitrary chip waveforms," Communications Letters, IEEE, vol. 5, pp. 78-80, 2001.
% J. M. Holtzman, "A simple, accurate method to calculate spread-spectrum multiple-access error probabilities," Communications, IEEE Transactions on, vol. 40, pp. 461-464, 1992.

clear all
clc
N = 128;                %Chip Length
K = 3;                  %Number of Users
Eb = 1;                 %Non- Coherent
EbNo_dB = 0:20;       % SNR in Decibels
EbNo = 10.^(EbNo_dB/10);
No = Eb./EbNo;
Ec = Eb/N;
pulse.type = 1;              %Pulse Type 1-Rectangular   2-Half Sine 3-Truncated guassian    4-Raised Cosine 5-Blackman pulse
[pulse] = getpulse(pulse);   %Get pulse parameters

for i = 1:length(No)
    [Peg(i), Peh(i)] = getPe(K, Ec, No(i), N, pulse);
end
semilogy(EbNo_dB, Peh, EbNo_dB, Peg)
ylabel('P_{b} - Bit error rate')
xlabel('Eb/No')
legend('Holtzmans Approximation', 'Standard Approximation')
