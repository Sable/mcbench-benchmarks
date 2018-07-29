
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Forward FFT w.r.t. the first variable %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fs=ftx(s);
 fs=fftshift(fft(fftshift(s)));


