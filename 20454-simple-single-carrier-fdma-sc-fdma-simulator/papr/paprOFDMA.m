function paprOFDMA()

dataType = 'Q-PSK'; % Modulation format.
totalSubcarriers = 512; % Number of total subcarriers.
numSymbols = 16; % Data block size.
Fs = 5e6; % System bandwidth.
Ts = 1/Fs; % System sampling rate.
Nos = 4; % Oversampling factor.
Nsub = totalSubcarriers;
Fsub = [0:Nsub-1]*Fs/Nsub; % Subcarrier spacing.
numRuns = 1e4; % Number of runs.

papr = zeros(1,numRuns); % Initialize the PAPR results.

for n = 1:numRuns,
    % Generate random data.
    if dataType == 'Q-PSK'
        tmp = round(rand(numSymbols,2));
        tmp = tmp*2 - 1;
        data = (tmp(:,1) + j*tmp(:,2))/sqrt(2);
    elseif dataType == '16QAM'
        dataSet = [-3+3i -1+3i 1+3i 3+3i ...
            -3+i -1+i 1+i 3+i ...
            -3-i -1-i 1-i 3-i ...
            -3-3i -1-3i 1-3i 3-3i];
        dataSet = dataSet / sqrt(mean(abs(dataSet).^2));
        tmp = ceil(rand(numSymbols,1)*16);
        for k = 1:numSymbols,
            if tmp(k) == 0
                tmp(k) = 1;
            end
            data(k) = dataSet(tmp(k));
        end
        data = data.';
    end
    
    % Time range of the OFDM symbol.
    t = [0:Ts/Nos:Nsub*Ts];

    % OFDM modulation.
    y = 0;
    for k = 1:numSymbols,
        y= y + data(k)*exp(j*2*pi*Fsub(k)*t);
    end
    
    % Calculate PAPR.
    papr(n) = 10*log10(max(abs(y).^2) / mean(abs(y).^2));
end

% Plot CCDF.
[N,X] = hist(papr, 100);
semilogy(X,1-cumsum(N)/max(cumsum(N)),'b')

% Save data.
save paprOFDMA