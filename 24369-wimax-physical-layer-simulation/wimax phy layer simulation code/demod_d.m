%%%%  Demodulator

function [data_out]=demod_d(data_in,rate_id)
% define parameter
switch (rate_id)
    case 0
       M=2;  %Size of signal constellation for BFSK  
    case {1,2}
       M=4;  %Size of signal constellation QPSK
    case {3,4}                           
       M=16;  %Size of signal constellation 16QAM
    case {5,6}                           
       M=64;  %Size of signal constellation 64QAM
    otherwise
       display('error in constellation modulator give proper rate_id')
end


k=log2(M); % no. of bits per symbol
%% Received Signal
yrx = data_in;
% %%
% scatterplot(yrx)

% Demodulate signal % result in column vector containing the value 0 to M-1
switch (rate_id)
    case {0,1,2}
      zsym = pskdemod(yrx,M);
    case {3,4,5,6}
       zsym = qamdemod(yrx,M);
    otherwise
       display('error in demodulation give proper rate_id')
end

% Symbol-to-Bit Mapping
z = de2bi(zsym,'left-msb');
data_out = reshape(z.',prod(size(z)),1);