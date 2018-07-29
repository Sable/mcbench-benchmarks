%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Model/simulation parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sim=1;
OS_RATE = 8;
SNR = 1;
fc = 10e3/20e6; % sample rate is 20 MHz, top is 10 kHz offset
muFOC = floor(.01*2^12)/2^12;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize LUTs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
make_srrc_lut;
make_train_lut;
make_trig_lut;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (sim)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Emulate microprocessor packet creation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % data payload creation
    messageASCII = 'hello world!';
    message = double(unicode2native(messageASCII));
    % add on length of message to the front with four bytes
    msgLength = length(message);
    messageWithNumBytes =[ ...
        mod(msgLength,2^8) ...
        mod(floor(msgLength/2^8),2^8) ...
        mod(floor(msgLength/2^16),2^8) ...
        1 ... % message ID
        message];
    % add two bytes at the end, which is a CRC
    messageWithCRC = CreateAppend16BitCRC(messageWithNumBytes);
    ml = length(messageWithCRC);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FPGA radio transmit core
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    data_in = 0;
    empty_in = 1;
    tx_en_in = 0;
    numBytesFromFifo = 0;
    num_samp = ml*8*2*2*3;
    x = zeros(1,num_samp);
    CORE_LATENCY = 4;
    data_buf = zeros(1,CORE_LATENCY);
    empty_buf = ones(1,CORE_LATENCY);
    clear_buf = zeros(1,CORE_LATENCY);
    tx_en_buf = zeros(1,CORE_LATENCY);
    for i1 = 1:num_samp
        % first thing the processor does is clear the internal tx fifo
        if i1 == 1
            clear_fifo_in = 1;
        else
            clear_fifo_in = 0;
        end
 
        if i1 == 5 % wait a little bit then begin to load the fifo
            empty_in = 0;
            numBytesFromFifo = 0;
        end
 
        data_buf = [data_buf(2:end) data_in];
        empty_buf = [empty_buf(2:end) empty_in];
        clear_buf = [clear_buf(2:end) clear_fifo_in];
        tx_en_buf = [tx_en_buf(2:end) tx_en_in];
        [i_out, q_out, re_byte_out, tx_done_out, d1, d2, d3] = ...
            qpsk_tx(data_buf(1),empty_buf(1),clear_buf(1),tx_en_buf(1));
        x_out = complex(i_out,q_out)/2^11;
        x(i1) = x_out;
 
        %%% Emulate read FIFO AXI interface
        if re_byte_out == 1 && numBytesFromFifo < length(messageWithCRC)
            data_in = messageWithCRC(numBytesFromFifo+1);
            numBytesFromFifo = numBytesFromFifo + 1;
        end
        % processor loaded all bytes into FIFO so begin transmitting
        if numBytesFromFifo == length(messageWithCRC)
            empty_in = 1;
            tx_en_in = 1;
        end    
    end
 
    index = find(abs(x) > sum(SRRC))+24*8; % constant is pad bits
    offset = index(1)+6+length(TB_i)*OS_RATE;
    idx = offset:8:(offset+8*ml*4-1);
    y = x(idx); % four symbos per byte of data
    sc = zeros(1,18*8);
    sc(1:2:end) = real(y);
    sc(2:2:end) = imag(y);
    sh = sign(sc);
    sb = (sh+1)/2;
    d = zeros(1,ml);
    for i1 = 1:ml
        si = sb(1+(i1-1)*8:i1*8);
        d(i1) = bi2de(si);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Emulate channel
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % pad on either side with zeros
    p = complex(zeros(1,100),zeros(1,100));
    xp = [p x p]; % pad
 
    % Apply frequency offset and receive/over-the-air AWGN
    y = xp.*exp(1i*2*pi*fc*(0:length(xp)-1));
    rC = y/max(abs(y))*.1*2^11; % this controls receive gain
    r = awgn(rC,SNR,0,1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load Chipscope samples
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (~sim)
    fid = fopen('rx.prn');
    M = textscan(fid,'%d %d %d %d','Headerlines',1);
    fclose(fid);
    is = double(M{3});
    qs = double(M{4});
    r = complex(is,qs);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main receiver core
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r_out = zeros(1,length(r));
s_f = zeros(1,length(r));
s_c = zeros(1,length(r));
f_est = zeros(1,length(r));
for i1 = 1:length(r)+200
    if i1 > length(r)
        r_in = 0;
    else
        r_in = r(i1);
    end
    i_in = round(real(r_in));
    q_in = round(imag(r_in));
    [r_out(i1), s_f(i1), s_c(i1), f_est(i1)] = ...
        qpsk_rx(i_in, q_in, floor(muFOC*2^12));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
subplot(2,2,1)
scatter(real(r),imag(r))
title('Pre FOC Signal');
subplot(2,2,3)
plot(real(r_out));
title('Pre FOC Signal (real part)');
subplot(2,2,2)
scatter(real(s_c),imag(s_c))
title('Post FOC Signal');
subplot(2,2,4)
plot(real(s_c));
title('Post FOC Signal(real part)');

figure(3)
plot(f_est);
title('Phase Estimate');

enrgy = real(s_c).^2 + imag(s_c).^2;

figure(4)
plot(enrgy)
title('Plot of Signal energy');