function y = BPSK_mrc(M)  % M = maximum number of Rx antennas
frmLen = 100;       % frame length
numPackets = 1000;  % number of packets
EbNo = 0:2:18;     % Eb/No varying to 20 dB
N = 1;              % maximum number of Tx antennas


% Seed states for repeatability
seed = [98765 12345]; randn('state', seed(1)); rand('state', seed(2));

% Create BPSK mod-demod objects
P = 2;				% modulation order
bpskmod = modem.pskmod('M', P);
bpskdemod = modem.pskdemod(bpskmod);

% Pre-allocate variables for speed
 H  = zeros(frmLen, N, M);
 ch=zeros(frmLen,N,1);
 r12  = zeros(frmLen, 2);
 z12 = zeros(frmLen, M);
 error12 = zeros(1, numPackets); BER12 = zeros(1, length(EbNo));


% Loop over several EbNo points
for idx = 1:length(EbNo)
    % Loop over the number of packets
    for packetIdx = 1:numPackets
        data = randint(frmLen, 1, P);
       
        % data vector per user per channel
        tx = modulate(bpskmod, data);       % BPSK modulation

       % Create the Rayleigh distributed channel response matrix
        %   for two transmit and two receive antennas
       H(1:1:end, :, :) = (randn(frmLen, N, M) + j*randn(frmLen, N, M));
        
         %   for uncoded 1x1 system
        r11 = awgn(H(:, 1, 1).*tx, EbNo(idx));

          %   for Maximal-ratio combined 1x2 system
        for i = 1:M
            r12(:, i) = awgn(H(:, 1, i).*tx, EbNo(idx));
        end
        
       
        %   for Maximal-ratio combined 1x2 system
        for i = 1:M
            z12(:, i) = r12(:, i).* conj(H(:, 1, i));
        end

        
           tx2=sum(z12,2);
         
       
       demod13=demodulate(bpskdemod, tx2);

       
        error13(packetIdx)=biterr(demod13,data);
        
    end % end of FOR loop for numPackets

   
    BER13(idx) = sum(error13)/(numPackets*frmLen);

    % Plot results
     semilogy( EbNo(1:idx), BER13(1:idx), 'r*');
    
end  % end of for loop for EbNo
hold on;


fitBER13 = berfit(EbNo, BER13);

semilogy(EbNo, fitBER13, 'g');
end
