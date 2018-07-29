function [SER_ifdma SER_lfdma] = scfdma(SP)

numSymbols = SP.FFTsize;
Q = numSymbols/SP.inputBlockSize;
H_channel = fft(SP.channel,SP.FFTsize);

for n = 1:length(SP.SNR),
    tic;
    errCount_ifdma = 0;
    errCount_lfdma = 0;

    for k = 1:SP.numRun,
        tmp = round(rand(2,SP.inputBlockSize));
        tmp = tmp*2 - 1;
        inputSymbols = (tmp(1,:) + i*tmp(2,:))/sqrt(2);
    
        inputSymbols_freq = fft(inputSymbols);
        inputSamples_ifdma = zeros(1,numSymbols);
        inputSamples_lfdma = zeros(1,numSymbols);

        inputSamples_ifdma(1+SP.subband:Q:numSymbols) = inputSymbols_freq;
        inputSamples_lfdma([1:SP.inputBlockSize]+SP.inputBlockSize*SP.subband) = inputSymbols_freq;
        inputSamples_ifdma = ifft(inputSamples_ifdma);
        inputSamples_lfdma = ifft(inputSamples_lfdma);

        TxSamples_ifdma = [inputSamples_ifdma(numSymbols-SP.CPsize+1:numSymbols) inputSamples_ifdma];
        TxSamples_lfdma = [inputSamples_lfdma(numSymbols-SP.CPsize+1:numSymbols) inputSamples_lfdma];
        
        RxSamples_ifdma = filter(SP.channel, 1, TxSamples_ifdma); % Multipath Channel
        RxSamples_lfdma = filter(SP.channel, 1, TxSamples_lfdma); % Multipath Channel
    
        tmp = randn(2, numSymbols+SP.CPsize);
        complexNoise = (tmp(1,:) + i*tmp(2,:))/sqrt(2);
        noisePower = 10^(-SP.SNR(n)/10);
        RxSamples_ifdma = RxSamples_ifdma + sqrt(noisePower/Q)*complexNoise;
        RxSamples_lfdma = RxSamples_lfdma + sqrt(noisePower/Q)*complexNoise;
        
        RxSamples_ifdma = RxSamples_ifdma(SP.CPsize+1:numSymbols+SP.CPsize);
        RxSamples_lfdma = RxSamples_lfdma(SP.CPsize+1:numSymbols+SP.CPsize);
        Y_ifdma = fft(RxSamples_ifdma, SP.FFTsize);
        Y_lfdma = fft(RxSamples_lfdma, SP.FFTsize);
        
        Y_ifdma = Y_ifdma(1+SP.subband:Q:numSymbols);
        Y_lfdma = Y_lfdma([1:SP.inputBlockSize]+SP.inputBlockSize*SP.subband);
        
        H_eff = H_channel(1+SP.subband:Q:numSymbols);
        if SP.equalizerType == 'ZERO'
            Y_ifdma = Y_ifdma./H_eff;
        elseif SP.equalizerType == 'MMSE'
            C = conj(H_eff)./(conj(H_eff).*H_eff + 10^(-SP.SNR(n)/10));
            Y_ifdma = Y_ifdma.*C;
        end
        
        H_eff = H_channel([1:SP.inputBlockSize]+SP.inputBlockSize*SP.subband);
        if SP.equalizerType == 'ZERO'
            Y_lfdma = Y_lfdma./H_eff;
        elseif SP.equalizerType == 'MMSE'
            C = conj(H_eff)./(conj(H_eff).*H_eff + 10^(-SP.SNR(n)/10));
            Y_lfdma = Y_lfdma.*C;
        end

        EstSymbols_ifdma = ifft(Y_ifdma);
        EstSymbols_lfdma = ifft(Y_lfdma);
        
        EstSymbols_ifdma = sign(real(EstSymbols_ifdma)) + i*sign(imag(EstSymbols_ifdma));
        EstSymbols_ifdma = EstSymbols_ifdma/sqrt(2);
        EstSymbols_lfdma = sign(real(EstSymbols_lfdma)) + i*sign(imag(EstSymbols_lfdma));
        EstSymbols_lfdma = EstSymbols_lfdma/sqrt(2);

        I_ifdma = find((inputSymbols-EstSymbols_ifdma) == 0);
        errCount_ifdma = errCount_ifdma + (SP.inputBlockSize-length(I_ifdma));
        I_lfdma = find((inputSymbols-EstSymbols_lfdma) == 0);
        errCount_lfdma = errCount_lfdma + (SP.inputBlockSize-length(I_lfdma));
    end
    SER_ifdma(n,:) = errCount_ifdma / (SP.inputBlockSize*SP.numRun);
    SER_lfdma(n,:) = errCount_lfdma / (SP.inputBlockSize*SP.numRun);
    [SP.SNR(n) SER_ifdma(n,:) SER_lfdma(n,:)]
    toc
end
