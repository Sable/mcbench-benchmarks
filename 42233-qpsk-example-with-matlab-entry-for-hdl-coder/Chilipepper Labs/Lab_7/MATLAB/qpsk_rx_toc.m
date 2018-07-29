%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QPSK demonstration packet-based transceiver for Chilipepper
% Toyon Research Corp.
% http://www.toyon.com/chilipepper.php
% Created 10/17/2012
% embedded@toyon.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%#codegen
function [s_i, s_q, tauh] = qpsk_rx_toc(r_i, r_q, mu_in)

persistent counter
persistent tau
persistent rBuf_i rBuf_q
persistent symLatch_i symLatch_q
persistent tEst

OS_RATE = 8;
if isempty(counter)
    counter = 0;
    tau = 0;
    rBuf_i = zeros(1,4*OS_RATE);
    rBuf_q = zeros(1,4*OS_RATE);
    symLatch_i = 0; symLatch_q = 0;
    tEst = 0;
end

mu = mu_in/2^12;

rBuf_i = [rBuf_i(2:end) r_i];
rBuf_q = [rBuf_q(2:end) r_q];

if counter == 0
    taur = round(tau);
    % if we shift out of the window just exit
    if abs(taur) >= OS_RATE
        tau = 0;
        taur = 0;
    end

    % Determine lead/lag values and compute offset error
    zl_i = rBuf_i(2*OS_RATE+taur-1);
    zo_i = rBuf_i(2*OS_RATE+taur);
    ze_i = rBuf_i(2*OS_RATE+taur+1);
    zl_q = rBuf_q(2*OS_RATE+taur-1);
    zo_q = rBuf_q(2*OS_RATE+taur);
    ze_q = rBuf_q(2*OS_RATE+taur+1);
    od_r = ze_i-zl_i;
    od_i = ze_q-zl_q;
    oe_r = zo_i*od_r;
    oe_i = zo_q*od_i;
    % using sign of error in order to make gain invariant
    os = oe_r+oe_i;
    if os < 0
        oe = -1;
    else
        oe = 1;
    end

    % update tau
    tau = tau + mu*oe;
    
    tEst = tau;

    symLatch_i = zo_i;
    symLatch_q = zo_q;
end

s_i = symLatch_i;
s_q = symLatch_q;
tauh = tEst;

counter = counter + 1;
if counter >= OS_RATE
    counter = 0;
end