%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QPSK demonstration packet-based transceiver for Chilipepper
% Toyon Research Corp.
% http://www.toyon.com/chilipepper.php
% Created 10/17/2012
% embedded@toyon.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% There are two major goals with this core. The first is to find the peak
% of the training sequence and then to subsequently pull out and pack the
% bits. The number of bytes transmitted is in the packet so we extract this
% to determine how many bytes to pull out. 
% The second goal is to send these bytes off to the Microblaze processor.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%#codegen
function [byte_out, en_out, s_out, o_out] = ...
    qpsk_rx_correlator(s_i_in, s_q_in)

    persistent counter
    persistent sBuf_i sBuf_q
    persistent oLatch sLatch
    persistent q detPacket
    persistent ip op
    persistent bits symCount byteCount numBytes
    t_i = TB_i;
    t_q = TB_q;
    OS_RATE = 8;
    BIT_TO_BYTE = [1 2 4 8 16 32 64 128]';

    if isempty(counter)
        counter = 0;
        sBuf_i = zeros(1,65);
        sBuf_q = zeros(1,65);
        sLatch = 0;
        oLatch = 0;
        q = 0;
        detPacket = 0;
        ip = 0; op = 0;
        bits = zeros(1,8);
        symCount = 0;
        byteCount = 0;
        numBytes = 1000;
    end
    byte_out = 0;
    en_out = 0;
    
    % found a packet, now we're ready to write the data out
    if counter == 0 && detPacket == 1
        if s_i_in < 0
            sHard_i_t = -1;
        else
            sHard_i_t = 1;
        end
        if s_q_in < 0
            sHard_q_t = -1;
        else
            sHard_q_t = 1;
        end
        sHard_i = 0; sHard_q = 0;
        switch q
            case 0
                sHard_i = sHard_i_t;
                sHard_q = sHard_q_t;
            case 1
                sHard_i = sHard_q_t;
                sHard_q = -sHard_i_t;
            case 2
                sHard_i = -sHard_i_t;
                sHard_q = -sHard_q_t;
            case 3
                sHard_i = -sHard_q_t;
                sHard_q = sHard_i_t;
        end
        sLatch = sHard_i;
        oLatch = 1;
        bits(symCount*2+1) = (sHard_i+1)/2;
        bits(symCount*2+2) = (sHard_q+1)/2;

        symCount = symCount + 1;
        if symCount >= 4
            byteCount = byteCount + 1;
            symCount = 0;
            byte_out = bits*BIT_TO_BYTE;
            en_out = 1;
            % first byte is number of bytes in payload
            if byteCount == 1
                numBytes = byte_out;
            end
            % if we exceed the packet ID  
            if byteCount > 3
                % exit if we've written all the bytes or above reasonable
                % threshold
                if byteCount == numBytes+6 || byteCount > 256
                    detPacket = 0;
                    counter = 1;
                end
            end
        end
    end

    % let's see if we can find a packet. only do so if MCU is ok to rcv packet
    if counter == 0 && detPacket == 0
        sLatch = 0;
        if s_i_in < 0
            ss_i = -1;
        else
            ss_i = 1;
        end
        if s_q_in < 0
            ss_q = -1;
        else
            ss_q = 1;
        end

        sBuf_i = [sBuf_i(2:end) ss_i];
        sBuf_q = [sBuf_q(2:end) ss_q];

        sc_iWithi = sBuf_i*t_i;
        sc_iWithq = sBuf_i*t_q;
        sc_qWithi = sBuf_q*t_i;
        sc_qWithq = sBuf_q*t_q;

        ip = abs(sc_iWithi)+abs(sc_qWithq);
        op = abs(sc_iWithq)+abs(sc_qWithi);

        % we found a packet. While we have frequency offset lock we don't 
        % know the phase offset. Here we use the inphase and quadrature 
        % phasing to determine how to rotate around the circle
        if ip > 100 % 0 or 180 angle
            if sc_iWithi > 10 && sc_qWithq > 10
                q = 0; % 0 degrees
            else
                q = 2; % 180 degrees;
            end
            detPacket = 1;
        end
        if op > 100
            if sc_iWithq > 10 && sc_qWithi < 10
                q = 3; % 90 degrees
            else
                q = 1; % 270 degrees;
            end
            detPacket = 1;
        end
        oLatch = ip+op;
        symCount = 0;
        byteCount = 0;
        numBytes = 1000;
    end

    s_out = sLatch;
    o_out = oLatch;

    % only pull data once every OS_RATE clocks
    counter = counter + 1;
    if counter >= OS_RATE
        counter = 0;
    end
end
