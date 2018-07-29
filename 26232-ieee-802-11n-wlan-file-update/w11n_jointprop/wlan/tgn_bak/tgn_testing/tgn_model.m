function [out_vec] = tgn_model(in_vec)
% tgn_model.m - TGn channel model simulation
global numPkts PER_snr snc_idxs snc_dlys snr_idx H_iid H_dline P_tap Kf_tap Kv_tap R_tx R_rx;

% Channel Model Test Setup
%    0 - AWGN channel
%    1 - Channel D (no Doppler)
%    2 - Channel D (with Doppler)
test_setup = 1;

% PER graph settings (actual values are user-selected (GUI))
%%%%% numPkts = 200; %100
%%%%% PER_snr = 29:33; %15:1:21;

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
testch_out = ch_in;
ch_in = ch_in(1:Ntx,:);  % keep only used Tx ant. inputs

% Channel outputs
ch_out = zeros(4, in_len);

if (test_setup==0) %%%%%%%%%%%%%%%  AWGN channel

    if (Clk==0)  snr_idx = 1;  end

    % Add AWGN to Rx streams (reduce by 5dB, due to upsampling)
    snr_val = PER_snr(snr_idx);
    for i=1:Nrx        
        testch_out(i,:) = awgn(testch_out(i,:), snr_val-5, 'measured');
    end

    % Next SNR Value for PER Curve...
    if (mod(Clk,numPkts)==(numPkts-1) && snr_idx<length(PER_snr))
        snr_idx = snr_idx+1;
    end

    % Return output
    out_vec = reshape(testch_out.', 4*in_len, 1);

else  %%%%%%%%%%%%%%%  TGn Channel Model D

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% For Channel D (NLOS) %%%%%
chD_K = -inf;  %%% not used (since NLOS), K = -inf dB 
chD_dly    = [    0     10     20     30     40     50     60     70     80     90    110    140    170    200    240    290    340    390];
chD_wdth   = [   10     10     10     10     10     10     10     10     10     20     30     30     30     40     50     50     50     50];
% Cluster 1 - tap powers, delays
chD_pow_c1 = [    0   -0.9   -1.7   -2.6   -3.5   -4.3   -5.2   -6.1   -6.9   -7.8   -9.0  -11.1  -13.7  -16.3  -19.3  -23.2   -inf   -inf];
chD_aoa_c1 = [158.9  158.9  158.9  158.9  158.9  158.9  158.9  158.9  158.9  158.9  158.9  158.9  158.9  158.9  158.9  158.9  158.9  158.9];
chD_asa_c1 = [ 27.7   27.7   27.7   27.7   27.7   27.7   27.7   27.7   27.7   27.7   27.7   27.7   27.7   27.7   27.7   27.7   27.7   27.7];
chD_aod_c1 = [332.1  332.1  332.1  332.1  332.1  332.1  332.1  332.1  332.1  332.1  332.1  332.1  332.1  332.1  332.1  332.1  332.1  332.1];
chD_asd_c1 = [ 27.4   27.4   27.4   27.4   27.4   27.4   27.4   27.4   27.4   27.4   27.4   27.4   27.4   27.4   27.4   27.4   27.4   27.4];
% Cluster 2 - tap powers, delays
chD_pow_c2 = [ -inf   -inf   -inf   -inf   -inf   -inf   -inf   -inf   -inf   -inf   -6.6   -9.5  -12.1  -14.7  -17.4  -21.9  -25.5   -inf];
chD_aoa_c2 = [320.2  320.2  320.2  320.2  320.2  320.2  320.2  320.2  320.2  320.2  320.2  320.2  320.2  320.2  320.2  320.2  320.2  320.2];
chD_asa_c2 = [ 31.4   31.4   31.4   31.4   31.4   31.4   31.4   31.4   31.4   31.4   31.4   31.4   31.4   31.4   31.4   31.4   31.4   31.4];
chD_aod_c2 = [ 49.3   49.3   49.3   49.3   49.3   49.3   49.3   49.3   49.3   49.3   49.3   49.3   49.3   49.3   49.3   49.3   49.3   49.3];
chD_asd_c2 = [ 32.1   32.1   32.1   32.1   32.1   32.1   32.1   32.1   32.1   32.1   32.1   32.1   32.1   32.1   32.1   32.1   32.1   32.1];
% Cluster 3 - tap powers, delays
chD_pow_c3 = [ -inf   -inf   -inf   -inf   -inf   -inf   -inf   -inf   -inf   -inf   -inf   -inf   -inf   -inf  -18.8  -23.2  -25.2  -26.7];
chD_aoa_c3 = [276.1  276.1  276.1  276.1  276.1  276.1  276.1  276.1  276.1  276.1  276.1  276.1  276.1  276.1  276.1  276.1  276.1  276.1];
chD_asa_c3 = [ 37.4   37.4   37.4   37.4   37.4   37.4   37.4   37.4   37.4   37.4   37.4   37.4   37.4   37.4   37.4   37.4   37.4   37.4];
chD_aod_c3 = [275.9  275.9  275.9  275.9  275.9  275.9  275.9  275.9  275.9  275.9  275.9  275.9  275.9  275.9  275.9  275.9  275.9  275.9];
chD_asd_c3 = [ 36.8   36.8   36.8   36.8   36.8   36.8   36.8   36.8   36.8   36.8   36.8   36.8   36.8   36.8   36.8   36.8   36.8   36.8];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_taps = length(chD_dly);

% define imag. component
j = sqrt(-1);

% Initialize channel model
if (Clk==0)

    snr_idx = 1;
    
    % Initialize random generator
    %12345
    %randn('state',12345);

    % initialize variables
    snc_idxs = zeros(num_taps, 12, 16);
    snc_dlys = zeros(num_taps, 12, 16);
    P_tap  = zeros(num_taps, 1);
    Kf_tap = zeros(num_taps, 1);
    Kv_tap = zeros(num_taps, 1);
    R_tx   = zeros(Ntx, Ntx, num_taps);
    R_rx   = zeros(Nrx, Nrx, num_taps);

    % Initialize channel delay line
    tot_dly = sum(chD_wdth)/10;
    H_dline = zeros(Ntx, tot_dly);
    
    % Initialize calculations for each tap
    for m=1:num_taps
        
        % initialize Doppler-filtered, Rayleigh fading for tap
        for y=1:16 % max size = 4x4
            s_idxs = 0;
            s_dlys = 0;
            [out_val, s_dlys, s_idxs] = sinc_dop_rv(s_dlys, s_idxs, 256);
            snc_idxs(m,:,y) = s_idxs;
            snc_dlys(m,:,y) = s_dlys;
        end
        
        % Compute overall tap power
        P_tap(m) = 10^(chD_pow_c1(m)/10) + 10^(chD_pow_c2(m)/10) + 10^(chD_pow_c3(m)/10);
        P_tap(m) = sqrt(P_tap(m));
        % Compute K-factor for tap (convert dB to linear)
        if (m==1)  K = 10^(chD_K/10);
        else       K = 0;              end
        Kf_tap(m) = sqrt(K/(K+1));
        Kv_tap(m) = sqrt(1/(K+1));
        % Compute correlation matrices
        sq2 = sqrt(2);
        ds=pi;    % antenna spacing
        Dc = 4;   % matrix index for distance zero
        ci=1:3;   % cluster index vector
        mxx=1:20;  % 2nd sum index vector, Rxx
        mxy=0:20;  % 2nd sum index vector, Rxy
        dph=60*(pi/180); % delta phi = pi (-180 to +180 degrees)
        Q = [ 10^(chD_pow_c1(m)/10) 10^(chD_pow_c2(m)/10) 10^(chD_pow_c3(m)/10) ];
        otx  = (pi/180)*[ chD_asd_c1(m) chD_asd_c2(m) chD_asd_c3(m) ];
        orx  = (pi/180)*[ chD_asa_c1(m) chD_asa_c2(m) chD_asa_c3(m) ];
        phtx = (pi/180)*[ chD_aod_c1(m) chD_aod_c2(m) chD_aod_c3(m) ];
        phrx = (pi/180)*[ chD_aoa_c1(m) chD_aoa_c2(m) chD_aoa_c3(m) ];
        % Tx correlations...
        normQtx = sum(Q.*(1-exp(-sq2*dph./otx)));   % norm. constants
        Qtx = Q/normQtx;
        for D = -3:3
            Rxx_c1 = sum( besselj(2*mxx,D*ds)./((sq2/otx(1)).^2+(2*mxx).^2).*cos(2*mxx*phtx(1)).*...
                          (sq2/otx(1) + exp(-dph*sq2/otx(1)).*(2*mxx.*sin(2*mxx*dph) - (sq2/otx(1))*cos(2*mxx*dph))) );
            Rxx_c2 = sum( besselj(2*mxx,D*ds)./((sq2/otx(2)).^2+(2*mxx).^2).*cos(2*mxx*phtx(2)).*...
                          (sq2/otx(2) + exp(-dph*sq2/otx(2)).*(2*mxx.*sin(2*mxx*dph) - (sq2/otx(2))*cos(2*mxx*dph))) );
            Rxx_c3 = sum( besselj(2*mxx,D*ds)./((sq2/otx(3)).^2+(2*mxx).^2).*cos(2*mxx*phtx(3)).*...
                          (sq2/otx(3) + exp(-dph*sq2/otx(3)).*(2*mxx.*sin(2*mxx*dph) - (sq2/otx(3))*cos(2*mxx*dph))) );
            Rxx_c = [Rxx_c1 Rxx_c2 Rxx_c3];
            Rxx(Dc+D) = besselj(0,D*ds)+4*sum(Qtx./(otx.*sq2).*Rxx_c);
            % cross-correlation, real and imag
            Rxy_c1 = sum( besselj(2*mxy+1,D*ds)./((sq2/otx(1)).^2+(2*mxy+1).^2).*sin((2*mxy+1)*phtx(1)).*...
                          (sq2/otx(1) - exp(-dph*sq2/otx(1)).*((2*mxy+1).*sin((2*mxy+1)*dph) + (sq2/otx(1))*cos((2*mxy+1)*dph))) );
            Rxy_c2 = sum( besselj(2*mxy+1,D*ds)./((sq2/otx(2)).^2+(2*mxy+1).^2).*sin((2*mxy+1)*phtx(2)).*...
                          (sq2/otx(2) - exp(-dph*sq2/otx(2)).*((2*mxy+1).*sin((2*mxy+1)*dph) + (sq2/otx(2))*cos((2*mxy+1)*dph))) );
            Rxy_c3 = sum( besselj(2*mxy+1,D*ds)./((sq2/otx(3)).^2+(2*mxy+1).^2).*sin((2*mxy+1)*phtx(3)).*...
                          (sq2/otx(3) - exp(-dph*sq2/otx(3)).*((2*mxy+1).*sin((2*mxy+1)*dph) + (sq2/otx(3))*cos((2*mxy+1)*dph))) );
            Rxy_c = [Rxy_c1 Rxy_c2 Rxy_c3];
            Rxy(Dc+D) = 4*sum(Qtx./(otx.*sq2).*Rxy_c);
        end
        % Form Tx corr. matrix
        Rtx = [ Rxx(Dc)   Rxx(Dc+1) Rxx(Dc+2) Rxx(Dc+3); ...
                Rxx(Dc-1) Rxx(Dc)   Rxx(Dc+1) Rxx(Dc+2); ...
                Rxx(Dc-2) Rxx(Dc-1) Rxx(Dc)   Rxx(Dc+1); ...
                Rxx(Dc-3) Rxx(Dc-2) Rxx(Dc-1) Rxx(Dc)    ];
        Rtx = Rtx + j*...
              [ Rxy(Dc)   Rxy(Dc+1) Rxy(Dc+2) Rxy(Dc+3); ...
                Rxy(Dc-1) Rxy(Dc)   Rxy(Dc+1) Rxy(Dc+2); ...
                Rxy(Dc-2) Rxy(Dc-1) Rxy(Dc)   Rxy(Dc+1); ...
                Rxy(Dc-3) Rxy(Dc-2) Rxy(Dc-1) Rxy(Dc)    ];
        Rtx = Rtx(1:Ntx,1:Ntx); % keep only Ntx-by-Ntx elements
        R_tx(:,:,m) = Rtx^(1/2);
        
        % Rx correlations...
        normQrx = sum(Q.*(1-exp(-sq2*dph./orx)));   % norm. constants
        Qrx = Q/normQrx;
        for D = -3:3
            % cross-correlation, real parts
            Rxx_c1 = sum( besselj(2*mxx,D*ds)./((sq2/orx(1)).^2+(2*mxx).^2).*cos(2*mxx*phrx(1)).*...
                          (sq2/orx(1) + exp(-dph*sq2/orx(1)).*(2*mxx.*sin(2*mxx*dph) - (sq2/orx(1))*cos(2*mxx*dph))) );
            Rxx_c2 = sum( besselj(2*mxx,D*ds)./((sq2/orx(2)).^2+(2*mxx).^2).*cos(2*mxx*phrx(2)).*...
                          (sq2/orx(2) + exp(-dph*sq2/orx(2)).*(2*mxx.*sin(2*mxx*dph) - (sq2/orx(2))*cos(2*mxx*dph))) );
            Rxx_c3 = sum( besselj(2*mxx,D*ds)./((sq2/orx(3)).^2+(2*mxx).^2).*cos(2*mxx*phrx(3)).*...
                          (sq2/orx(3) + exp(-dph*sq2/orx(3)).*(2*mxx.*sin(2*mxx*dph) - (sq2/orx(3))*cos(2*mxx*dph))) );
            Rxx_c = [Rxx_c1 Rxx_c2 Rxx_c3];
            Rxx(Dc+D) = besselj(0,D*ds)+4*sum(Qrx./(orx.*sq2).*Rxx_c);
            % cross-correlation, real and imag
            Rxy_c1 = sum( besselj(2*mxy+1,D*ds)./((sq2/orx(1)).^2+(2*mxy+1).^2).*sin((2*mxy+1)*phrx(1)).*...
                          (sq2/orx(1) - exp(-dph*sq2/orx(1)).*((2*mxy+1).*sin((2*mxy+1)*dph) + (sq2/orx(1))*cos((2*mxy+1)*dph))) );
            Rxy_c2 = sum( besselj(2*mxy+1,D*ds)./((sq2/orx(2)).^2+(2*mxy+1).^2).*sin((2*mxy+1)*phrx(2)).*...
                          (sq2/orx(2) - exp(-dph*sq2/orx(2)).*((2*mxy+1).*sin((2*mxy+1)*dph) + (sq2/orx(2))*cos((2*mxy+1)*dph))) );
            Rxy_c3 = sum( besselj(2*mxy+1,D*ds)./((sq2/orx(3)).^2+(2*mxy+1).^2).*sin((2*mxy+1)*phrx(3)).*...
                          (sq2/orx(3) - exp(-dph*sq2/orx(3)).*((2*mxy+1).*sin((2*mxy+1)*dph) + (sq2/orx(3))*cos((2*mxy+1)*dph))) );
            Rxy_c = [Rxy_c1 Rxy_c2 Rxy_c3];
            Rxy(Dc+D) = 4*sum(Qrx./(orx.*sq2).*Rxy_c);
        end
        % Form Rx corr. matrix
        Rrx = [ Rxx(Dc)   Rxx(Dc+1) Rxx(Dc+2) Rxx(Dc+3); ...
                Rxx(Dc-1) Rxx(Dc)   Rxx(Dc+1) Rxx(Dc+2); ...
                Rxx(Dc-2) Rxx(Dc-1) Rxx(Dc)   Rxx(Dc+1); ...
                Rxx(Dc-3) Rxx(Dc-2) Rxx(Dc-1) Rxx(Dc)    ];
        Rrx = Rrx + j*...
              [ Rxy(Dc)   Rxy(Dc+1) Rxy(Dc+2) Rxy(Dc+3); ...
                Rxy(Dc-1) Rxy(Dc)   Rxy(Dc+1) Rxy(Dc+2); ...
                Rxy(Dc-2) Rxy(Dc-1) Rxy(Dc)   Rxy(Dc+1); ...
                Rxy(Dc-3) Rxy(Dc-2) Rxy(Dc-1) Rxy(Dc)    ];
        Rrx = Rrx(1:Nrx,1:Nrx); % keep only Nrx-by-Nrx elements
        R_rx(:,:,m) = (Rrx^(1/2)).';
    end
end

% Without Doppler, generate channel matrices
if (test_setup==1)
    H_tap = zeros(Nrx,Ntx,num_taps);
    for m=1:num_taps
        % Gaussian RV's for Rayleigh fading
        H_iid = randn(Nrx, Ntx) + j*randn(Nrx, Ntx);
        H_iid = H_iid/sqrt(2);
        
        % Fixed, LOS matrix
        H_f = ones(Nrx, Ntx);   % LOS (since AoA=AoD=45)

        % Variable, NLOS matrix (Rayleigh matrix)
        H_v = R_rx(:,:,m)*H_iid*R_tx(:,:,m);

        % Compute channel tap
        H_tap(:,:,m) = P_tap(m)*( Kf_tap(m)*H_f + Kv_tap(m)*H_v );
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

        % With Doppler, update 'H_tap' every sample
        if (test_setup==2)
            % Generate Doppler-filtered, Rayleigh fading
            H_iid = zeros(1, Nrx*Ntx);
            for y=1:Nrx*Ntx
                s_idxs = snc_idxs(m,:,y);
                s_dlys = snc_dlys(m,:,y);
                [out_val, s_dlys, s_idxs] = sinc_dop_rv(s_dlys, s_idxs, 256);
                snc_idxs(m,:,y) = s_idxs;
                snc_dlys(m,:,y) = s_dlys;
                H_iid(y) = out_val;
            end
            H_iid = reshape(H_iid, Nrx, Ntx);
        
            % Fixed, LOS matrix
            H_f = ones(Nrx, Ntx);   % LOS (since AoA=AoD=45)

            % Variable, NLOS matrix (Rayleigh matrix)
            H_v = R_rx(:,:,m)*H_iid*R_tx(:,:,m);

            % Compute channel tap
            H_tap(:,:,m) = P_tap(m)*( Kf_tap(m)*H_f + Kv_tap(m)*H_v );
        end
    
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
    end
        
    % Store channel output
    ch_out(1:Nrx,i) = H_out;
end

% Add AWGN to Rx streams (reduce by 5dB, due to upsampling)
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
    
end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%