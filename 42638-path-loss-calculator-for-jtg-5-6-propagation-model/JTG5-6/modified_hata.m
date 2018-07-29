function [ loss ] = modified_hata( freq, urban_suburban_rural, tx_height, rx_height, distance)
%modified_hata Implementation of the modified Hata model based on R-ITU-R  SM.2028-1
    rHm = min(rx_height, tx_height);
    rHb = max(rx_height, tx_height);

    rCorr = log10(distance + (tx_height - rx_height)^2/10^6);
    rA = (1.1 * log10(freq) - 0.7) * min(10, rHm) - (1.56 * log10(freq) - 0.8) + max(0, 20 * log10(rHm / 10));
    rB = min(0, 20 * log10(rHb / 30));

    %urban result
    loss = 69.6 + 26.2 * log10(freq) - 13.82 * log10(max(30, rHb)) + (44.9 - 6.55 * log10(max(30, rHb))) * rCorr - rA - rB;

    if urban_suburban_rural == 2
        new_freq = log10(min(max(150, freq), 2000) / 28);
        loss = loss - 2 * (new_freq * new_freq) - 5.4;
    elseif urban_suburban_rural == 3
        adjustedFrequency  = log10(min(max(150, freq), 2000));
        loss = loss - 4.78 * (adjustedFrequency * adjustedFrequency) + 18.33 * adjustedFrequency - 40.94;
    end
    

end

