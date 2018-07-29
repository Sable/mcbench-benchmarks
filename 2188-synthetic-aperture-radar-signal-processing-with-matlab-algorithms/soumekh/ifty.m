
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inverse FFT w.r.t. the second variable %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function s=ifty(fs);
 s=fftshift(ifft(fftshift(fs.'))).';

