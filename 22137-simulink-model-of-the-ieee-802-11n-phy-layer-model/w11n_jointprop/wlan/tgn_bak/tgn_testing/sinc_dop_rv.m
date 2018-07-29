function [out_val, snc_dlys, snc_idxs] = sinc_dop_rv(snc_dlys, snc_idxs, upfac)
% Function to generate sinc-interpolated, Doppler-filtered Gaussian RV's
global dop_idx dop_buf;

j=sqrt(-1);

% Sinc interp. parameters
n_dlys = 12;
upfac = 1724008;

if (length(snc_idxs)==1)
    % Generate first 256 samples of Doppler-filtered, Rayleigh fading sim.    
    dop_buf = rayleigh_dop(0);
    dop_idx = 1; % reset buffer
    
    % init. sinc interp indices
    snc_idxs = -upfac*(-n_dlys/2:n_dlys/2-1); 
    % init. sinc interp delay line (Gaussian RV's)
    snc_dlys = dop_buf(dop_idx:(dop_idx+n_dlys-1));
    dop_idx = dop_idx + n_dlys;
end

% Run upsampling filter
out_val = sum(sinc(snc_idxs/upfac).*snc_dlys);

% Delay lines for upsampling
snc_idxs = snc_idxs + 1;
if (snc_idxs(n_dlys/2+1) >= upfac)
    snc_idxs = snc_idxs - upfac;
    % adjust delayline
    snc_dlys(1:end-1) = snc_dlys(2:end);
    % add new sample
    snc_dlys(end) = dop_buf(dop_idx);
    dop_idx = dop_idx + 1;
    if (dop_idx>256)
        dop_buf = rayleigh_dop(0);
        dop_idx = 1; % reset buffer
    end
end
