function [i_out, q_out, re_byte_out, tx_done_out] = ...
    qpsk_tx(data_in, empty_in, clear_fifo_in, tx_en_in)

    [d_b2s, re_byte_b2s, tx_done_b2s] = ...
        qpsk_tx_byte2sym(data_in, empty_in, clear_fifo_in, tx_en_in);

    [d_ssrc] = qpsk_srrc(d_b2s);

    % make i/q discrete ports and scale to the full 12-bit range of the DAC
    % (one bit is for sign)
    i_out = round(real(d_ssrc)*2^11);
    q_out = round(imag(d_ssrc)*2^11);

    re_byte_out = re_byte_b2s;
    tx_done_out = tx_done_b2s;
end