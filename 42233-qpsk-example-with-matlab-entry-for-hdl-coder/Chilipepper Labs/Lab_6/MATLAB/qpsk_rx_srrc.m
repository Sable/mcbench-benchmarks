%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QPSK demonstration packet-based transceiver for Chilipepper
% Toyon Research Corp.
% http://www.toyon.com/chilipepper.php
% Created 10/17/2012
% embedded@toyon.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%#codegen
function [d_i_out, d_q_out] = qpsk_rx_srrc(d_i_in, d_q_in)

persistent buf_i buf_q

OS_RATE = 8;
f = SRRC;

if isempty(buf_i)
    buf_i = zeros(1,OS_RATE*2+1);
    buf_q = zeros(1,OS_RATE*2+1);
end

buf_i = [buf_i(2:end) d_i_in]; 
buf_q = [buf_q(2:end) d_q_in]; 

d_i_out = buf_i*f;
d_q_out = buf_q*f;