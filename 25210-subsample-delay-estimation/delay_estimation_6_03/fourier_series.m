function y=fourier_series(Y,t);
%y=fourier_series(Y,t);
%Calculates the fourier series (i.e. the inverse fft for a single point,
%not necessarily on an integer sample).
%Assumes the ifft(Y) is real and has an even number of points.

%    Copyright Travis Wiens 2009 travis.mlfx@nutaksas.com

N_Y=numel(Y);
C_n=1/N_Y;

y=C_n*real(Y(1))*ones(1,numel(t));%mean
y=y+2*C_n*real(Y(2:(N_Y/2))*exp(2j*pi*C_n*(1:(N_Y/2-1))'*t));
%for real valued output, Y above Nyquist is complex conjugate
y=y+C_n*real(Y(N_Y/2+1)*exp(2j*pi*C_n*N_Y/2'*t));%Nyquist frequency
