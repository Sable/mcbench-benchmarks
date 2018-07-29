
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Forward FFT w.r.t. the second variable %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fs=fty(s);
 fs=fftshift(fft(fftshift(s.'))).';

