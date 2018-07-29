function [out_vec] = ch_model_awgn(in_vec)
% ch_model_awgn.m - AWGN channel model simulation
global numPkts  PER_snr  snr_idx  ch_type  num_taps ...
       H  H_idx_inc  H_idx_ini  H_idx  H_cnt  H_dline;

% PER graph settings (actual values are user-selected (GUI))
%%%%% numPkts = 200;
%%%%% PER_snr = 29:2:37;

% Input parameters
Clk = in_vec(1);
Ntx = in_vec(2);
Nrx = in_vec(3);
Nltf = in_vec(4);

% Index for additive noise
%     - perfect channel estimation for AWGN channel...
%     - add noise after 8 legacy sym, HT-LTF symbols (with 6 sample delay)
nse_idx = 5*80*(8+Nltf) + 5*6;

% Channel inputs
in_len = length(in_vec(5:end))/4;
ch_in  = zeros(4, in_len);
ch_in(1,:) = in_vec(0*in_len+3+(1:in_len)).';
ch_in(2,:) = in_vec(1*in_len+3+(1:in_len)).';
ch_in(3,:) = in_vec(2*in_len+3+(1:in_len)).';
ch_in(4,:) = in_vec(3*in_len+3+(1:in_len)).';
ch_in = ch_in(1:Ntx,:);  % keep only used Tx ant. inputs

% Channel outputs
ch_out = zeros(4, in_len);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Channel Model (AWGN channel)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define imag. component
j = sqrt(-1);

% Initialize channel model
if (Clk==0)
    % Initialize PER test
    snr_idx = 1;
    % Setup AWGN channel coeff's for PER test
    n = [1:Nrx]'*[1:Ntx];
    H = 1/sqrt(Ntx)*exp(-2j*pi*n/Ntx);
end

% Compute channel power...
H_pow = 0;
H_pow = H_pow + sum(sum(H.*conj(H)))/Nrx;

% Process all input samples...
for i=1:in_len
    % Apply AWGN channel
    H_out = H*ch_in(:,i);

    % Store channel output
    ch_out(1:Nrx,i) = H_out;
end

% Compute noise variance (time-domain)
nse_sigma = 1/5;                    % signal upsampled by 5
nse_sigma = sqrt(0.5*nse_sigma);

% Add AWGN to Rx streams
snr_val = 2+PER_snr(snr_idx);
for i=1:Nrx
    % Generate additive noise
    nse_size = size(ch_out(i,nse_idx:end));
    nse_out = nse_sigma * (randn(nse_size) + j*randn(nse_size));
    nse_out = nse_out * 10^(-snr_val/20);
    % Add noise to channel output
    ch_out(i,nse_idx:end) = ch_out(i,nse_idx:end) + nse_out;
end

% Next SNR Value for PER Curve...
if (mod(Clk,numPkts)==(numPkts-1) && snr_idx<length(PER_snr))
    snr_idx = snr_idx+1;
end

% Return output
out_vec = reshape(ch_out.', 4*in_len, 1);

