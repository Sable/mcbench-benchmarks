function SNR = snr(signal, noise, typ, noisy)
% snr - calculate signal-to-noise ratio in decibel or amplitude
%
% Syntax: SNR = snr(signal, noise)
%         SNR = snr(signal, signal_noise, typ, true)
%
% Inputs:
%  signal - signal amplitude
%   noise - noise amplitude or noisy signal
%     typ - type of SNR (default:'db' to decibel or 'amp' to amplitude)
%   noisy - eval noise flag (use noise as noisy signal)
%
% Outputs:
%    SNR - Signal-to-Noise Ratio
%
% Example:
%   dt = 0.01;
%   T = 0:dt:10;
%   sig = sin(2*pi*T);
%   noisy = sig + (0 + .5 * randn(1,length(T)));   % error mean 0 and sd .5
%   snr_db = snr(sig,noisy,'db',true)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: rms
%
% See also: none;

% Author: Marco Borges, Ph.D. Student, Computer/Biomedical Engineer
% UFMG, PPGEE, Neurodinamica Lab, Brazil
% email address: marcoafborges@gmail.com
% Website: http://www.cpdee.ufmg.br/
% September 2013; Version: v1; Last revision: 2013-09-19
% Changelog:
%------------------------------- BEGIN CODE -------------------------------
if ~exist('typ', 'var')
    typ = 'db';
end
if ~exist('noisy', 'var')
    noisy = false;
end

if noisy % eval noise
    noise = signal-noise;
end

if strcmp(typ,'db')
    SNR = 20*log10(rms(signal)/rms(noise));
elseif strcmp(typ,'amp')
    SNR = rms(signal)/rms(noise);
end
end
%-------------------------------- END CODE --------------------------------