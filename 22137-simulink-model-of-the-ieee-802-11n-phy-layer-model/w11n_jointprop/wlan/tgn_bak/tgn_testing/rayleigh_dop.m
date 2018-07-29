function [dop_buf] = rayleigh_dop(in_val)
% Function to generate Doppler-filtered Rayleigh fading simulator

% Doppler parameters
vo = (1.2*1000/3600);    % vo = 1.2 km/h  ->  0.333 m/s
lambda = 3e8 / 5.4e9;    % lambda = c / fc;
fd = vo/lambda;          % Doppler Spread (around 6 Hz)

% Generate Doppler Sf (256 points)
f_rng = 10*fd;
f = -f_rng/2 : f_rng/255 : f_rng/2;
dop_Sf = 1./(1+9*(f/fd).^2);

% Generate 256 samples of Doppler-filtered, Rayleigh fading sim.    
dop_buf1(129:256) = randn(1,128)+j*randn(1,128);
dop_buf1(  1:128) = conj(dop_buf1(256:-1:129));
dop_buf2(129:256) = randn(1,128)+j*randn(1,128);
dop_buf2(  1:128) = conj(dop_buf2(256:-1:129));
dop_buf1 = ifft(dop_buf1 .* dop_Sf);
dop_buf2 = ifft(dop_buf2 .* dop_Sf);
dop_buf = sqrt(dop_buf1.^2 + dop_buf2.^2);
