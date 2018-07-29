function paprSCFDMA()

dataType = 'Q-PSK'; % Modulation format.
totalSubcarriers = 512; % Number of total subcarriers.
numSymbols = 16; % Data block size.
Q = totalSubcarriers/numSymbols; % Bandwidth spreading factor of IFDMA.
Q_tilda = 31; % Bandwidth spreading factor of DFDMA. Q_tilda < Q.
subcarrierMapping = 'IFDMA'; % Subcarrier mapping scheme.
pulseShaping = 1; % Whether to do pulse shaping or not.
filterType = 'rc'; % Type of pulse shaping filter.
rolloffFactor = 0.0999999999; %Rolloff factor for the raised-cosine filter. 
                              %To prevent divide-by-zero, for example, use 0.099999999 instead of 0.1.
Fs = 5e6; % System bandwidth.
Ts = 1/Fs; % System sampling rate.
Nos = 4; % Oversampling factor.
if filterType == 'rc' % Raised-cosine filter.
    psFilter = rcPulse(Ts, Nos, rolloffFactor);
elseif filterType == 'rr' % Root raised-cosine filter.
    psFilter = rrcPulse(Ts, Nos, rolloffFactor);
end
numRuns = 1e4; % Number of iterations.

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

    % Convert data to frequency domain.
    X = fft(data);

    % Initialize the subcarriers.
    Y = zeros(totalSubcarriers,1);    
    
    % Subcarrier mapping.
    if subcarrierMapping == 'IFDMA'
        Y(1:Q:totalSubcarriers) = X;
    elseif subcarrierMapping == 'LFDMA'
        Y(1:numSymbols) = X;
    elseif subcarrierMapping == 'DFDMA'
        Y(1:Q_tilda:Q_tilda*numSymbols) = X;
    end

    % Convert data back to time domain.
    y = ifft(Y);

    % Perform pulse shaping.
    if pulseShaping == 1
        % Up-sample the symbols.
        y_oversampled(1:Nos:Nos*totalSubcarriers) = y;
        % Perform filtering.
        y_result = filter(psFilter, 1, y_oversampled);
    else
        y_result = y;
    end
    
    % Calculate the PAPR.
    papr(n) = 10*log10(max(abs(y_result).^2) / mean(abs(y_result).^2));
end

% Plot CCDF.
[N,X] = hist(papr, 100);
semilogy(X,1-cumsum(N)/max(cumsum(N)),'b')

% Save data.
save paprSCFDMA