function prob = prob_symb_error_MFSK1(M,SNR_dB)

%SNR : Signal to noise ratio per symbol in dBs

SNR = dBstoSNR(SNR_dB);

% Probability of a symbol error

prob = 0;


% Proakis p.310

% Probability of a symbol error
for n = 1:M-1
    prob = prob + ((-1)^(n+1) * nchoosek(M-1,n) * (1/(n+1)) * exp((-1) * (n/(n+1)) * SNR));
end
