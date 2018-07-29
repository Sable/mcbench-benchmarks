%
%
% Avetis Ioannisyan
% 10/26/05
%
% Given desired SNR and the input signal, function outputs prob of error
% occuring in AWGN environment such that N(0, No/2). The input signal is
% modulated digital using ASK with amplitude -1 and +1
%
% Example:
% coefNum = 2^17;
% SNR = [0:0.1:10];
% 
% signalTx = rand(1, coefNum);
% signalTx(find(signalTx <= 0.5)) = -1;
% signalTx(find(signalTx > 0.5)) = +1;
% 
% [Pe] = BPSK_AWGN_Pe(signalTx, SNR);
% 
% semilogy(SNR, Pe);


function [Pe] = BPSK_AWGN_Pe(signalTx, SNR)

% number of coef to generate (length) 
coefNum = length(signalTx);

N0=[]; AWGN=[]; Pe=[]; signalRx=[];
% create white noise N(0, 0.5)
randn('state',sum(100*clock));      %reset randomizer
AWGN = randn(length(SNR), coefNum);

for i = 1:length(SNR)
	% make noise level from specified SNR:  No = 1/(10^(SNR/10)) assuming Eb=1
	N0(i) = 1/(10^(SNR(i)/10));  %generate No, or, sqrt(variance) = No for the WGN noise
	% adjust for the desired N(0,No/2) =>  X = mue + sqrt(var)*N(0, 0.5)
	AWGN(i,:) = sqrt(N0(i)./2) .* AWGN(i,:);
	
	% produce received signal
	signalRx(i,:) = signalTx + AWGN(i,:);
	
	% perform signal detection
	signalRx(i, find(signalRx(i,:) <= 0)) = -1;
	signalRx(i, find(signalRx(i,:) > 0)) = +1;
	
	% estimate error probability
	error = length(find(signalRx(i,:)-signalTx));
	Pe(i) = error / coefNum;
end