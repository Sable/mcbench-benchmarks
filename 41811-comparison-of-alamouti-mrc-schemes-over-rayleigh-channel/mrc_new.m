function BER1m = mrc_new(M, frmLen, numPackets, EbNo)
% mrc_new:  Maximal-Ratio Combining for 1xM antenna configurations.
%
%   ber_mrc = mrc_new(M, frmLen, numPackets, EbNo) computes the bit-error rate 
%   estimates via simulation for a Maximal-Ratio Combined configuration using 
%	one transmit antenna and M receive antennas, where the frame length, number
%   of packets simulated and the Eb/No range of values are given by M, frmLen,
%   numPackets, EbNo parameters respectively.
%
%   The simulation uses BPSK modulated symbols with appropriate receiver 
%   combining.
%
%   Suggested parameter values:
%       M = 1 to 4;  frmLen = 100; numPackets = 1000; EbNo = 0:2:20;

% Create BPSK mod-demod objects
P = 2; % modulation order
bpskmod = modem.pskmod('M', P, 'SymbolOrder', 'Gray', 'InputType', 'Integer');
bpskdemod = modem.pskdemod(bpskmod);

% Pre-allocate variables for speed
z = zeros(frmLen, M);
error1m = zeros(1, numPackets); BER1m = zeros(1, length(EbNo));

% Loop over EbNo points
for idx = 1:length(EbNo)
    % Loop over the number of packets
    for packetIdx = 1:numPackets
        data = randi([0 P-1], frmLen, 1);    % data vector per user/channel
        tx = modulate(bpskmod, data);        % BPSK modulation

        % Repeat for all Rx antennas
        tx_M = tx(:, ones(1,M));
                                                    
        % Create the Rayleigh channel response matrix
        H = (randn(frmLen, M) + 1i*randn(frmLen, M))/sqrt(2);

        % Received signal for each Rx antenna
        r = awgn(H.*tx_M, EbNo(idx));
        
        % Combiner - assume channel response known at Rx
        for i = 1:M
            z(:, i) = r(:, i).* conj(H(:, i));
        end

        % ML Detector (minimum Euclidean distance)
        demod1m = demodulate(bpskdemod, sum(z, 2)); % MR combined 

        % Determine bit errors
        error1m(packetIdx) = biterr(demod1m, data); 
    end % end of FOR loop for numPackets

    % Calculate BER for current idx
    BER1m(idx) = sum(error1m)/(numPackets*frmLen);

end  % end of for loop for EbNo
