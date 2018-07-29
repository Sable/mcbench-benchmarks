function [out_vec] = tgn_model(in_vec)
% tgn_model.m - TGn channel model simulation (load external coeff's)
global numPkts PER_snr snr_idx num_taps H H_idx_inc H_idx_ini H_idx H_cnt H_dline;

% PER graph settings (actual values are user-selected (GUI))
%%%%% numPkts = 200;
%%%%% PER_snr = 29:2:37;

% To select channel matrices
numCoherenceTimes = 10;                        % num of coherence times to test
numSampPerCohere = numPkts/numCoherenceTimes;  % max value = 442 (num of ch. samples in one coherence time)

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
%%%%% Channel Model (external coeff's)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for Channel D
chD_wdth   = [   10     10     10     10     10     10     10     10     10     20     30     30     30     40     50     50     50     50];

% define imag. component
j = sqrt(-1);

% Initialize channel model
if (Clk==0)
    % Initialize PER test
    snr_idx = 1;
    % Load Channel D coeff's
    load tgn_d_nlos;
    % Setup channel coeff's for PER test
    H_cohere_prd = ceil(size(H, 4)/100);  % ch. mat samples in one coherence time (100 simulated)
    H_idx_inc = round(H_cohere_prd / numSampPerCohere);
    % Setup indices for channel coeff's
    num_taps = size(H, 3);
    H_idx_ini = 100; %100; %2000;  % initial index for channel matrices 
    H_idx = H_idx_ini;
    H_cnt = 1;

    % Initialize channel delay line
    tot_dly = sum(chD_wdth)/10;
    H_dline = zeros(Ntx, tot_dly);
end

% Use fixed channel for each packet
%     - assume 38400 samples for each packet (with silence added)
if 1  %(FIXED_CHANNEL)
 % Get channel coeff's
 H_tap(:,:,:) = H(:,:,:,H_idx);
 % Increment index after every packet... 
 H_idx = H_idx + H_idx_inc;
 
 % Reuse channel coeff's for each SNR tested...
 if (mod(Clk,numPkts)==(numPkts-1))  H_idx = H_idx_ini;  end
end

% Process all input samples...
for i=1:in_len
    
    % Add new sample to delay line
    H_dline = [ch_in(:,i) H_dline(:,1:end-1)];
        
    % Apply channel filter
    H_dline_idx = 1;
    H_out = zeros(Nrx,1);
    for m=1:num_taps
if 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Apply tap to inputs (considering tap width)
        H_samp = zeros(Ntx, 1);
        for k = 1:(chD_wdth(m)/10)
            % 10 ns (100 MHz) sampling
            H_samp = H_samp + H_dline(:,H_dline_idx);
            H_dline_idx = H_dline_idx + 1;
        end
        H_out = H_out + H_tap(:,:,m)*H_samp;
else %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Apply tap to inputs (considering tap width)
        for k = 1:(chD_wdth(m)/10)
  if 1 % 10 ns (100 MHz) sampling
            H_out = H_out + H_tap(:,:,m)*H_dline(:,H_dline_idx);
  else % 50 ns (20 MHz) sampling
            if mod(H_dline_idx,5)==1
                H_out = H_out + H_tap(:,:,m)*H_dline(:,1+floor(H_dline_idx/5));
            end
  end
            H_dline_idx = H_dline_idx + 1;
        end
end  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end

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

