% modulator
function [data_out]=mod_d(data_in,rate_id)
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
x=data_in;
% bits to symbol mapping
xnew1=reshape(x,k,length(x)/k);
xsym = bi2de(xnew1.','left-msb');
% modulating % the symbole signal xsym should be
%  a column vector containing integers between 0 to M-1
switch (rate_id)
    case {0,1,2}
       y = pskmod(xsym,M);
    case {3,4,5,6}
       y = qammod(xsym,M);
    otherwise
       display('error in modulation give proper rate_id')
end
% scatterplot(y)
%% Transmitted Signal
data_out = y;

