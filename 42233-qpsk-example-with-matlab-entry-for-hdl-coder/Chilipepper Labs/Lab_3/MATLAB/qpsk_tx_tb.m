%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Initialization and Model/simulation parameters %%%%%%%%%%%%%%
sim = 0;     % simulation param (1 is sim qpsk, 0 is loaded from chipscope)
OS_RATE = 8;
make_srrc_lut;
make_train_lut;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% load packet that was transmitted and captured from chipscope %%%%%%
if (~sim)
    xlLoadChipScopeData( 'tx.prn' );
    iFile = tx_i( 1:end )/2^11;
    qFile = tx_q( 1:end )/2^11;
    x = complex( iFile, qFile );
else
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Emulate microprocessor packet creation %%%%%%%%%%%%%%%%%%%
    % data payload creation
    messageASCII = 'Hello World!';
    message = double( unicode2native( messageASCII ) );
    
    % add on length of message to the front with four bytes
    msgLength = length( message );
    messageWithNumBytes = [ mod( msgLength, 2^8 ),...
        mod( floor( msgLength/2^8 ), 2^8 ),...
        mod( floor( msgLength/2^16 ), 2^8 ), 1, message ];
    
    % add two bytes at the end, which is a CRC
    messageWithCRC = CreateAppend16BitCRC( messageWithNumBytes );
    ml = length( messageWithCRC );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% FPGA radio transmit core%%%%%%%%%%%%%%%%%%%%%%%%%
    data_in = 0;
    empty_in = 1;
    tx_en_in = 0;
    numBytesFromFifo = 0;
    num_samp = ml*8*2*2*3;
    x = zeros( 1, num_samp );
    CORE_LATENCY = 4;
    data_buf = zeros( 1, CORE_LATENCY );
    empty_buf = ones( 1, CORE_LATENCY );
    clear_buf = zeros( 1, CORE_LATENCY );
    tx_en_buf = zeros( 1, CORE_LATENCY );
    for i1 = 1:num_samp
        % first thing the processor does is clear the internal tx fifo
        if i1==1
            clear_fifo_in = 1;
        else
            clear_fifo_in = 0;
        end
        if i1==5  % wait a little bit then begin to load the fifo
            empty_in = 0;
            numBytesFromFifo = 0;
        end
        data_buf = [ data_buf( 2:end ), data_in ];
        empty_buf = [ empty_buf( 2:end ), empty_in ];
        clear_buf = [ clear_buf( 2:end ), clear_fifo_in ];
        tx_en_buf = [ tx_en_buf( 2:end ), tx_en_in ];
        [i_out,q_out,re_byte_out,tx_done_out] = qpsk_tx( data_buf( 1 ),...
            empty_buf( 1 ), clear_buf( 1 ), tx_en_buf( 1 ) );
        x_out = complex( i_out, q_out )/2^11;
        x( i1 ) = x_out;
        %%% Emulate read FIFO AXI interface
        if re_byte_out==1 && numBytesFromFifo<length( messageWithCRC )
            data_in = messageWithCRC( numBytesFromFifo + 1 );
            numBytesFromFifo = numBytesFromFifo + 1;
        end
        % processor loaded all bytes into FIFO so begin transmitting
        if numBytesFromFifo==length( messageWithCRC )
            empty_in = 1;
            tx_en_in = 1;
        end
    end
end
index = find( abs( x )>sum( SRRC ) );
% constant is pad bits
offset = index( 1 ) + (24*OS_RATE) + 6 + length( TB_i )*OS_RATE;
if (~sim)
    idx = offset:OS_RATE:index(end)-(OS_RATE*4*3);
else
    idx = offset:OS_RATE:index(end);
end
% seperate the channels
y = x( idx );
sc = zeros( 1, 2*length(y));
sc( 1:2:end ) = real( y );
sc( 2:2:end ) = imag( y );
sh = sign( sc );
sb = (sh + 1)/2;
d = zeros( 1, length(y)/4 );
% convert the data to decimal numbers
for i1 = 1:length(y)/4
    si = sb( 1 + (i1 - 1)*8:i1*8 );
    d( i1 ) = bi2de( round(si) );
end
% plot i and q channels and display the recovered messeage
figure( 1 )
clf
plot( real( x ), 'red' )
hold on
plot( imag( x ), 'green' )
title( 'Transmit samples' );
disp('Your message was');
disp(native2unicode(d(5:end-2)));

