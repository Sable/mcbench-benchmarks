%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QPSK demonstration packet-based transceiver for Chilipepper
% Toyon Research Corp.
% http://www.toyon.com/chilipepper.php
% Created 10/17/2012
% embedded@toyon.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is the top level entry function for the receiver portion of the
% example. The entire receiver is designed to run at Rate=1 (one clock
% cycle per iteration of the core. 
% We follow standard receive practice with frequency offset estimation,
% pulse-shape filtering, time estimateion, and correlation to determine
% start of packet.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%#codegen

function [r_out, s_f_out, s_c_out, f_est_out] = ...
    qpsk_rx(i_in, q_in, mu_foc_in)
 
    % scale input data coming from the Chilipepper ADC to be purely fractional
    % to avoid scaling issues
    r_in = complex(i_in, q_in);

    % frequency offset estimation. Note that time constant is input as integer
    [s_f_i, s_f_q, fe] = qpsk_rx_foc(i_in, q_in, mu_foc_in);

    % Square-root raised-cosine band-limited filtering
    [s_c_i, s_c_q] = qpsk_rx_srrc(s_f_i, s_f_q);

    % frequency estimation value
    f_est_out = fe;

    % original signal out (real version)
    r_out = real(r_in);

    % incremental signal outputs after frequency estimation and filtering
    s_f_out = complex(s_f_i,s_f_q);
    s_c_out = complex(s_c_i,s_c_q);
end