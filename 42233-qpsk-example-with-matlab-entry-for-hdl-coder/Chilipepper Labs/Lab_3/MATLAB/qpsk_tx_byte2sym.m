%#codegen
% this core runs at an oversampling rate of 8
function [d_out, re_byte_out, tx_done_out] = ...
    qpsk_tx_byte2sym(data_in, empty_in, clear_fifo_in, tx_en_in)

    OS_RATE = 8;
    SYM_PER_BYTE = 4; % number of symbols per byte (QPSK 4)
    tbi = TB_i;
    tbq = TB_q;
    CORE_LATENCY = 8;

    persistent count
    persistent symIndex
    persistent diLatch dqLatch
    persistent tx_fifo
    persistent wrCount rdCount
    persistent txDone
    persistent sentTrain
    persistent reBuf

    if isempty(count)
        count = 0;
        symIndex = 0;
        diLatch = 0; dqLatch = 0;
        wrCount = 0; rdCount = 0;
        txDone = 0;
        sentTrain = 0;
        reBuf = 0;
    end
    if isempty(tx_fifo)
        tx_fifo = zeros(1,1024);  % internal tx buffer (1024 bytes)
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if want to transmit a new packet reset variables
    if clear_fifo_in == 1
        wrCount = 0;
        txDone = 0;
        reBuf = 0;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we are ready to transmit some data
    rdIndex = wrCount-rdCount+1;     % as rd decrements, index increments
    if rdIndex <= 0
        rdIndex = 1024;
    end
    data = tx_fifo(rdIndex);         % get next byte of data
    d_out = 0;                       % initialize output
% fifo should be empty and the processor says go ahead and transmit
% we stop when we've written all the data out that we wrote to the fifo.
% This core doesn't care about packet length, just about how many bytes
% were written to the fifo.
    PAD_BITS = 24;
    if empty_in == 1 && tx_en_in == 1 && txDone == 0
        if sentTrain <= 65+PAD_BITS                 % Overhead bits
            if count == 0 && sentTrain <= PAD_BITS  % sending pad bits
                diLatch = mod(sentTrain,2);
                diLatch = diLatch*2-1;
                dqLatch = diLatch;
            elseif count == 0                       % sending header bits
                diLatch = tbi(sentTrain-PAD_BITS);
                dqLatch = tbq(sentTrain-PAD_BITS);
            end
            count = count + 1;                  % increment latency counter
            if count >= OS_RATE
                count = 0;                      % reset latency counter
                sentTrain = sentTrain + 1;      % next bit
            end
        else % sending data!
            if mod(count,OS_RATE) == 0          % Latency check
                sym2 = symIndex*2;
                diLatch = mybitget(data,sym2+1)*2-1;    % get next i bit
                dqLatch = mybitget(data,sym2+2)*2-1;    % get next j bit
                symIndex = symIndex + 1;                % next symbol index
            end
            count = count + 1;                  % increment latency counter
            if count >= OS_RATE*SYM_PER_BYTE
                count = 0;                      % reset latecny counter
                symIndex = 0;                   % reset symbol index
                rdCount = rdCount - 1;          % get next byte
            end
            if rdCount == 0                   % when transmitted all bytes
                txDone = 1;                   % done transmitting
            end
        end
        d_out = complex(diLatch, dqLatch);    % output i and q bit
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% transfer data from processor to internal buffer. Because the core has a
% non-zero throughput we need to stale a bit for the requested data to make
% it to our input.
    wrIndex = 1024;
    re_byte_out = 0;
    if empty_in == 0 && reBuf == 0
        reBuf = CORE_LATENCY;  % initialize tx_fifo latency counter
        txDone = 0;            % initialize done sending variable
        re_byte_out = 1;       % read tx_fifo buffer line (active high)
    end
    if reBuf > 0
        reBuf = reBuf - 1;     % decrement tx_fifo latency counter
    end
    if reBuf == 1
        wrCount = wrCount + 1; % total number of bytes written
        wrIndex = wrCount;     % offset used to write to end of tx_fifo
        rdCount = wrCount;     % track bytes (read) when transmitting
        reBuf = 0;             % maintain latency for reading from tx_fifo 
        count = 0;             % maintain latency for tx packet
        sentTrain = 1;         % current byte location of packet overhead
    end
    tx_fifo(wrIndex) = data_in;
    tx_done_out = txDone;
end