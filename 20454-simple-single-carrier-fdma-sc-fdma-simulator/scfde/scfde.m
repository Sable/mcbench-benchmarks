function SER = scfde(SP)

numSymbols = SP.FFTsize;
H_channel = fft(SP.channel,SP.FFTsize);

for n = 1:length(SP.SNR),
    tic;
    errCount = 0;

    for k = 1:SP.numRun,
        tmp = round(rand(2,numSymbols));
        tmp = tmp*2 - 1;
        inputSymbols = (tmp(1,:) + i*tmp(2,:))/sqrt(2);
    
        TxSymbols = [inputSymbols(numSymbols-SP.CPsize+1:numSymbols) inputSymbols];
        
        RxSymbols = filter(SP.channel, 1, TxSymbols); % Multipath Channel
    
        tmp = randn(2, numSymbols+SP.CPsize);
        complexNoise = (tmp(1,:) + i*tmp(2,:))/sqrt(2);
        noisePower = 10^(-SP.SNR(n)/10);
        RxSymbols = RxSymbols + sqrt(noisePower)*complexNoise;
        
        EstSymbols = RxSymbols(SP.CPsize+1:numSymbols+SP.CPsize);
        Y = fft(EstSymbols, SP.FFTsize);
        
        if SP.equalizerType == 'ZERO'
            Y = Y./H_channel;
        elseif SP.equalizerType == 'MMSE'
            C = conj(H_channel)./(conj(H_channel).*H_channel + 10^(-SP.SNR(n)/10));
            Y = Y.*C;
        end
        
        EstSymbols = ifft(Y);
        
        EstSymbols = sign(real(EstSymbols)) + i*sign(imag(EstSymbols));
        EstSymbols = EstSymbols/sqrt(2);

        I = find((inputSymbols-EstSymbols) == 0);
        errCount = errCount + (numSymbols-length(I));
    end
    SER(n,:) = errCount / (numSymbols*SP.numRun);
    [SP.SNR(n) SER(n,:)]
    toc
end