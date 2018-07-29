function [out_vec] = tgn_model(in_vec)
% tgn_model.m - TGn channel model simulation (AWGN channel)
global numPkts PER_snr snr_idx num_taps H H_idx_inc H_idx_ini H_idx H_cnt H_dline;

% PER graph settings (actual values are user-selected (GUI))
%%%%% numPkts = 200;
%%%%% PER_snr = 29:2:37;

% Input parameters
Clk = in_vec(1);
Ntx = in_vec(2);
Nrx = in_vec(3);

% Channel inputs
in_len = length(in_vec(4:end))/4;
ch_in  = zeros(4, in_len);
ch_in(1,:) = in_vec(0*in_len+3+(1:in_len)).';
ch_in(2,:) = in_vec(1*in_len+3+(1:in_len)).';
ch_in(3,:) = in_vec(2*in_len+3+(1:in_len)).';
ch_in(4,:) = in_vec(3*in_len+3+(1:in_len)).';
ch_in = ch_in(1:Ntx,:);  % keep only used Tx ant. inputs

% Channel outputs
ch_out = zeros(4, in_len);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Channel Model (AWGN channel)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define imag. component
j = sqrt(-1);

% Initialize channel model
if (Clk==0)
    % Initialize PER test
    snr_idx = 1;
    % Setup AWGN channel coeff's for PER test
    H = zeros(Nrx,Ntx);
    H(1:Nrx,1:Nrx) = eye(Nrx);
    
    % Consider multi-user STBC case (4x2 MIMO)
    if (Ntx==4 && Nrx==2)
        H = [ 1 0 0 0; 0 0 1 0 ];
    end
end

% Process all input samples...
for i=1:in_len
    % Apply AWGN channel
    H_out = H*ch_in(:,i);

    % Store channel output
    ch_out(1:Nrx,i) = H_out;
end

% Add AWGN to Rx streams (reduce SNR by 5 dB, due to upsampling)
snr_val = PER_snr(snr_idx);
for i=1:Nrx
    ch_out(i,:) = awgn(ch_out(i,:), snr_val-5, 'measured');
end

% Next SNR Value for PER Curve...
if (mod(Clk,numPkts)==(numPkts-1) && snr_idx<length(PER_snr))
    snr_idx = snr_idx+1;
end

% Return output
out_vec = reshape(ch_out.', 4*in_len, 1);

