%#codegen
% this core runs at an oversampling rate of 8
function [d_out, re_byte_out, tx_done_out, d1, d2, d3] = ...
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
    diLatch = 0;
    dqLatch = 0;
    wrCount = 0; rdCount = 0;
    txDone = 0;
    sentTrain = 0;
    reBuf = 0;
end
if isempty(tx_fifo)
    tx_fifo = zeros(1,1024);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if want to transmit a new packet reset things
if clear_fifo_in == 1
    wrCount = 0;
    txDone = 0;
    reBuf = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we are ready to transmit some data
rdIndex = wrCount-rdCount+1;
if rdIndex <= 0
    rdIndex = 1024;
end
data = tx_fifo(rdIndex);

d_out = 0;
% fifo should be empty and the processor says go ahead and transmit
% we stop when we've written all the data out that we wrote to the fifo.
% This core doesn't care about packet length, just about how many bytes got
% written to the fifo.
PAD_BITS = 24;
if empty_in == 1 && tx_en_in == 1 && txDone == 0
    if sentTrain <= PAD_BITS
        if count == 0
            diLatch = mod(sentTrain,2)*2-1;
            dqLatch = mod(sentTrain,2)*2-1;
        end
        count = count + 1;
        if count >= OS_RATE
            count = 0;
            sentTrain = sentTrain + 1;
        end
        d_out = complex(diLatch,dqLatch);
    elseif sentTrain <= 65+PAD_BITS
        if count == 0
            diLatch = tbi(sentTrain-PAD_BITS);
            dqLatch = tbq(sentTrain-PAD_BITS);
        end
        count = count + 1;
        if count >= OS_RATE
            count = 0;
            sentTrain = sentTrain + 1;
        end
        d_out = complex(diLatch,dqLatch);
    else
        if mod(count,OS_RATE) == 0
            sym2 = symIndex*2;
            diLatch = mybitget(data,sym2+1)*2-1;
            dqLatch = mybitget(data,sym2+2)*2-1;
            symIndex = symIndex + 1;
        end
        d_out = complex(diLatch, dqLatch);

        count = count + 1;
        if count >= OS_RATE*SYM_PER_BYTE
            count = 0;
            symIndex = 0;
            rdCount = rdCount - 1;
        end
        if rdCount == 0
            txDone = 1;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% transfer data from processor to internal buffer
% Because the core has a non-zero throughput we need to stale a bit for the
% requested data to make it to our input. So, I'm doing that we reBuf
% counter. There are definitely more efficient ways to do this but I'm
% gonna leave that for another day.
wrIndex = 1024;
re_byte_out = 0;
if empty_in == 0 && reBuf == 0
    reBuf = CORE_LATENCY;
    txDone = 0;
    re_byte_out = 1;
end
if reBuf > 0
    reBuf = reBuf - 1;
end
d1 = 0;
d2 = 0;
d3 = 0;
if reBuf == 1
    wrCount = wrCount + 1; %total number of bytes to send out
    wrIndex = wrCount;
    rdCount = wrCount;
    d1 = reBuf; d2 = data_in; d3 = wrIndex;
    reBuf = 0;
    count = 0;
    sentTrain = 1;
end    
tx_fifo(wrIndex) = data_in;

tx_done_out = txDone;