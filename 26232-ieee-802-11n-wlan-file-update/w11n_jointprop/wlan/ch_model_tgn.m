function [out_vec] = ch_model_tgn(in_vec)
% ch_model_tgn.m - TGn channel model simulation (load external coeff's)
global numPkts  PER_snr  snr_idx  ch_type  num_taps ...
       H  H_idx_inc  H_idx_ini  H_idx  H_cnt  H_dline;

% PER graph settings (actual values are user-selected (GUI))
%%%%% numPkts = 200;
%%%%% PER_snr = 29:2:37;

% To select channel matrices
numCoherenceTimes = ceil(10*numPkts/442);      % num of coherence times to test
numSampPerCohere = numPkts/numCoherenceTimes;  % max value = 442 (num of ch. samples in one coherence time)

% Input parameters
Clk = in_vec(1);
Ntx = in_vec(2);
Nrx = in_vec(3);
Nltf = in_vec(4);

% Index for additive noise
%     - add noise after 8 legacy sym, 2 HT-LTF symbols (with 6 sample delay)
%     - done to simulate with perfect channel estimation...
nse_idx = 1; %%5*80*(8+Nltf) + 5*6;

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Channel Model (external coeff's)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Various channel models, widths
ChD_Width   = [   10     10     10     10     10     10     10     10     10     20     30     30     30     40     50     50     50     50];

% Select channel model
if (1)
    ch_width = ChD_Width;
end

% Initialize channel model
if (Clk==0)
    % Initialize PER test
    snr_idx = 1;
    
    % Load Channel coeff's
    load ..\..\tgn_ch_taps\tgn_chD_nlos(fluor)_2x2_short;
    %load ..\..\tgn_ch_taps\tgn_chD_nlos_15m_4x4;
    
    % Setup channel coeff's for PER test
    H_cohere_prd = ceil(size(H, 4)/100);  % ch. mat samples in one coherence time (100 simulated)
    H_idx_inc = round(H_cohere_prd / numSampPerCohere);
    
    % Setup indices for channel coeff's
    num_taps = size(H, 3);
    H_idx_ini = 100;   % initial index for channel matrices 
    H_idx = H_idx_ini;
    H_cnt = 1;

    % Initialize channel delay line
    tot_dly = sum(ch_width)/10;
    H_dline = zeros(Ntx, tot_dly);
end

% Use fixed channel for each packet
%     - assume 38400 samples for each packet (with silence added)
if 1  %(FIXED_CHANNEL)
 % Get channel coeff's
 H_tap(1:Ntx,1:Nrx,:) = H(1:Ntx,1:Nrx,:,H_idx);
 %H_tap(:,:,:) = H(:,:,:,H_idx);
 % Increment index after every packet... 
 H_idx = H_idx + H_idx_inc;
 if (H_idx > size(H, 4)) H_idx = H_idx_ini; end

 % Compute channel power...
 H_pow = 0;
 for m=1:num_taps
    for k = 1:(ch_width(m)/10)
        He = H_tap(:,:,m);
        H_pow = H_pow + sum(sum(He.*conj(He)))/Nrx;
    end
 end
end

% Process all input samples...
for i=1:in_len
    
    % Add new sample to delay line
    H_dline = [ch_in(:,i) H_dline(:,1:end-1)];
        
    % Apply channel filter
    H_dline_idx = 1;
    H_out = zeros(Nrx,1);
    for m=1:num_taps
        % Apply tap to inputs (considering tap width)
        H_samp = zeros(Ntx, 1);
        for k = 1:(ch_width(m)/10)
            % 10 ns (100 MHz) sampling
            H_samp = H_samp + H_dline(:,H_dline_idx);
            H_dline_idx = H_dline_idx + 1;
        end
        H_out = H_out + H_tap(:,:,m).'*H_samp;
    end

    % Store channel output
    ch_out(1:Nrx,i) = H_out(1:Nrx);
end

% Compute noise variance (time-domain)
nse_sigma = H_pow*(1/5);                % signal upsampled by 5
nse_sigma = sqrt(0.5*nse_sigma);

% Add AWGN to Rx streams
snr_val = PER_snr(snr_idx);
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

